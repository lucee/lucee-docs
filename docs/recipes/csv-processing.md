<!--
{
  "title": "CSV Processing in Lucee 7",
  "id": "csv-processing-lucee7",
  "categories": ["java", "maven", "data-processing"],
  "since": "7.0",
  "description": "Simple recipe for processing CSV data in Lucee 7 using Maven integration and Apache Commons CSV",
  "keywords": [
    "CSV",
    "Apache Commons",
    "Maven",
    "Data Processing",
    "Parsing"
  ]
}
-->

# CSV Processing in Lucee 7

Lucee 7's Maven integration makes it incredibly easy to work with CSV files using the powerful Apache Commons CSV library, which provides robust parsing capabilities beyond basic string splitting.

## Maven Dependency

Find the latest Apache Commons CSV version at [mvnrepository.com](https://mvnrepository.com/artifact/org.apache.commons/commons-csv). Currently version 1.14.0 is available:

```gradle
implementation("org.apache.commons:commons-csv:1.14.0")
```

## Simple Example

Create a CSV processor with this simple inline component:

```cfml
parser = new component javasettings='{"maven":["org.apache.commons:commons-csv:1.14.0"]}' {
    import org.apache.commons.csv.*;
    
    function parse(csvString) {
        var format = CSVFormat::DEFAULT.withFirstRecordAsHeader();
        var parser = CSVParser::parse(arguments.csvString, format);
        
        var names = parser.getHeaderNames();
        var data = queryNew(names);

        loop collection=parser.iterator() item="local.record" {
            var col = 0;
            var row = queryAddRow(data);
            loop collection=record.iterator() item="local.item" {
                querySetCell(data, names[++col], item, row);
            }
        }
        return data;
    }
};

// Sample CSV data
csvData = "name,age,city,salary
John Doe,30,New York,75000
Jane Smith,25,Los Angeles,68000
Bob Johnson,35,Chicago,82000
Alice Brown,28,Houston,71000";

// Parse the CSV
result = parser.parse(csvData);
dump(result);
```

This returns a proper CFML query object that you can use with all standard query functions like `<cfoutput query="result">` or loop through with query methods.

## Advanced Implementation

For production use, you can create a separate component `CSVProcessor.cfc`:

```cfml
component javasettings='{"maven":["org.apache.commons:commons-csv:1.14.0"]}' {
    import org.apache.commons.csv.*;
    import java.io.FileReader;
    
    public function parseFromString(csvString, hasHeaders=true) {
        var format = hasHeaders ? 
            CSVFormat::DEFAULT.withFirstRecordAsHeader() : 
            CSVFormat::DEFAULT;
            
        var parser = CSVParser::parse(arguments.csvString, format);
        return convertToQuery(parser, hasHeaders);
    }
    
    public function parseFromFile(filePath, hasHeaders=true) {
        var format = hasHeaders ? 
            CSVFormat::DEFAULT.withFirstRecordAsHeader() : 
            CSVFormat::DEFAULT;
            
        var reader = new FileReader(expandPath(arguments.filePath));
        var parser = new CSVParser(reader, format);
        
        try {
            return convertToQuery(parser, hasHeaders);
        }
        finally {
            parser.close();
        }
    }
    
    private function convertToQuery(parser, hasHeaders) {
        if (hasHeaders) {
            var names = parser.getHeaderNames();
        } else {
            var firstRecord = parser.iterator().next();
            var names = [];
            for (var i = 1; i <= firstRecord.size(); i++) {
                names.append("column#i#");
            }
        }

        // Populate data
        var data = queryNew(names);
        loop collection=parser.iterator() item="local.record" {
            var col = 0;
            var row = queryAddRow(data);
            loop collection=record.iterator() item="local.item" {
                querySetCell(data, names[++col], item, row);
            }
        }
        return data;
    }
}
```

## Usage Examples

```cfml
processor = new CSVProcessor();

// Example 1: Parse CSV string with headers
csvData = "product,price,quantity,category
Laptop,999.99,5,Electronics
Mouse,29.99,50,Electronics
Notebook,4.99,100,Office";

products = processor.parseFromString(csvData);
dump(products); // Returns a query object

// Example 2: Parse CSV without headers
rawData = "John,30,Engineer
Jane,25,Designer
Bob,35,Manager";

employees = processor.parseFromString(rawData, false);
dump(employees); // Query with column1, column2, column3

// Example 3: Read from file
products = processor.parseFromFile("products.csv");

// Example 4: Traditional query loop
<cfoutput query="products">
    Product: #product# - Price: $#price# - Stock: #quantity#<br>
</cfoutput>
```

## Benefits Over Built-in CSV Functions

Apache Commons CSV provides several advantages:

- **Robust parsing** - Handles quoted fields, embedded commas, and line breaks
- **Header support** - Automatic header detection and named field access
- **Multiple formats** - Support for Excel, RFC4180, and custom formats
- **Error handling** - Better error reporting for malformed CSV
- **Performance** - Optimized for large files and datasets

Perfect for complex CSV processing that goes beyond simple comma-separated parsing!