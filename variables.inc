# Copyright (c) 2023, Jake Holmquist
# All rights reserved.
# 
# This source code is licensed under the BSD-style license found in the
# LICENSE file in the root directory of this source tree. 

# Organization ID
# EXISTING Organization ID is in the format of a number 
ORGANIZATION_ID=

# Billing Account ID
# EXISTING Billing Account ID in the format of: 012345-678910-ABCDEF
BILLING_ACCOUNT=

# Project for Recommender exports to BQ
# to create - must be lowercase and meet project naming requirements
# 6-30 char 12345678901234567890123456789012
PROJECT_ID="recommender-${ORGANIZATION_ID}"

# BQ Dataset name
# change from default if required
DATASET_ID="Recommender"

# Service Account name
# change from default if required
SA_NAME="recommender-sa"

# Location for BQ Dataset
# change from default if required
LOCATION="us"

# Export name
# change from default if required
EXPORT_NAME="bq-rec-export"