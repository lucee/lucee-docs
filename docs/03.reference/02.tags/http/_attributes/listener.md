Listener for the http request.

The listener can have 3 (optional) functions, `before`, `after` and `error` that get triggered before sending the request, after receiving the response and in case of an exception.

The functions get all data about the request (`args`, with the attributes of the tag and the `params`) and the `caller`. `after` also gets the `result` and `error` the `exception`.

This attribute overwrites any http listener defined in the `application.cfc/cfapplication`.

`before` can modify the request and `after` the response, by returning a struct containing the keys to overwrite following the same structure as the input coming in the argument scope. `before` can also answer the request itself by returning a struct as `result`, in that case no request is sent. `error` can handle the exception by returning a `result`, otherwise the exception is thrown.

The listener can be a component looking like this:

```
component {
    function before( args, caller ){}
    function after( args, caller, result ){}
    function error( args, caller, exception ){}
}
```

or a struct looking like this:

```
{
    before:function(...){},
    after:function(...){},
    error:function(...){}
}
```

See [[http-listeners]] for details.