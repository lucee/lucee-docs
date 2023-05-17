```luceescript
	xml_document = XmlNew(); // new XML document to populate
	xml_root = xml_document.elemNew("notes");
	xml_document.XmlRoot = xml_root; // set the root node of the XML document

	xml_child = xml_document.elemNew("note"); // first child node
	
	xml_secondary_child = xml_document.elemNew("to", "second_child"); // child node for the first child node
	xml_child.XmlChildren.append(xml_secondary_child);
	
	xml_root.XmlChildren.append(xml_child); // add the first child node to the XML document

	writeDump(xml_document);
```