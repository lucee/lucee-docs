### Simple example for cfexecute

```lucee
<cfexecute name="C:\Windows\System32\netstat.exe"
            arguments="-e"
            outputFile="C:\Temp\output.txt"
            timeout="1">
</cfexecute>
```

### Executing a shell command on Linux

```lucee
<cfscript>
	env = { "LUCEE": "rocks" }; // lucee 7+
	exe ="bash";
	// args as a string
	args = "-c 'set'";  // or ls etc
	cfexecute(name=exe, timeout="1", arguments=args , environment=env, variable="result");	
</cfscript>
```

### Executing a shell command on Windows

```lucee
<cfscript>
	env = { "LUCEE": "rocks" }; // lucee 7+
	exe = "cmd";
	// args as an array
	args = ["/c", "set"]; // or dir etc
	cfexecute(name=exe, timeout="1", arguments=args , environment=env, variable="result");
</cfscript>
```
