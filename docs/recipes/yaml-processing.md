<!--
{
  "title": "YAML Processing in Lucee 7",
  "id": "yaml-processing-lucee7",
  "categories": ["java", "maven", "data-processing"],
  "since": "7.0",
  "description": "Simple recipe for processing YAML files in Lucee 7 using Maven integration and SnakeYAML",
  "keywords": [
    "YAML",
    "SnakeYAML",
    "Maven",
    "Java Integration"
  ]
}
-->

# YAML Processing in Lucee 7

Lucee 7's Maven integration makes it incredibly easy to work with YAML files using the popular SnakeYAML Java library.

## Maven Dependency

First, find the latest SnakeYAML version at [mvnrepository.com](https://mvnrepository.com/artifact/org.yaml/snakeyaml). Currently version 2.4 is available:

```gradle
implementation("org.yaml:snakeyaml:2.4")
```

## Simple Example

Create a YAML file `customer.yaml`:

```yaml
firstName: "John"
lastName: "Doe"
age: 30
```

Read it with this simple inline component:

```cfml
yaml = new component javasettings='{"maven":["org.yaml:snakeyaml:2.4"]}' {
    import org.yaml.snakeyaml.*;
    
    function read(filePath) {
        var yaml = new Yaml();
        return yaml.load(fileRead(arguments.filePath));
    }
};

// Usage
customer = yaml.read("customer.yaml");
dump(customer); // Shows the parsed data as a map
```

That's it! The YAML is automatically converted to CFML data structures.

## Advanced Implementation

For production use, create a separate component `YamlProcessor.cfc`:

```cfml
component javasettings='{"maven":["org.yaml:snakeyaml:2.4"]}' {
    import org.yaml.snakeyaml.*;
    import java.io.FileInputStream;
    
    function read(filePath) {
        var yaml = new Yaml();
        var inputStream = null;
        
        try {
            var path = expandPath(arguments.filePath);
            inputStream = new FileInputStream(path);
            return yaml.load(inputStream);
        }
        finally {
            if (!isNull(inputStream)) inputStream.close();
        }
    }
    
    function write(data, filePath) {
        var yaml = new Yaml();
        fileWrite(expandPath(arguments.filePath), yaml.dump(arguments.data));
    }
}
```

Usage:

```cfml
yamlProcessor = new YamlProcessor();

// Read YAML
data = yamlProcessor.read("config.yaml");

// Write YAML
newData = {"name": "Jane", "age": 25};
yamlProcessor.write(newData, "output.yaml");
```

That's all you need to start processing YAML files in Lucee 7! Maven handles downloading the library and all dependencies automatically.