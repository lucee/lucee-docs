To return an array of file paths that end with the substring `.log` from a the directory `/var/data`:

```luceescript
    directoryList("/var/data", false, "path", function(path){ return arguments.path.hasSuffix(".log"); })
```
