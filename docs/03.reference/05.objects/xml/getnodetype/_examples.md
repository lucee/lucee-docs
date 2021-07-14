```luceescript+trycf
	xml_stream = '
	<?xml version="1.0" encoding="UTF-8"?>
	<notes>
	  <note>
	    <to>Alice</to>
	    <from>Bob</from>
	    <heading>Reminder</heading>
	    <body>Here is the message you requested.</body>
	  </note>
	  <note>
	    <to>Bob</to>
	    <from>Alice</from>
	    <heading>Your request</heading>
	    <body>I got your message; all is well.</body>
	  </note>
	</notes>';
	xml_document = XmlParse(xml_stream);
	writedump(xml_document.xmlRoot.XmlChildren[1].XmlChildren.last().GetNodeType());
```
