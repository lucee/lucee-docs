#!/bin/sh
set -e
 
# Configure mc to talk to the local MinIO instance
mc alias set local http://minio:9000 minioadmin minioadmin
 
# Create example buckets
mc mb --ignore-existing local/my-bucket
mc mb --ignore-existing local/uploads
 
# Seed some example objects into my-bucket
echo "Hello from MinIO!" | mc pipe local/my-bucket/hello.txt
echo '{"message":"S3 works with Lucee","provider":"MinIO"}' | mc pipe local/my-bucket/data.json
 
echo "MinIO initialised: buckets and seed objects created."
 