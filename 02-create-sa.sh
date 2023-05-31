#!/bin/bash

source variables.inc

# Create Service Account 

SA_FULL="${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com"

gcloud iam service-accounts create ${SA_NAME} \
       --description="Service account for BQ Recommender Export" \
       --display-name="${SA_NAME}" --project="${PROJECT_ID}"

# Apply Permissions
# https://cloud.google.com/recommender/docs/bq-export/export-recommendations-to-bq#requiredpermissions

### Project Level
# bigquery.transfers.update - Allows you to create the transfer
# bigquery.datasets.update - Allows you to update actions on the target dataset
# resourcemanager.projects.update - Allows you to select a project where you'd like the export data to be stored
# pubsub.topics.list - Allows you to select a Pub/Sub topic in order to receive notifications about your export

gcloud projects add-iam-policy-binding "${PROJECT_ID}" --member=serviceAccount:$SA_FULL --role=roles/bigquery.admin
gcloud projects add-iam-policy-binding "${PROJECT_ID}" --member=serviceAccount:$SA_FULL --role=roles/resourcemanager.projectMover
gcloud projects add-iam-policy-binding "${PROJECT_ID}" --member=serviceAccount:$SA_FULL --role=roles/pubsub.viewer

### Organization Level
# recommender.resources.export - Allows you to export recommendations to BigQuery
gcloud organizations add-iam-policy-binding "${ORGANIZATION_ID}" --member=serviceAccount:$SA_FULL --role=roles/recommender.exporter

## Negotiated Prices
### Project Level
# billing.resourceCosts.get
#gcloud projects add-iam-policy-binding "${PROJECT_ID}" --member=serviceAccount:$SA_FULL --role=roles/

### Billing Account Level
# billing.accounts.getSpendingInformation
gcloud alpha billing accounts add-iam-policy-binding ${BILLING_ACCOUNT} --member=serviceAccount:$SA_FULL --role=roles/billing.costsManager