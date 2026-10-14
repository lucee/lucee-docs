**Basic Usage**

```luceescript+trycf
xml_stream = "
	<note>
		<to>Alice</to>
		<from>Bob</from>
		<heading>Reminder</heading>
		<body>Here is the message you requested.</body>
	</note>
";

dump( XmlParse( xml_stream ) );
```

**Parsing XML with DOCTYPE (xmlFeatures override)**

By default, XML containing a DOCTYPE declaration is blocked. To parse such XML, pass an `xmlFeatures` struct as the `validator` argument:

```luceescript+trycf
xmlWithDoctype = '<?xml version="1.0"?>
	<!DOCTYPE hibernate-mapping PUBLIC
		"-//Hibernate/Hibernate Mapping DTD 3.0//EN"
		"http://www.hibernate.org/dtd/hibernate-mapping-3.0.dtd">
	<hibernate-mapping></hibernate-mapping>';

// this will throw an error with secure defaults
try {
	doc = xmlParse( xmlWithDoctype );
	echo( "parsed ok" );
} catch ( e ) {
	echo( "Blocked: " & e.message );
}

echo( "<br><br>" );

// override xmlFeatures to allow DOCTYPE for this call only
doc = xmlParse( xmlWithDoctype, false, {
	"secure": false,
	"disallowDoctypeDecl": false,
	"externalGeneralEntities": false
} );
echo( "Parsed with override: " & doc.xmlRoot.xmlName );
```

See the [XML Security with xmlFeatures](/docs/recipes/xml-security-xmlfeatures) recipe for more details.
