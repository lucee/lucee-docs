<cftry>
  <cfquery name="getCountofReminders" datasource="#application.config.DSN#">
    select count(id) from reminders where id =
      <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_number">
  </cfquery>
  <cfcatch type = "database"> 
    <cfoutput>
      <p>There was a problem getting a count of your reminders: #cfcatch.queryerror# (for statement: #cfcatch.sql#)</p>
    </cfoutput>
  </cfcatch>
</cftry>
