<!--
{
  "title": "Http Listeners",
  "id": "http-listeners",
  "since": "9.0",
  "description": "Learn how to define http listeners in Lucee. This guide demonstrates how to set up global http listeners in the Application.cfc file or per cfhttp tag to inspect or manipulate every http request executed, modify the response or handle errors. Examples include defining listeners directly in Application.cfc and using a component as an http listener.",
  "keywords": [
    "http",
    "cfhttp",
    "listener",
    "Application.cfc",
    "component"
  ],
  "related": [
    "tag-http",
    "tag-application",
    "mail-listeners"
  ],
  "categories": [
    "protocols"
  ]
}
-->

# Http Listeners

Define listeners in Application.cfc or on an individual [[tag-http]] tag to intercept or manipulate every http request executed.

A listener can define up to three functions, all of them optional:

- `before` is called before the request is sent and can modify the request.
- `after` is called after the response was received and can modify the response.
- `error` is called when the request throws an exception and can handle it.

### Global per Application.cfc Listeners

```lucee
this.http.listener = {
    before: function (args, caller) {
        // add a header to every request
        args.params.append({ type: "header", name: "X-Request-Source", value: "my-app" });
        return arguments;
    },
    after: function (args, caller, result) {
        systemOutput("#args.method# #args.url# returned #result.statusCode#", true);
    },
    error: function (args, caller, exception) {
        systemOutput("#args.url# failed: #exception.message#", true);
    }
}
```

The same can be set with [[tag-application]] at runtime, using the attribute `httpListener`:

```luceescript
application action="update" httpListener=new HttpListener();
```

The listener can also be a component:

```lucee
this.http.listener = new HttpListener();
```

The component would look like this:

```lucee
component {
    function before(args, caller) {
        args.params.append({ type: "header", name: "X-Request-Source", value: "my-app" });
        return arguments;
    }

    function after(args, caller, result) {
        systemOutput("#args.method# #args.url# returned #result.statusCode#", true);
    }

    function error(args, caller, exception) {
        systemOutput("#args.url# failed: #exception.message#", true);
    }
}
```

### Per tag Listeners

To add a listener to an individual [[tag-http]] tag use the attribute `listener`. A listener defined in the `listener` attribute overwrites any http listener defined in the [[tag-application]]:

```luceescript
listener = new HttpListener();
http url="https://example.org/api" result="rsp" listener=listener {
    httpparam type="header" name="Accept" value="application/json";
}
```

The listener can also be defined inline, as a struct of functions:

```luceescript
http url="https://example.org/api" result="rsp" listener={
    after: function (args, caller, result) {
        result.fileContent = result.fileContent.trim();
        return { result: result };
    }
};
```

### The arguments

All functions get the following arguments:

| Argument | Description |
| --- | --- |
| `args` | The attributes of the tag as a struct: `url`, `method`, `charset`, `timeout`, `connectionTimeout`, `socketTimeout`, `redirect`, `userAgent`, `username`, `password`, `throwOnError`, `result` (the name of the result variable) and `cachedWithin`. Only attributes that are set are part of the struct. `args.params` is an array with one struct per [[tag-httpparam]] containing `type`, `name` and `value` (plus `file`, `mimeType` and `encoded` when set). |
| `caller` | A struct with `template` and `line` of the calling code. |
| `result` | Only for `after`: the response (what is stored in the result variable). |
| `exception` | Only for `error`: the catch block of the exception. |

### before

The `before` function can modify the request by returning a struct. The values returned replace the ones of the tag. Simply return the `arguments` scope after changing `args`, or return only the keys to change:

```luceescript
before: function (args, caller) {
    return { url: "https://example.org/v2/api", method: "POST" };
}
```

The `params` returned replace all params of the tag. Valid types are `url`, `formfield`, `cgi`, `header`, `cookie`, `file`, `xml` and `body`.

`before` can also answer the request on its own, by returning a struct in the key `result`. In that case that struct is used as the response and no request is sent, for example to serve a response from a local store:

```luceescript
before: function (args, caller) {
    return { result: { fileContent: "from my store", statusCode: "200 OK" } };
}
```

### after

The `after` function can replace the response by returning a struct with the key `result`:

```luceescript
after: function (args, caller, result) {
    result.fileContent = ucase(result.fileContent);
    return { result: result };
}
```

`after` is also called when `error` handled an exception.

### error

The `error` function is called when the request throws an exception, for example a timeout, or a status code of 400 or higher when `throwOnError` is set to true. Exceptions are never swallowed. If `error` returns a struct with the key `result`, the exception is handled and that struct is used as the response, otherwise the original exception is thrown:

```luceescript
error: function (args, caller, exception) {
    return { result: { fileContent: "", statusCode: "503 fallback" } };
}
```

### Things to know

- `error` is only called when the tag throws. A failed request with `throwOnError=false` does not throw, inspect the `result` in `after` instead.
- A `cfhttp` executed inside a listener function triggers the listener again, make sure such a call does not end in an endless loop, for example by passing an empty listener (`listener={}`) to that call.
- The listener works for all calls of [[tag-http]], independent of the http client used.
- A listener defined in the `listener` attribute of the tag replaces the listener of the application completely, the functions of both are not combined.
