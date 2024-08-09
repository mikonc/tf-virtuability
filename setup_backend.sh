#!/bin/bash

##### EXPORTING THE VALUES #####
export ACCOUNT_ID=$(aws sts get-caller-identity --query "Account" --output text)
export AWS_REGION=$(aws configure list | grep region | awk '{print $2}')
export BUCKET_NAME="${ACCOUNT_ID}-${AWS_REGION}-terraform-state"
export DYNAMODB_NAME="${ACCOUNT_ID}-${AWS_REGION}-terraform-state-locktable"

##### CREATING THE BUCKET #####
if [[ "${AWS_REGION}" == "us-east-1" ]]; then
    aws s3api create-bucket --bucket $BUCKET_NAME --region $AWS_REGION --acl private
else
    aws s3api create-bucket --bucket $BUCKET_NAME --region $AWS_REGION --acl private --create-bucket-configuration LocationConstraint=$AWS_REGION
fi

##### APPLYING ENCRYPTION & VERSIONING TO THE BUCKET #####
aws s3api put-bucket-encryption --bucket $BUCKET_NAME --server-side-encryption-configuration '{"Rules": [{"ApplyServerSideEncryptionByDefault": {"SSEAlgorithm": "aws:kms"}}]}'
aws s3api put-bucket-versioning --bucket $BUCKET_NAME --versioning-configuration Status=Enabled

##### CREATING DYNAMODB TABLE #####
aws dynamodb create-table --table-name $DYNAMODB_NAME --sse-specification Enabled=true --attribute-definitions AttributeName=LockID,AttributeType=S --key-schema AttributeName=LockID,KeyType=HASH --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5

##### OUTPUT #####
echo "MANAGEMENT_AWS_ACCOUNT_ID: $ACCOUNT_ID"
echo "MANAGEMENT_AWS_REGION_NAME: $AWS_REGION"
echo "TERRAFORM_BACKEND_S3_BUCKET_NAME: $BUCKET_NAME"
echo "TERRAFORM_BACKEND_DYNAMODB_TABLE_NAME: $DYNAMODB_NAME"
