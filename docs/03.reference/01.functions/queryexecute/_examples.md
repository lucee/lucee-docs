
# SELECT

```luceescript+trycf
    _test = queryNew(
        "_id, _need, _forWorld",
        "integer, varchar, varchar",
        [[01,'plant', 'agri'],[02, 'save','water']]
    );
    queryResult = queryExecute(
        sql = 'SELECT * FROM _test WHERE _need = :need',
        params = {
            need: {
                value: "plant",
                type: "varchar"
            }
        },
        options = {
            dbtype = 'query'
        }
    );
    dump(queryResult);
```

# INSERT

and returning the generated key in result

```luceescript
queryExecute(
        sql = 'insert into user (name) values (:name)',
        params = {
            name: {
                value: "lucee",
                type: "varchar"
            }
        },
        options = {
            dbtype = 'query',
            result: "insertResult"
        }
    );
    dump( insertResult.generatedKey );
```
