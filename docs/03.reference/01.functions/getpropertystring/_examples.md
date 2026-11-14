```lucee
// Define the path to your properties file
path = expandPath("/path/to/your/test.properties");

// Retrieve the value of the 'lucee' property using UTF-8 encoding
propertyValue = getPropertyString(path, "lucee", "UTF-8");

// Output the property value
writeDump(propertyValue);
```