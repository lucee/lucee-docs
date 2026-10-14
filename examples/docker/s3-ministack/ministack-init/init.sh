#!/bin/sh
set -e

export AWS_ACCESS_KEY_ID=test
export AWS_SECRET_ACCESS_KEY=test
export AWS_DEFAULT_REGION=us-east-1
ENDPOINT=http://ministack:4566

# Create example buckets
aws --endpoint-url=$ENDPOINT s3 mb s3://my-bucket
aws --endpoint-url=$ENDPOINT s3 mb s3://uploads

# Seed some example objects into my-bucket
echo "Hello from MiniStack!" | aws --endpoint-url=$ENDPOINT s3 cp - s3://my-bucket/hello.txt
echo '{"message":"S3 works with Lucee","provider":"MiniStack"}' | aws --endpoint-url=$ENDPOINT s3 cp - s3://my-bucket/data.json

echo "MiniStack initialised: buckets and seed objects created."