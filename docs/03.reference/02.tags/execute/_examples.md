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

### Example for cfexecute with onprogress & onerror (Introduced: 7.0.0.188)

```lucee
<cfscript>
    function handleProgress(line, process) {
        writeOutput(">> " & line & "<br>");
        return true; // Continue processing
    }
    function onErrorListener ( errorOutput ){
        writeOutput("ERROR " & err);
        return false; //cancel the process
    };
        // Execute the "dir" command
    cfexecute(
        name="cmd",//windows command line
        arguments="/c dir", // "/c" ensures the command runs and exits
        result="local.result", // Captures the output of the command 
        directory="C:\Users", // Specify the directory to list
        onError=onErrorListener, // Callback function for error handling
        onprogress =handleProgress, // Callback function for progress
        timeout=10 // Set a timeout to prevent hanging
    ); 
</cfscript>
```
