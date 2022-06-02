Optional filter. 

- Can be either a wildcard filter, e.g. "m*"
- or a UDF/Closure which is passed each `file/directory` path and returns a **boolean value** to indicate whether that item should be included in the result or not.

`function ( entryPath ){ return true | false }`
