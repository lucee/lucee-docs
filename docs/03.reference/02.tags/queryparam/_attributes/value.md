Specifies the actual value that Lucee passes to the database.
 	
- For standard parameters: The single value used in the query
- For list parameters: Can be an array, list string, or other collection type
- For null values: Set the `null` attribute to true and this attribute is ignored
 	
 	The value will be automatically escaped to prevent SQL injection.
