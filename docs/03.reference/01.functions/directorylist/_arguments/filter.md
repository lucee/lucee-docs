Specifies a filter to be used to filter the results:

- A string that uses `*` as a wildcard, for example, `*.cfm`
- UDF (User Defined Function) using the following pattern: `boolean function(String path, String type, String ext)`. The function is run for every single file; if the function returns `true`, the file is included in the list; otherwise, it is omitted. `Type` is either `File` or `Directory`

`Type` and `Ext` arguments were added in Lucee 6.0
