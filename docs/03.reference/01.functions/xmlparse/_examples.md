```luceescript+trycf
  xml_stream = "
    <note>
      <to>Alice</to>
      <from>Bob</from>
      <heading>Reminder</heading>
      <body>Here is the message you requested.</body>
    </note>
  ";

  dump(XmlParse(xml_stream));
```
