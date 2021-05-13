```lucee+trycf
<cfoutput>
 	<cffunction access="private" name="add">
		<cfargument name="arg1" type="Numeric" required />
		<cfargument name="arg2" type="Numeric" required />
	 	<cfreturn arg1 + arg2 />
	</cffunction>
	<cfdump var="Define function Using tag.It returns :#add(4,2)#" />
</cfoutput>
```

```luceescript+trycf
		writeDump("Define function using cfscript. It returns: "&add(2,3));
		public function add(required numeric arg1,required numeric arg2){
			return arg1+arg2;
		}
```
