If set to true, lucee uses the storage backend for the client scope as master and Lucee checks for changes in the storage backend with every request.

If set to false (default), the storage is only used as slave, lucee only initially gets the data from the storage. Ignored for storage type "memory".
