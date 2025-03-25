Maximum allowed length of the parameter value (validation check).
 	
- For string values: The maximum number of characters allowed
- For binary values: The maximum number of bytes allowed
- If the value exceeds this length, Lucee will throw an exception
- If not specified, defaults to the actual length of the provided value
- If the attribute `charset` is defined, string length comparison will be byte-based for that encoding