<!--
{
  "title": "Global Proxy",
  "id": "global-proxy",
  "since": "6.0",
  "description": "Learn how to define a global proxy in Lucee. This guide demonstrates how to set up a global proxy in the Application.cfc file or .CFConfig.json, limit the proxy to specific hosts, and exclude specific hosts from using the proxy.",
  "keywords": [
    "CFML",
    "proxy",
    "global proxy",
    "Lucee",
    "Application.cfc",
    "CFConfig"
  ]
}
-->

# Global Proxy

Since version 6.0, Lucee allows you to define a global proxy that will affect all connections made to the "outside world". There are two ways to configure the global proxy: in the Application.cfc file or in the .CFConfig.json file.

## Configuring Proxy in Application.cfc

You can define a global proxy in the Application.cfc as follows:

```lucee
this.proxy = {
    server: "myproxy.com",
    port: 1234,
    username: "susi",
    password: "sorglos"
};
```

### Target-Specific Proxy Configuration

Lucee provides two mutually exclusive methods to control which hosts use the proxy: **includes** and **excludes**. These options allow you to fine-tune proxy usage based on your application's requirements.

> **Important**: The `includes` and `excludes` options only support exact hostname matches. Wildcards and partial matches are not supported. All hostnames are converted to lowercase for comparison.

#### Using `includes`

The `includes` option specifies a whitelist of hosts that should use the proxy. Any request to a host not in this list will bypass the proxy and connect directly. This is useful when you only need to access specific external services through a proxy.

```lucee
this.proxy = {
    server: "myproxy.com",
    port: 1234,
    username: "susi",
    password: "sorglos",
    includes: "api.example.com,cdn.example.com"
};
```

You can also use an array instead of a comma-delimited list:

```lucee
this.proxy = {
    server: "myproxy.com",
    port: 1234,
    username: "susi",
    password: "sorglos",
    includes: ["api.example.com", "cdn.example.com"]
};
```

#### Using `excludes`

The `excludes` option specifies hosts that should bypass the proxy. All other hosts will use the proxy. This is useful when most of your traffic should go through the proxy, but certain hosts should connect directly.

```lucee
this.proxy = {
    server: "myproxy.com",
    port: 1234,
    username: "susi",
    password: "sorglos",
    excludes: "internal.example.com,localhost"
};
```

You can also use an array instead of a comma-delimited list:

```lucee
this.proxy = {
    server: "myproxy.com",
    port: 1234,
    username: "susi",
    password: "sorglos",
    excludes: ["internal.example.com", "localhost"]
};
```

#### Special Handling for Local Addresses

By default, local addresses (`localhost`, `127.0.0.1`, and `0:0:0:0:0:0:0:1`) are automatically excluded from proxy usage unless explicitly included in the `includes` list. This is a built-in behavior to prevent proxy loops and ensure local connections remain direct.

#### Restrictions

- You cannot use both `includes` and `excludes` in the same proxy configuration. You must choose one approach.
- If you specify an empty list for either `includes` or `excludes`, it will be treated as if the option was not provided.
- All hostname comparisons are case-insensitive.

## Configuring Proxy in .CFConfig.json

In addition to Application.cfc, you can also configure the global proxy in a .CFConfig.json file:

```json
{
  "proxy": {
    "enabled": true,
    "server": "myproxy.com",
    "port": 1234,
    "username": "susi",
    "password": "sorglos",
    "includes": "api.example.com,cdn.example.com",
    "excludes": null
  }
}
```

### Configuration Options

Both methods support the following configuration options:

- **enabled** - Boolean value to enable or disable the proxy (default=true)
- **server** - The hostname or IP address of the proxy server
- **port** - The port number of the proxy server
- **username** - Optional username for proxy authentication
- **password** - Optional password for proxy authentication
- **includes** - Comma-delimited list or array of hosts that should use the proxy (exact match only)
- **excludes** - Comma-delimited list or array of hosts that should not use the proxy (exact match only)

Remember that you cannot use both `includes` and `excludes` at the same time - you must choose one approach. If both are provided, the behavior is undefined and may change in future versions.