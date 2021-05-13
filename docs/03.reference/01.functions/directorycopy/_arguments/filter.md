Filter to be used to filter the data copied:

- A string that uses "*" as a wildcard, for example, "*.cfm"
- An UDF (User defined Function) using the following pattern "functioname(String path):boolean", the function is run for every single file, if the function returns true, then the file is will be added to the list otherwise it will be omitted
