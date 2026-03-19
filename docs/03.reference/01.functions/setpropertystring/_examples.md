```lucee
// Define the path to your properties file
path = expandPath("/path/to/your/test.properties");

// Set the value of the 'lucee' property to '8888' using UTF-8 encoding
setPropertyString(path, "lucee", "8888", "UTF-8");

// Read back the property to verify it was set
propertyValue = getPropertyString(path, "lucee", "UTF-8");
writeOutput("lucee property value: " & propertyValue);
```