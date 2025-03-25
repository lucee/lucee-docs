Specifies the character that separates values in string lists.
 	
- Only used when `list="true"` and the value is a string (not an array)
- Default separator is a comma (`,`)
- Common alternatives include semicolon (`;`), pipe (`|`), or tab
- Example: For a string like "red;green;blue" with `list="true" separator=";"`, the values would be treated as three separate items
 	
Note: For best results with complex separators or values that might contain the separator character, consider using an array instead of a delimited string.