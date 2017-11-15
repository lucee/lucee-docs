<pre>
&lt;cftry&gt;
  &lt;cfquery name="getCountofReminders" datasource="#application.config.DSN#"&gt;
    select count(id) from reminders where id =
      &lt;cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_number"&gt;
  &lt;/cfquery&gt;
  &lt;cfcatch type = "database"&gt;
    &lt;cfoutput&gt;
      &lt;p&gt;There was a problem getting a count of your reminders: #cfcatch.queryerror# (for statement: #cfcatch.sql#)&lt;/p&gt;
    &lt;/cfoutput&gt;
  &lt;/cfcatch&gt;
&lt;/cftry&gt;
</pre>
