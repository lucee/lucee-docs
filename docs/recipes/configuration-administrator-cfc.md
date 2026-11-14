<!--
{
  "title": "Configure Lucee within your Application",
  "id": "cookbook-configuration-administrator-cfc",
  "description": "How to configure Lucee within your application using Administrator.cfc and cfadmin tag.",
  "keywords": [
    "Administrator.cfc",
    "cfadmin",
    "Configuration",
    "Lucee",
    "Web context",
    "Server configuration"
  ],
  "categories": [
    "server"
  ]
}
-->

# Configure Lucee Programmatically

Configure Lucee from code using `Administrator.cfc` (for per-request settings, see [[tag-application]]).

## Administrator.cfc

```cfs
admin = new Administrator("web", "myPassword"); // first argument is the admin type you want to load (web|server), second is the password for the Administrator
dump(admin); // show me the doc for the component
admin.updateCharset(resourceCharset: "UTF-8"); // set the resource charset
```

## cfadmin Tag

For functionality not in `Administrator.cfc`, check the undocumented `cfadmin` tag usage in the [Lucee Administrator source](https://github.com/lucee/Lucee/blob/7.0/core/src/main/java/resource/component/org/lucee/cfml/Administrator.cfc). Contributions welcome!
