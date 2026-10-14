
# SELECT

```luceescript+trycf
_test = queryNew(
    "_id, _need, _forWorld",
    "integer, varchar, varchar",
    [[01,'plant', 'agri'],[02, 'save','water']]
);
queryResult = QueryExecute(
    sql = "SELECT * FROM _test WHERE _need = :need",
    params = {
        need: {
            value: "plant",
            type: "varchar"
        }
    },
    options = {
        dbtype = "query"
    }
);
dump(queryResult);
```

# INSERT

```luceescript
QueryExecute(
    sql = "insert into user (name) values (:name)",
    params = {
        name: {
            value: "lucee",
            type: "varchar"
        }
    },
    options = {
        dbtype = "query",
        // return the autoincrement generated key from database
        result: "insertResult"
    }
);
dump(insertResult.generatedKey);
```

Concise alternative with unnamed function arguments and removed optional dbtype:

```luceescript
QueryExecute(
    "insert into user (name) values (:name)",
    {"name": {"value": "lucee", "type": "varchar"}},
    {"result": "insertResult"}
);
dump(insertResult.generatedKey);
```
