```luceescript+trycf

    message = 'this is a test';
    key = 'ABC123';

    // Using the required fields only
    result = HMAC( message, key );
    writeDump( result ); // 776770430C93778AD6F91B43A4A30B69


    // Using the optional algorithm parameter (HmacSHA1)
    algorithm = 'HmacSHA1';
    result = HMAC( message, key, algorithm );
    writeDump( result ); // 049E53BAE339C4A05587D7BBBA2857548E8FC327


    // Using the optional algorithm parameter (HmacSHA256)
    algorithm = 'HmacSHA256';
    result = HMAC( message, key, algorithm );
    writeDump( result ); // 0503949602EDE3FF61C84F4CE51C99EEA2961CAA144AEE552F7D120AD6A60D7D


    // Using the optional encoding parameter (UTF-8)
    encoding = 'UTF-8';
    result = HMAC( message, key, algorithm, encoding );
    writeDump( result ); // 0503949602EDE3FF61C84F4CE51C99EEA2961CAA144AEE552F7D120AD6A60D7D

```
