###Tag Example
```lucee+trycf
<cftry>
  <cfset a = 2/0>
  <cfdump var="#a#" />
  <cfcatch type="any">
    Caught an error.
  </cfcatch>
  <cffinally>
    This is from cffinally.
  </cffinally>
</cftry>
```

###Script Example
```luceescript+trycf
      try{
          a = 2/0
          writeDump("#a#");
        }
        catch(any e){
            writeOutput("Caught an error.");
        }
        finally{
			writeOutput("This is from finally.");   
        }
```