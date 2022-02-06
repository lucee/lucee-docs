An array or structure containing parameter values.

When passing an array, use `?` as place holders and pass them in the order they are referenced in the SQL.

When passing a struct, use `:keyName`, where `keyName` is the name of the key in the structure corresponding to the parameter.

The array or structure can be a structure with keys that match the names of the [[tag-queryparam]] names: 

- maxlength
- list
- scale
- separator
- null
- cfsqltype|sqltype|type
-  value