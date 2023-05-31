#!/bin/bash

source variables.inc

SA_FULL="${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com"

# Enable BQ API
gcloud services enable bigquery.googleapis.com --project=${PROJECT_ID}

# Create BQ Dataset
bq --location=$LOCATION --project_id=${PROJECT_ID} mk --dataset --default_table_expiration 0 $DATASET_ID


# Enroll project in BigQuery data source
# https://cloud.google.com/bigquery-transfer/docs/reference/datatransfer/rest/v1/projects/enrollDataSources
# Datasource to use: 6063d10f-0000-2c12-a706-f403045e6250


# Create Export

bq mk \
--transfer_config \
--project_id=${PROJECT_ID} \
--target_dataset=${DATASET_ID} \
--display_name=${EXPORT_NAME} \
--params='{"organization_id":"'${ORGANIZATION_ID}'"}' \
--data_source='6063d10f-0000-2c12-a706-f403045e6250' \
--service_account_name=${SA_FULL}