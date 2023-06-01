#!/bin/bash

source variables.inc

SA_FULL="${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com"

gcloud config set project $PROJECT_ID

# Enable BQ API
gcloud services enable \
  bigquery.googleapis.com \
  bigquerydatatransfer.googleapis.com \
  apikeys.googleapis.com \
  --project=${PROJECT_ID}

# Create BQ Dataset
bq --location=$LOCATION --project_id=${PROJECT_ID} mk --dataset --default_table_expiration 0 $DATASET_ID


# Enroll project in BigQuery data source
# https://cloud.google.com/bigquery-transfer/docs/reference/datatransfer/rest/v1/projects/enrollDataSources
# Datasource to use: 6063d10f-0000-2c12-a706-f403045e6250

# Create API KEY
gcloud alpha services api-keys create --api-target=service=bigquerydatatransfer.googleapis.com

# Get UID of API KEY that we just created (sort by most recent, max 1)
API_UID=`gcloud beta services api-keys list --sort-by=-createTime --limit=1 --format="value(uid)"`

# Get Key String from API KEY
API_KEY=`gcloud beta services api-keys get-key-string ${API_UID} --format="value(keyString)"`

## ACTION REQUIRED ##
## NEEDS OAUTH troubleshooting.... ##
curl --request POST \
  'https://bigquerydatatransfer.googleapis.com/v1/projects/'${PROJECT_ID}':enrollDataSources?key='${API_KEY}'' \
  --header 'Authorization: Bearer ' $(gcloud auth print-identity-token) \
  --header 'Accept: application/json' \
  --header 'Content-Type: application/json' \
  --data '{"dataSourceIds":["6063d10f-0000-2c12-a706-f403045e6250"]}' \
  --compressed

# Create Export

bq mk \
--transfer_config \
--project_id=${PROJECT_ID} \
--target_dataset=${DATASET_ID} \
--display_name=${EXPORT_NAME} \
--params='{"organization_id":"'${ORGANIZATION_ID}'"}' \
--data_source='6063d10f-0000-2c12-a706-f403045e6250' \
--service_account_name=${SA_FULL}