Filter to be used to filter the results:
* A string that uses "*" as a wildcard, for example, "*.cfm"
* a UDF (User defined Function) with signature `Boolean function(String path)`. The function is run for each file in turn; if the function returns `true`, then the file is will be added to the result; otherwise it will be omitted.
