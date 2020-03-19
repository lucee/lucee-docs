A comma-delimited list of one or more interfaces that this interface extends.
			
Any CFC that implements an interface must also implement all the functions in the interfaces specified by this property.

If an interface extends another interface, and the child interface specifies a function with the same name as one in the parent interface, both functions must have the same attributes; otherwise it generates an error.