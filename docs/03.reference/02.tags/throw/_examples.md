### Tag example

```lucee+trycf
<cftry>
    <cfthrow message="test exception">
    <cfcatch name="test" type="any">
        <cfdump var="#cfcatch#">
    </cfcatch>
</cftry>
```

### Script example

```luceescript+trycf
 try {
        throw message="test exception"; //CF9+
    } catch (any e) {
        echo("#cfcatch#");
    }
```

### Adding additional info to an Exception using cause

```luceescript+trycf
    try {
        try {
            throw message="test exception";
        } catch (any e) {
            // throw original exception with additional info, using "cause" Lucee 6+
            // see the "Caused by" at the bottom of the java stacktrace
            throw(message="error running batch", cause=e); 
        }
    } catch (ee){
        // this extra catch is to prevent trycf swallowing the exception detail
        echo(ee); 
    }
```