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
