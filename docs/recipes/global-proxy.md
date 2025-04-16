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

### Include

You can limit the proxy to specific hosts by defining a list (or array) of hosts it should be used for:

```lucee
this.proxy = {
    server: "myproxy.com",
    port: 1234,
    username: "susi",
    password: "sorglos",
    includes: "whatever.com,lucee.org"
};
```

### Exclude

Or you can do the opposite, defining for which hosts it should not apply:

```lucee
this.proxy = {
    server: "myproxy.com",
    port: 1234,
    username: "susi",
    password: "sorglos",
    excludes: ["lucee.org", "whatever.com"]
};
```

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
    "includes": "good.org",
    "excludes": "bad.com,whatever.com"
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
- **includes** - Comma-delimited list or array of hosts that should use the proxy
- **excludes** - Comma-delimited list or array of hosts that should not use the proxy

Note that you cannot use both `includes` and `excludes` at the same time - you must choose one approach.