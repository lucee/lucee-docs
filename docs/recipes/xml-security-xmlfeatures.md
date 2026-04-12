<!--
{
  "title": "XML Security with xmlFeatures",
  "id": "xml-security-xmlfeatures",
  "menuTitle": "XML Security (xmlFeatures)",
  "description": "How to control XML parsing security in Lucee using xmlFeatures to protect against XXE attacks and other XML vulnerabilities.",
  "keywords": [
    "XML",
    "xmlFeatures",
    "XXE",
    "security",
    "xmlParse",
    "isXml",
    "external entities",
    "DOCTYPE"
  ],
  "categories": [
    "xml",
    "security"
  ],
  "related": [
    "function-xmlparse",
    "function-isxml",
    "function-xmlsearch"
  ]
}
-->

# XML Security with xmlFeatures

Since Lucee 5.4.2 and 6.0, XML parsing is **secure by default** to protect against [XML External Entity (XXE)](https://owasp.org/www-community/vulnerabilities/XML_External_Entity_(XXE)_Processing) attacks. DOCTYPE declarations and external entities are blocked out of the box.

You can control XML security settings at two levels:

- **Application-wide** via `this.xmlFeatures` in `Application.cfc`
- **Per-call** by passing a struct as the `validator` argument to `xmlParse()`, or as the `xmlFeatures` argument to `isXml()`

Per-call settings override the application-level settings for that single operation.

## Built-in Feature Keys

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| `secure` | boolean | `true` | Master switch. When `true`, applies the full [OWASP XXE prevention](https://cheatsheetseries.owasp.org/cheatsheets/XML_External_Entity_Prevention_Cheat_Sheet.html) settings: disallows DOCTYPE, disables external entities and parameter entities, disables external DTD loading, disables XInclude, and blocks access to external DTDs and schemas. |
| `disallowDoctypeDecl` | boolean | `true` | When `true`, any XML containing a `<!DOCTYPE>` declaration throws an error. |
| `externalGeneralEntities` | boolean | `false` | When `true`, allows the parser to resolve external entity references (e.g. `<!ENTITY xxe SYSTEM "file:///etc/passwd">`). |
| `allowExternalEntities` | boolean | `false` | Adobe ColdFusion compatibility alias for `externalGeneralEntities`. If both are set, their values must match or an error is thrown. |

The `secure` flag is applied first, then `disallowDoctypeDecl` and `externalGeneralEntities` override specific features on top. This means you can set `secure: true` but then selectively relax individual restrictions.

## Setting xmlFeatures in Application.cfc

The defaults are secure, so you only need to set `this.xmlFeatures` if you need to relax the restrictions:

```luceescript
// Application.cfc
component {
	this.name = "myApp";

	// these are the defaults, you don't need to set them explicitly
	this.xmlFeatures = {
		"secure": true,
		"disallowDoctypeDecl": true,
		"externalGeneralEntities": false
	};
}
```

To allow DOCTYPE declarations (e.g. for Hibernate mapping files or legacy XML with DTD references):

```luceescript
// Application.cfc
component {
	this.name = "myApp";

	this.xmlFeatures = {
		"secure": false,
		"disallowDoctypeDecl": false,
		"externalGeneralEntities": false
	};
}
```

You can also update the settings at runtime using `application action="update"`:

```luceescript
application action="update" xmlFeatures = {
	"secure": false,
	"disallowDoctypeDecl": false,
	"externalGeneralEntities": false
};
```

## Per-call Override with xmlParse()

You can override the application-level settings for a single `xmlParse()` call by passing a struct as the `validator` argument (the third argument):

```luceescript
// application has secure defaults, but this specific call allows DOCTYPE
xml = xmlParse( xmlString, false, {
	"secure": false,
	"disallowDoctypeDecl": false,
	"externalGeneralEntities": false
} );
```

This is useful when your application is secure by default but you need to parse a specific document that contains a DOCTYPE declaration.

## Per-call Override with isXml()

Similarly, `isXml()` accepts an `xmlFeatures` struct as its second argument:

```luceescript
// check if a string is valid XML, allowing DOCTYPE
result = isXml( xmlString, {
	"secure": false,
	"disallowDoctypeDecl": false,
	"externalGeneralEntities": false
} );
```

## Why the Defaults Block DOCTYPE

By default, XML with a DOCTYPE declaration is rejected:

```luceescript
xmlString = '<?xml version="1.0"?>
	<!DOCTYPE foo [
		<!ENTITY xxe SYSTEM "file:///etc/passwd">
	]>
	<foo>&xxe;</foo>';

try {
	doc = xmlParse( xmlString );
} catch ( e ) {
	// "DOCTYPE is disallowed when the feature
	//  http://apache.org/xml/features/disallow-doctype-decl set to true"
	echo( e.message );
}
```

This is intentional. XXE attacks use DOCTYPE declarations to define external entities that can read local files, make network requests, or cause denial of service. Blocking DOCTYPE at the parser level is the most effective defense.

## Pass-through Features

Any keys in the struct that aren't one of the built-in aliases (`secure`, `disallowDoctypeDecl`, `externalGeneralEntities`, `allowExternalEntities`) are passed directly through to the underlying Java `DocumentBuilderFactory.setFeature()`. This lets you set any [Xerces feature](https://xerces.apache.org/xerces2-j/features.html):

```luceescript
this.xmlFeatures = {
	"secure": false,
	"disallowDoctypeDecl": false,
	"externalGeneralEntities": true,
	"http://apache.org/xml/features/validation/id-idref-checking": true
};
```

You can also use the full Xerces URI form for the built-in features:

```luceescript
// equivalent to disallowDoctypeDecl: true
application action="update" xmlFeatures = {
	"http://apache.org/xml/features/disallow-doctype-decl": true
};
```

## System-level Lock-down

The system property or environment variable `lucee.xmlfeatures.override.disable` can be set to `true` to prevent any application-level or per-call overrides. When enabled, XML parsing is locked to the secure defaults and any attempt to override will throw an error.

This is useful for shared hosting environments where you want to enforce XML security across all applications.

```
-Dlucee.xmlfeatures.override.disable=true
```

Or as an environment variable:

```
LUCEE_XMLFEATURES_OVERRIDE_DISABLE=true
```

## What `secure: true` Does Under the Hood

When `secure` is `true`, Lucee configures the Java XML parser following the [OWASP XXE Prevention Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/XML_External_Entity_Prevention_Cheat_Sheet.html):

- `http://apache.org/xml/features/disallow-doctype-decl` = `true`
- `http://xml.org/sax/features/external-general-entities` = `false`
- `http://xml.org/sax/features/external-parameter-entities` = `false`
- `http://apache.org/xml/features/nonvalidating/load-external-dtd` = `false`
- XInclude aware = `false`
- Expand entity references = `false`
- Access to external DTD = blocked
- Access to external schema = blocked

The `disallowDoctypeDecl` and `externalGeneralEntities` settings are then applied on top, allowing you to selectively relax specific restrictions while keeping the rest of the secure configuration in place.
