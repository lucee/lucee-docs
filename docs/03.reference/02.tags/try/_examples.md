### Tag example

```lucee+trycf

<cftry>
  <cfquery name="getCountofReminders" datasource="dsn">
    select count(id) from reminders where id = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_number">
  </cfquery>
  <cfcatch type="database">
    <cfoutput>
      <p>There was a problem getting a count of your reminders)</p>
    </cfoutput>
    <cfdump var=#cfcatch#>
  </cfcatch>
</cftry>

```

### Script example

```luceescript+trycf
 try {
	a = 2/0
        writeDump("#a#");
      }
catch(any e){
	writeOutput("Caught an error.");
      }
```

### Adding additional info to an Exception

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