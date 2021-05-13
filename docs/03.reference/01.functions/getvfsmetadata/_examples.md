```luceescript+trycf
    loop list="ram,file,s3,http,https,zip,tar" item="vfs"{
        dump(var=getVFSMetaData(vfs), label="#vfs#");
    }
```
