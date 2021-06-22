---
title: XML fast And Easy
id: xml_fast-easy
---

This document explains how to use XML parsing in lucee.

I have XML as shown below:

```luceescript
//catlog.xml
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
	<cd>
		<title>Greatest Hits</title>
		<artist>Dolly Parton</artist>
		<country>USA</country>
		<company>RCA</company>
		<price>9.90</price>
		<year>1982</year>
	</cd>
	<cd>
		<title>Still got the blues</title>
		<artist>Gary Moore</artist>
		<country>UK</country>
		<company>Virgin records</company>
		<price>10.20</price>
		<year>1990</year>
	</cd>
	<cd>
		<title>Eros</title>
		<artist>Eros Ramazzotti</artist>
		<country>EU</country>
		<company>BMG</company>
		<price>9.90</price>
		<year>1997</year>
	</cd>
	<cd>
		<title>One night only</title>
		<artist>Bee Gees</artist>
		<country>UK</country>
		<company>Polydor</company>
		<price>10.90</price>
		<year>1998</year>
	</cd>
	<cd>
		<title>Sylvias Mother</title>
		<artist>Dr.Hook</artist>
		<country>UK</country>
		<company>CBS</company>
		<price>8.10</price>
		<year>1973</year>
	</cd>
	<cd>
		<title>Maggie May</title>
		<artist>Rod Stewart</artist>
		<country>UK</country>
		<company>Pickwick</company>
		<price>8.50</price>
		<year>1990</year>
	</cd>
	<cd>
		<title>Romanza</title>
		<artist>Andrea Bocelli</artist>
		<country>EU</country>
		<company>Polydor</company>
		<price>10.80</price>
		<year>1996</year>
	</cd>
	<cd>
		<title>When a man loves a woman</title>
		<artist>Percy Sledge</artist>
		<country>USA</country>
		<company>Atlantic</company>
		<price>8.70</price>
		<year>1987</year>
	</cd>
	<cd>
		<title>Black angel</title>
		<artist>Savage Rose</artist>
		<country>EU</country>
		<company>Mega</company>
		<price>10.90</price>
		<year>1995</year>
	</cd>
	<cd>
		<title>1999 Grammy Nominees</title>
		<artist>Many</artist>
		<country>USA</country>
		<company>Grammy</company>
		<price>10.20</price>
		<year>1999</year>
	</cd>
	<cd>
		<title>For the good times</title>
		<artist>Kenny Rogers</artist>
		<country>UK</country>
		<company>Mucik Master</company>
		<price>8.70</price>
		<year>1995</year>
	</cd>
	<cd>
		<title>Big Willie style</title>
		<artist>Will Smith</artist>
		<country>USA</country>
		<company>Columbia</company>
		<price>9.90</price>
		<year>1997</year>
	</cd>
	<cd>
		<title>Tupelo Honey</title>
		<artist>Van Morrison</artist>
		<country>UK</country>
		<company>Polydor</company>
		<price>8.20</price>
		<year>1971</year>
	</cd>
	<cd>
		<title>Soulsville</title>
		<artist>Jorn Hoel</artist>
		<country>Norway</country>
		<company>WEA</company>
		<price>7.90</price>
		<year>1996</year>
	</cd>
	<cd>
		<title>The very best of</title>
		<artist>Cat Stevens</artist>
		<country>UK</country>
		<company>Island</company>
		<price>8.90</price>
		<year>1990</year>
	</cd>
	<cd>
		<title>Stop</title>
		<artist>Sam Brown</artist>
		<country>UK</country>
		<company>A and M</company>
		<price>8.90</price>
		<year>1988</year>
	</cd>
	<cd>
		<title>Bridge of Spies</title>
		<artist>T`Pau</artist>
		<country>UK</country>
		<company>Siren</company>
		<price>7.90</price>
		<year>1987</year>
	</cd>
	<cd>
		<title>Private Dancer</title>
		<artist>Tina Turner</artist>
		<country>UK</country>
		<company>Capitol</company>
		<price>8.90</price>
		<year>1983</year>
	</cd>
	<cd>
		<title>Midt om natten</title>
		<artist>Kim Larsen</artist>
		<country>EU</country>
		<company>Medley</company>
		<price>7.80</price>
		<year>1983</year>
	</cd>
	<cd>
		<title>Pavarotti Gala Concert</title>
		<artist>Luciano Pavarotti</artist>
		<country>UK</country>
		<company>DECCA</company>
		<price>9.90</price>
		<year>1991</year>
	</cd>
	<cd>
		<title>The dock of the bay</title>
		<artist>Otis Redding</artist>
		<country>USA</country>
		<company>Atlantic</company>
		<price>7.90</price>
		<year>1987</year>
	</cd>
	<cd>
		<title>Picture book</title>
		<artist>Simply Red</artist>
		<country>EU</country>
		<company>Elektra</company>
		<price>7.20</price>
		<year>1985</year>
	</cd>
	<cd>
		<title>Red</title>
		<artist>The Communards</artist>
		<country>UK</country>
		<company>London</company>
		<price>7.80</price>
		<year>1987</year>
	</cd>
	<cd>
		<title>Unchain my heart</title>
		<artist>Joe Cocker</artist>
		<country>USA</country>
		<company>EMI</company>
		<price>8.20</price>
		<year>1987</year>
	</cd>
</catalog>
```

Normally we use DOM(Document Object Model):

```luceescript
<cfscript>
	file=GetDirectoryFromPath(GetCurrentTemplatePath())&'catalog.xml';

	dom=XMLParse(file);
	dump(dom);

	// ... extract data needed
</cfscript>
```

DOM parses the XML to extract the data.

Disadvantages of the DOM model:

Creates an object tree based on complete XML.

* Slow - loads the complete XML in a very complex structure
* Memory Intensive - loads the complete XML in a very complex structure
* Complicated to use

There is a jDOM that is more optimized for Java, and because of that, faster and easier to use. But sadly that project is not maintained any more!!

### SAX - Simple API for XML ###

In Java there is another way to handle the XML called SAX. SAX is an event driver parser. It does not produce the object, but instead you are part of the parsing process.

#### Advantages ####

* Fast
* Memory Efficient (only creates persistent objects in memory)

### Disadvantage ###

Complicated to use.

### SAX - Listener Functions ###

You can use SAX on Lucee to define component and listener functions to listen for certain events. The listener functions are as follows:

- startDocument(), is called when it starts to parse the document
- startElement(string name, string attributes)- is called every time it goes into a new tag. This function provides the name of the tag and all attributes.
- body(string content), - is called every time it goes into new tag. This functions provides the content of the body.
- endElement(string name, struct attributes) - is called when you have reached the end of the element.
- endDocument() - is called when you have reached the end of the document.
- error(struct cfcatch) - is called while executing the parser.

Example with SAX:

```luceescript
<cfscript>
	file=GetDirectoryFromPath(GetCurrentTemplatePath())&'catalog.xml';

	catalog=new XMLcatalog(file);
	dump(catalog.execute());

</cfscript>
```

XMLcatalog is component,

```luceescript
//XMLcatalog.cfc
	component {

	/**
	* Start parsing an XML file.
	* @param xmlFile XML file to parse
	*/
	function init(string xmlFile) {
	variables.xmlFile=arguments.xmlFile;
	}

	function execute() {
	variables.cds=[];
	variables.cd={};
	variables.insideCD=false;
	variables.currentName="";


	var xmlEventParser=createObject("java","lucee.runtime.helpers.XMLEventParser");
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
	return variables.cds;
	}

	/**
	* This function will be called on to start parsing an XML Element (Tag).
	*/
	public void function startElement(string uri, string localName, string qName, struct attributes) {
	if(qName == "cd") {
		variables.cd={};
		variables.insideCD=true;
	}
	else if(variables.insideCD) {
		variables.currentName=qName;
	}
	}

	/**
	* call with body of content
	*/
	public void function body(string content) {
	if(len(variables.currentName)) {
	//if(len(variables.currentName) && variables.currentName!="price") {
		variables.cd[variables.currentName]=content;
	}
	}

	/**
	* This function will be called at the end of parsing an XML Element (Tag).
	*/
	public void function endElement(string uri, string localName, string qName, struct attributes) {
	if(qName == "cd") {
		arrayAppend(variables.cds,variables.cd);
		variables.insideCD=false;
	}
	variables.currentName="";
	}

	/**
	* This function will be called at the start of parsing a document.
	*/
	public void function startDocument() {}

	/**
	* This function will be called at the end of parsing a document.
	*/
	public void function endDocument() {}

	/**
	* This function will be called when a error occurs.
	*/
	public void function error(struct cfcatch) {
		echo(cfcatch);
	}
```

In the XML catalog you can see the listener functions and the listener function passed to the Java object. This helps to parse the data.

```luceescript
var xmlEventParser=createObject("java","lucee.runtime.helpers.XMLEventParser");
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
```

If we pass an XML string to execute the function, it automatically parses the XML data and returns an array format of parsed data.

You can use the filter on SAX:

Component with filter

```luceescript
//XMLcatalog.cfc
component {

	/**
	* Start parsing an XML file.
	* @param xmlFile XML file to parse
	*/
	function init(string xmlFile) {
		variables.xmlFile=arguments.xmlFile;
	}

	function execute(struct filter) {
		variables.cds=[];
		variables.cd={};
		variables.insideCD=false;
		variables.currentName="";
		variables.removeCD=false;


		var xmlEventParser=createObject("java","lucee.runtime.helpers.XMLEventParser");
		variables.filter=filter;
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
		return variables.cds;
	}

	/**
	* This function will be called at the start of parsing an XML Element (Tag).
	*/
	public void function startElement(string uri, string localName, string qName, struct attributes) {
		if(qName == "cd") {
			variables.cd={};
			variables.insideCD=true;
			variables.removeCD=false;
		}
		else if(variables.insideCD) {
			variables.currentName=qName;
		}
	}

	/**
	* call with body of content
	*/
	public void function body(string content) {
		if(len(variables.currentName)) {
			variables.cd[variables.currentName]=content;
			if(structKeyExists(variables.filter,variables.currentName) && content != variables.filter[variables.currentName]) {
				variables.removeCD=true;
			}
		}
	}

	/**
	* This function will be called at the end of parsing an XML Element (Tag).
	*/
	public void function endElement(string uri, string localName, string qName, struct attributes) {
		if(qName == "cd") {
			if(!variables.removeCD) {
				arrayAppend(variables.cds,variables.cd);
			}
			variables.insideCD=false;
		}
		variables.currentName="";
	}

	/**
	* This function will be called at the start of parsing a document.
	*/
	public void function startDocument() {}

	/**
	* This function will be called at the end of parsing a document.
	*/
	public void function endDocument() {}

	/**
	* This function will be called when an error occurs.
	*/
	public void function error(struct cfcatch) {
		echo(cfcatch);
	}

}

```

You can pass the filter struct when you execute the function.

Example:

```luceescript
<cfscript>
	file=GetDirectoryFromPath(GetCurrentTemplatePath())&'catalog.xml';
	catalog=new XMLCatalog2(file);

	dump(catalog.execute({year:"1995"}));
</cfscript>
```

The example above executes and returns a result array which contains only the year equal to 1995.

You can modify the component as you like. Instead of storing the array, you can store the result in a database or mail, or whatever you like.

### Footnotes ###

You can see the details in this video:
[Xml-Fast and Easy](https://www.youtube.com/watch?v=_AP6GpVk7TE)
