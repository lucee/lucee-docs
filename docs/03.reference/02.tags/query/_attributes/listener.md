Listener for the query.

The listener can have 3 (optional) functions, `before`, `after` and `error` that get triggered before and after executing the query and in case of an exception.

The functions get all data about the query.

This attributes overwrites any query listener defined in the `application.cfc/cfapplication`.

All the functions can also modify all data, by returning a struct containing the keys to overwrite following the same structure as the input coming in the argument scope.

The listener can be a component looking like this:

```
component {
    function before( cachedAfter, cachedWithin, columnName, datasource, dbType, debug,
        maxRows, name, ormOptions, username, password, result,
        returnType, timeout, timezone, unique, sql, args, params, caller){}
    function after( result, meta, cachedAfter, cachedWithin, columnName, datasource,
        dbType, debug, maxRows, name, ormOptions, username, password, result,
        returnType, timeout, timezone, unique, sql, args, params, caller){}
    function error(exception, lastExecution, nextExecution, created, id, type, detail,
        tries, remainingTries, closed, caller, advanced, passed, exception){}
}
```

or a struct looking like this:

```
component {
    before:function(...){},
    after:function(...){},
    error:function(...){}}
```