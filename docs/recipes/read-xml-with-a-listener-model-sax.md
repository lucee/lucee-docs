<!--
{
  "title": "Read XML with a listener Model (SAX)",
  "id": "read-xml-with-a-listener-model-sax",
  "menuTitle": "Read XML using SAX",
  "description": "Lucee not only allows you to convert an XML file to an object tree (DOM) but also supports an event-driven model (SAX).",
  "keywords": [
    "XML",
    "SAX",
    "XML Parsing",
    "Event Driven",
    "XML Event Parsing",
    "XML to Struct"
  ],
  "categories": [
    "xml"
  ],
  "related":[
    "function-xmlparse"
  ]
}
-->

# Read XML with a listener Model (SAX)

While `XMLParse` creates an object tree (DOM), the SAX event-driven model is more memory-efficient for large XML documents - it processes events as they occur without loading the entire document.

Example XML document:

```lucee
<?xml version="1.0" encoding="ISO-8859-1"?>
<catalog>
    <cd>
        <title>Empire Burlesque</title>
        <artist>Bob Dylan</artist>
        <country>USA</country>
        <company>Columbia</company>
        <price>10.90</price>
        <year>1985</year>
    </cd>
    <cd>
        <title>Hide your heart</title>
        <artist>Bonnie Tyler</artist>
        <country>UK</country>
        <company>CBS Records</company>
        <price>9.90</price>
        <year>1988</year>
    </cd>
</catalog>
```

Define a component with listener functions for parser events (startDocument, startElement, body, endElement, etc.):

```cfs
component {
    this.cds = [];
    this.cd = {};
    this.insideCD = false;
    this.currentName = "";
    this.filter = {};
    this.removeCD = false;

    /**
    * constructor of the component that takes the path to the XML file and a simple custom-made filter
    * @param xmlFile XML File to parse
    * @param filter filter to limit content on certain records
    */
    function init(string xmlFile, struct filter = {}) {
        var xmlEventParser = createObject("java", "lucee.runtime.helpers.XMLEventParser");
        this.filter = filter;
        // registering the event handlers
        xmlEventParser.init(
            getPageContext(),
            this.startDocument,
            this.startElement,
            this.body,
            this.endElement,
            this.endDocument,
            this.error
        );
        xmlEventParser.start(xmlFile);
        return this.cds;
    }

    /**
    * this function will be called on the start of parsing of an XML Element (Tag)
    */
    function startElement(string uri, string localName, string qName, struct attributes) {
        if (localName EQ "cd") {
            this.cd = {};
            this.insideCD = true;
            this.removeCD = false;
        } else if (this.insideCD) {
            this.currentName = localName;
        }
    }

    /**
    * call with body of the tag
    */
    function body(string content) {
        if (len(this.currentName)) {
            this.cd[this.currentName] = content;
            if (structKeyExists(this.filter, this.currentName) and content NEQ this.filter[this.currentName])
                this.removeCD = true;
        }
    }

    /**
    * this function will be called at the end of parsing an XML Element (Tag)
    */
    function endElement(string uri, string localName, string qName, struct attributes) {
        if (localName EQ "cd") {
            if (!this.removeCD)
                this.cds[arrayLen(this.cds) + 1] = this.cd;
            this.insideCD = false;
        }
        this.currentName = "";
    }

    /**
    * this function will be called when the document starts to be parsed
    */
    function startDocument(string uri, string localName, string qName, struct attributes) {}

    /**
    * this function will be called when the document finishes being parsed
    */
    function endDocument(string uri, string localName, string qName, struct attributes) {}

    /**
    * this function will be called when an error occurs
    */
    function error(struct cfcatch) {
        dump(cfcatch);
    }
}
```

Invoke the component to parse and get results:

```coldfusion
<!---
    Calls XML Catalog Event Parser and converts the data to an array of structs
    with a filter that limits the country to "USA"
--->
<cfset xmlFile = GetDirectoryFromPath(GetCurrentTemplatePath()) & 'catalog.xml'>
<cfset cds = new XMLCatalog(xmlFile, {country: 'USA'})>
<cfdump var="#cds#">
```

You can download the complete example [here](https://bitbucket.org/lucee/lucee/downloads/lucee-sax-example.zip).
