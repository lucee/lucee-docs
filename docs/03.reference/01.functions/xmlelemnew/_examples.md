```luceescript+trycf
  xml_document = XmlNew(); // new XML document to populate
  xml_root = XmlElemNew(xml_document,"notes");
  xml_document.XmlRoot = xml_root; // set the root node of the XML document

  xml_child = XmlElemNew(xml_document,"note"); // first child node

  xml_secondary_child = XmlElemNew(xml_document,"to"); // child node for the first child node
  xml_child.XmlChildren.append(xml_secondary_child);

  xml_root.XmlChildren.append(xml_child); // add the first child node to the XML document

  dump(xml_document);
```
