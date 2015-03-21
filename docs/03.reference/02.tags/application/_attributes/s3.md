
A struct that defines default S3 settings, this settings can be overwritten as part of the S3 file path, the following keys are supported:
- accessKeyId: S3 access key id
- awsSecretKey: AWS (Amazon Web Service) Secret Key
- defaultLocation(default:us): region for the bucket, possible values are [eu,us,us-west]
- host(default:"s3.amazonaws.com"): hostname of the service
