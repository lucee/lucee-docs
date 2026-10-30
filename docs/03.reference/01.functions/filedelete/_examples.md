```luceescript+trycf
fileDelete("my/path/to/file.md")
```

**Do not throw when the file does not exist** ( since Lucee 9.0.0.564 )

```luceescript
// no exception when the file is already gone, for example when another thread removed it
fileDelete( file="my/path/to/file.md", throwOnMissing=false );
```
