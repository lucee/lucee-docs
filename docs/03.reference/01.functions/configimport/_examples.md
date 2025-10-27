```luceescript

// Import Lucee Server configuration to CFConfig JSON format
data = {
    "extensions": [
        {
            "id": "EFDEB172-F52E-4D84-9CD1-A1F561B3DFC8",
            "name": "Lucene Search",
            "version": "2.4.2.4"
        }
    ]
};
writeDump(ConfigImport(data, "server", "lucee_password"));

```

```luceescript

// Import Lucee Server configuration from a .CFConfig JSON file
writeDump(ConfigImport("path/to/.CFConfig.json", "server", "lucee_password"));

```