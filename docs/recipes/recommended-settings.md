<!--
{
  "title": "Recommended Settings",
  "id": "recommended-settings",
  "description": "A guide on how to configure your Lucee Server for the best performance and highest security.",
  "keywords": [
    "settings",
    "performance",
    "Production server",
    "Security",
    "config"
  ],
  "categories":[
    "server"
  ]
}
-->

## Recommended Settings

By default Lucee ships in compatible mode, so that most CFML applications will just work with developer friendly settings.

When deploying to production, Lucee should be locked down via configuration.

There are also a range of setting which are recommended for peak performance and security.

### Production

[[lucee-lockdown-guide]]

Error templates should be set to `error-public`, which only shows a generic error message, without revealing information about your code or server configuration.

```cfml
// .CFConfig.json or via the Admin, Settings - Error
{
  "errorGeneralTemplate": "/lucee/templates/error/error-public.cfm",
  "errorMissingTemplate": "/lucee/templates/error/error-public.cfm",
}
```

The Lucee Administrator should ideally be disabled, using the `LUCEE_ADMIN_ENABLED=false` see [[running-lucee-system-properties]] or at a minimum locked down using webserver restrictions.

Debugging / Monitoring output templates should never be enabled on Production, see [[monitoring-debugging]]

Ensure access to `.git` folders (or similiar) are blocked via the websever configuration.

### Performance

Always use the Latest Stable Release and Java 21+ / Tomcat 11 or equivalent, older versions are slower.

Ideally, for fast and secure modern cfml applications, Scope Cascading should be disabled, as well as search result sets, see [[scopes]]

```cfml
// Application.cfc or via the Admin, Settings - Scope
component {
   this.scopeCascading = "strict"; // default is standard
   this.searchResults = false; // default is true
}
```

For the best performance in production, "Inspect Templates" should be set to `never`, see [[supercharge-your-website]]

```cfml
// .CFConfig.json or via the Admin, Settings - Performance/Caching
{
  "inspectTemplate": "never"
}
```

### Security

Limit variable evaluation in functions/tags should be disabled.

```cfml
// Application.cfc or via the Admin Settings - Security
component {
   this.security.limitEvaluation=true; // default is false, before Lucee 7
}
```

Setting the env var `LUCEE_CFID_URL_ALLOW=false` to prevent sessions being loaded via urls.