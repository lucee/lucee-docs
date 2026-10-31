```luceescript+trycf
// example of an url variable:
// http://some.example.domain/dogs.cfm?name=lassie
url.name="lassie";
SQLQuery="SELECT * FROM dogs WHERE name='#url.name#';";
dump( SQLQuery );

// example of an url sql injection:
// http://some.example.domain/dogs.cfm?name='%20or%20'1'='1
url.name= "' or '1'='1";
SQLQuery="SELECT * FROM dogs WHERE name='#url.name#';";
dump( SQLQuery );

// example of preventing sql injection with encodeForSQL in MySQL:
SQLQuery="SELECT * FROM dogs WHERE name='#encodeForSQL( url.name, 'mySql' )#';";
dump( SQLQuery );
```

# Recommended: use query parameters instead

```luceescript+trycf
dogs = queryNew(
	"name, owner",
	"varchar, varchar",
	[ [ "lassie", "timmy" ], [ "rex", "anna" ] ]
);

// an url sql injection attempt
url.name = "' or '1'='1";

// the value is sent as a bound parameter and is never part of the SQL string
result = queryExecute(
	sql = "SELECT * FROM dogs WHERE name = :name",
	params = {
		name: { value: url.name, type: "varchar" }
	},
	options = { dbtype: "query" }
);
dump( result.recordCount ); // 0, the injection attempt matches nothing
```
