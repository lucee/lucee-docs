Array or as a structure of parameter values.

When passing an array use ? as place holders and pass them in the order they are to be used.

When passing a struct use :keyName where keyName is the name of the key in the structure corresponding to the parameter.

The array or structure can be a structure with keys that match the names of the [cfqueryparam](https://docs.lucee.org/reference/tags/queryparam.html) names: maxlength, list, scale, separator, null, cfsqltype|sqltype|type and value
