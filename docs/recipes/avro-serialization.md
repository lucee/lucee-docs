<!--
{
  "title": "Avro Serialization in Lucee 7",
  "id": "avro-serialization-lucee7",
  "categories": ["java", "maven", "data-processing"],
  "since": "7.0",
  "description": "Simple recipe for serializing and deserializing Apache Avro data in Lucee 7 using Maven integration",
  "keywords": [
    "Avro",
    "Apache Avro",
    "serializeAvro",
    "deserializeAvro",
    "Maven",
    "Java Integration"
  ],
  "related": [
    "maven",
    "yaml-processing-lucee7"
  ]
}
-->

# Avro Serialization in Lucee 7

Lucee 7's Maven integration makes it easy to work with [Apache Avro](https://avro.apache.org/docs/) data using the official Avro Java library, without needing an extension.

This is an alternative to Adobe ColdFusion's `serializeAvro()` and `deserializeAvro()` functions.

## Maven Dependency

First, find the latest Avro version at [mvnrepository.com](https://mvnrepository.com/artifact/org.apache.avro/avro). Currently version 1.12.2 is available:

```gradle
implementation("org.apache.avro:avro:1.12.2")
```

## Simple Example

Avro data is always written and read with a schema, defined as JSON. This inline component serializes a struct to Avro binary and reads it back:

```cfml
avro = new component javasettings='{"maven":["org.apache.avro:avro:1.12.2"]}' {
    import org.apache.avro.Schema$Parser;
    import org.apache.avro.generic.GenericData$Record;
    import org.apache.avro.generic.GenericDatumWriter;
    import org.apache.avro.generic.GenericDatumReader;
    import org.apache.avro.io.EncoderFactory;
    import org.apache.avro.io.DecoderFactory;
    import java.io.ByteArrayOutputStream;

    function parseSchema(required string schemaJson) {
        return new Schema$Parser().parse(arguments.schemaJson);
    }

    function serialize(required struct data, required schema) {
        var record = new GenericData$Record(arguments.schema);
        for (var field in arguments.schema.getFields()) {
            record.put(field.name(), arguments.data[field.name()]);
        }
        var out = new ByteArrayOutputStream();
        var encoder = EncoderFactory::get().binaryEncoder(out, nullValue());
        new GenericDatumWriter(arguments.schema).write(record, encoder);
        encoder.flush();
        return out.toByteArray();
    }

    function deserialize(required binary bytes, required schema) {
        var decoder = DecoderFactory::get().binaryDecoder(arguments.bytes, nullValue());
        var record = new GenericDatumReader(arguments.schema).read(nullValue(), decoder);
        var result = [:];
        for (var field in arguments.schema.getFields()) {
            // Avro returns strings as org.apache.avro.util.Utf8, so convert them
            var value = record.get(field.name());
            result[field.name()] = isInstanceOf(value, "java.lang.CharSequence") ? value.toString() : value;
        }
        return result;
    }
};

// Usage
schema = avro.parseSchema('{
    "type": "record",
    "name": "Customer",
    "fields": [
        {"name": "firstName", "type": "string"},
        {"name": "lastName", "type": "string"},
        {"name": "age", "type": "int"}
    ]
}');

bytes = avro.serialize({"firstName": "John", "lastName": "Doe", "age": 30}, schema);
customer = avro.deserialize(bytes, schema);
dump(customer); // {firstName: "John", lastName: "Doe", age: 30}
```

Note that nested Java classes such as `Schema.Parser` are imported with a `$`, e.g. `import org.apache.avro.Schema$Parser;`.

## Avro Data Files

For production use, create a separate component `AvroProcessor.cfc` that writes and reads Avro data files. Data files embed the schema, so they can be read without passing it in:

```cfml
component javasettings='{"maven":["org.apache.avro:avro:1.12.2"]}' {
    import org.apache.avro.Schema$Parser;
    import org.apache.avro.generic.GenericData$Record;
    import org.apache.avro.generic.GenericDatumWriter;
    import org.apache.avro.generic.GenericDatumReader;
    import org.apache.avro.file.DataFileWriter;
    import org.apache.avro.file.DataFileReader;
    import org.apache.avro.io.EncoderFactory;
    import org.apache.avro.io.DecoderFactory;
    import java.io.ByteArrayOutputStream;
    import java.io.File;

    function parseSchema(required string schemaJson) {
        return new Schema$Parser().parse(arguments.schemaJson);
    }

    // write an array of structs to an Avro data file (schema is embedded in the file)
    function writeFile(required array rows, required schema, required string filePath) {
        var writer = new DataFileWriter(new GenericDatumWriter(arguments.schema));
        try {
            writer.create(arguments.schema, new File(expandPath(arguments.filePath)));
            for (var row in arguments.rows) {
                writer.append(toRecord(row, arguments.schema));
            }
        }
        finally {
            writer.close();
        }
    }

    // read all records from an Avro data file, using the schema stored in the file
    function readFile(required string filePath) {
        var reader = new DataFileReader(new File(expandPath(arguments.filePath)), new GenericDatumReader());
        var rows = [];
        try {
            var schema = reader.getSchema();
            while (reader.hasNext()) {
                arrayAppend(rows, toStruct(reader.next(), schema));
            }
        }
        finally {
            reader.close();
        }
        return rows;
    }

    private function toRecord(required struct data, required schema) {
        var record = new GenericData$Record(arguments.schema);
        for (var field in arguments.schema.getFields()) {
            if (structKeyExists(arguments.data, field.name())) {
                record.put(field.name(), arguments.data[field.name()]);
            }
        }
        return record;
    }

    private function toStruct(required record, required schema) {
        var result = [:];
        for (var field in arguments.schema.getFields()) {
            var value = arguments.record.get(field.name());
            // Avro returns strings as org.apache.avro.util.Utf8
            result[field.name()] = isNull(value) ? nullValue() : (isInstanceOf(value, "java.lang.CharSequence") ? value.toString() : value);
        }
        return result;
    }
}
```

Usage:

```cfml
avroProcessor = new AvroProcessor();

// customer.avsc contains the schema JSON from the simple example
schema = avroProcessor.parseSchema(fileRead("customer.avsc"));

// Write an Avro data file
customers = [
    {"firstName": "John", "lastName": "Doe", "age": 30},
    {"firstName": "Jane", "lastName": "Doe", "age": 25}
];
avroProcessor.writeFile(customers, schema, "customers.avro");

// Read it back
data = avroProcessor.readFile("customers.avro");
dump(data);
```

That's all you need to start working with Avro in Lucee 7! Maven handles downloading the library and all dependencies automatically.
