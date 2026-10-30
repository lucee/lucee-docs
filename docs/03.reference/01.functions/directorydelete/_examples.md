```luceescript
directorydelete("DirectoryPath");
```

**Do not throw when the directory does not exist** ( since Lucee 9.0.0.564 )

```luceescript
// no exception when the directory is already gone, for example when another thread removed it
directoryDelete( path="my/path/to/dir", recurse=true, throwOnMissing=false );
```
