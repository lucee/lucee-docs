#!/bin/bash

echo "Seeding LocalStack..."

# Create a secret in Secrets Manager
awslocal secretsmanager create-secret \
  --name "mysecret" \
  --secret-string '{"username":"admin","password":"sm-secret"}'

# Create a parameter in SSM Parameter Store
awslocal ssm put-parameter \
  --name "myparameter" \
  --value '{"username":"admin","password":"ps-secret"}' \
  --type String

echo "Done seeding."