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
#gcloud alpha services api-keys create --api-target=service=bigquerydatatransfer.googleapis.com

# Get UID of API KEY that we just created (sort by most recent, max 1)
#API_UID=`gcloud beta services api-keys list --sort-by=-createTime --limit=1 --format="value(uid)"`

# Get Key String from API KEY
#API_KEY=`gcloud beta services api-keys get-key-string ${API_UID} --format="value(keyString)"`

## ACTION REQUIRED ##
## NEEDS OAUTH troubleshooting.... ##
# Try this:
# https://gist.github.com/LindaLawton/cff75182aac5fa42930a09f58b63a309
# and this
# https://stackoverflow.com/questions/66940072/get-google-oauth2-access-token-using-only-curl

# Work Around - Do from Console Here:
# https://cloud.google.com/bigquery/docs/reference/datatransfer/rest/v1/projects/enrollDataSources

#curl --request POST \
#  'https://bigquerydatatransfer.googleapis.com/v1/projects/'${PROJECT_ID}':enrollDataSources?key='${API_KEY}'' \
#  --header 'Authorization: Bearer ' $(gcloud auth print-identity-token) \
#  --header 'Accept: application/json' \
#  --header 'Content-Type: application/json' \
#  --data '{"dataSourceIds":["6063d10f-0000-2c12-a706-f403045e6250"]}' \
#  --compressed

echo""
echo""
echo "Open the following URL to enable the Recommender Data Source:"
echo "https://cloud.google.com/bigquery/docs/reference/datatransfer/rest/v1/projects/enrollDataSources?apix_params=%7B%22name%22%3A%22projects%2F${PROJECT_ID}%22%2C%22resource%22%3A%7B%22dataSourceIds%22%3A%5B%226063d10f-0000-2c12-a706-f403045e6250%22%5D%7D%7D"
echo ""
echo "Click Execute"

sleep 10
echo "After you have completed the step above"
read -p "Press enter to continue"




# Create Export

bq mk \
--transfer_config \
--project_id=${PROJECT_ID} \
--target_dataset=${DATASET_ID} \
--display_name=${EXPORT_NAME} \
--params='{"organization_id":"'${ORGANIZATION_ID}'"}' \
--data_source='6063d10f-0000-2c12-a706-f403045e6250' \
--service_account_name=${SA_FULL}