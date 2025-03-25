Controls how the parameter value is handled:
 	
- `true`: The parameter value is treated as a list of values (typically used with SQL's `IN` operator)
- `false`: The parameter is handled as a simple value
- Not set: Lucee automatically detects if the value is an array and treats it as a list if it is (but not for byte arrays)
 	
When working with lists/arrays:

- **Empty Arrays**: When an empty array is provided with `list=true` (or auto-detected as a list), Lucee will handle this correctly by effectively omitting the parameter from the query
- **Usage with IN**: Typically used with SQL's `IN` operator
- **Array Elements**: Each element in the array will be properly typed according to the specified `sqlType`