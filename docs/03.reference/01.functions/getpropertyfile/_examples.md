```lucee
// Define the path to your properties file
path = expandPath("/path/to/your/test.properties");

// Read all properties from the file using UTF-8 encoding
properties = getPropertyFile(path, "UTF-8");

// Output all properties as a struct
writeDump(properties);
```