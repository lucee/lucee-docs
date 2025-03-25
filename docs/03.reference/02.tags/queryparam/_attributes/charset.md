Specifies the character encoding for string validation.
 	
This attribute serves two purposes:
1. It validates that the given value is compatible with the specified charset
2. It determines how byte length is calculated for `maxLength` validation
 	
Common values include `UTF-8`, `ISO-8859-1`, or other valid Java charset names.This attribute is used for 2 things:
- it checks if the given value is compatible with that charset
- to check the binary length of the value (see attribute maxlength).