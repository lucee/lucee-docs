```lucee+trycf
<cfregistry action = "getAll"
	branch = "HKEY_LOCAL_MACHINE\Software\Microsoft"
	type = "Any"
	name = "q_registry">
<cfdump var="#q_registry#">
```