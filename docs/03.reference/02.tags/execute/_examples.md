### Simple example for cfexecute

```lucee
<cfexecute name="C:\Windows\System32\netstat.exe"
            arguments="-e"
            outputFile="C:\Temp\output.txt"
            timeout="1"> 
</cfexecute>
```