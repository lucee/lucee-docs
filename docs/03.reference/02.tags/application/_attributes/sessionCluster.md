If set to true, Lucee uses the storage backend for the session scope as the primary source and checks for changes in the storage backend with every request.

If set to false (default), the storage is only used as a replica - Lucee only initially gets the data from the storage. Ignored for storage type "memory".