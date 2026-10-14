The arguments used when the cache entry was created. 
Required for cached functions to identify the specific cache entry, as each unique set of arguments creates a separate cache entry. 
Can be provided as an array `[arg1, arg2]` for positional arguments or as a struct `{key: value}` for named arguments. 
Not required for queries or HTTP results.