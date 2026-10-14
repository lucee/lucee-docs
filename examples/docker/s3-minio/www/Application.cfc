component {

    this.name = "lucee-s3";
    // configure the S3 virtual filesystem using credentials from environment variables
    // defined in docker-compose.yml — this enables s3:// paths throughout the application
    this.vfs.s3.accessKeyId      = server.system.environment.LUCEE_S3_ACCESSKEYID;
    this.vfs.s3.awsSecretKey     = server.system.environment.LUCEE_S3_SECRETACCESSKEY;
    this.vfs.s3.host             = server.system.environment.LUCEE_S3_HOST;
    this.vfs.s3.defaultLocation  = server.system.environment.LUCEE_S3_REGION;
    this.vfs.s3.pathStyleAccess = true;
    this.vfs.s3.ssl = false;
}
