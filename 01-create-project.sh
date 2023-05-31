#!/bin/bash

source variables.inc

# Ensure that user running commands has the right permissions



# Create the project where we will store recommendations in BQ and run jobs

gcloud projects create $PROJECT_ID --organization=${ORGANIZATION_ID}
gcloud config set project $PROJECT_ID 

# Attach Billing
gcloud beta billing projects link $PROJECT_ID --billing-account=$BILLING_ACCOUNT

PROJECT_NUM=`gcloud config get-value project`

echo "Project named ${PROJECT_ID} created with project number of ${PROJECT_NUM}"
