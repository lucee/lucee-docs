```luceescript
queryExecute(
    sql     = 'SELECT * FROM users  LIMIT 0, 10',
    options = {
        datasource   = "test",
        cachedWithin = CreateTimeSpan(0, 2, 0, 0),
        tags         = 'user_list'
    }
);
```
