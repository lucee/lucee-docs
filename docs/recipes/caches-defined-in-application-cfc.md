<!--
{
  "title": "Adding Caches via Application.cfc",
  "id": "caches-defined-in-application-cfc",
  "related": [
    "tag-application"
  ],
  "categories": [
    "application",
    "cache"
  ],
  "menuTitle": "Adding Caches",
  "description": "How to add per-application caches via Application.cfc in Lucee.",
  "keywords": [
    "Caches",
    "Application.cfc",
    "Per-application caches",
    "Cache connections",
    "Default caches",
    "Lucee"
  ]
}
-->

# Caches defined in Application.cfc

Add per-application cache connections in `Application.cfc` (Lucee 5.1+). If using an extension-provided cache driver, the extension must be installed first.

```lucee
this.cache.connections["myCache"] = {
    class: 'org.lucee.extension.cache.eh.EHCache',
    bundleName: 'ehcache.extension',
    bundleVersion: '2.10.0.25',
    storage: false,
    custom: {
        "bootstrapAsynchronously":"true",
        "replicatePuts":"true",
        etc...
    },
    default: 'object'
};
```

Shortcut: `this.cache["myCache"] = {}` (matches datasource syntax).

## Generating Cache Connection code

Generate the code via Lucee Admin:

- Create the cache in Web Admin
- Edit the cache, scroll to bottom
- Copy the code snippet into `Application.cfc`

## Cache metadata

- **class** - Java class of the cache driver
- **bundleName** - OSGi bundle name (optional)
- **bundleVersion** - OSGi bundle version (optional)
- **storage** - Enable for client/session storage
- **custom** - Driver-specific key/value pairs (check driver docs for required values)
- **default** - Set as default for: `function`, `object`, `template`, `query`, `resource`, `include`, `http`, `file`, `webservice`

## Default Caches

Configure default caches for each operation type:

```lucee
this.cache.object = "myCache";
this.cache.template = "AnotherCache";
this.cache.query = "yetAnother";
this.cache.resource = "<cache-name>";
this.cache.function = "<cache-name>";
this.cache.include = "<cache-name>";
this.cache.http = "<cache-name>";
this.cache.file = "<cache-name>";
this.cache.webservice = "<cache-name>";
```

A single cache can only be default for one operation type (e.g. "myCache" can't be default for both objects and queries).
