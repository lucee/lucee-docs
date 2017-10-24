```luceescript+trycf
xml_stream = "
  <notes>
    <note>
      <to>Alice</to>
      <from>Bob</from>
      <heading>Reminder</heading>
      <body>Here is the message you requested.</body>
    </note>
    <author>
      <first>John</first>
      <last>Doe</last>
    </author>
  </notes>
";

xml_document = XmlParse(xml_stream);
xml_root = xml_document.XmlRoot;

dump(XmlChildPos(xml_root,"author",1)); // 2
```
