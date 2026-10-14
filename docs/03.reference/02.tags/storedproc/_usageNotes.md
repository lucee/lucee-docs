For Oracle datasources, Lucee caches stored procedure metadata for better performance.

If you alter a procedure's signature, you may need to call [[function-datasourceflushmetacache]] to clear the cache without restarting.
