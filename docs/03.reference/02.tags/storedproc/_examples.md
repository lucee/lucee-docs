### Sample content for storedproc
```luceescript
<cfstoredproc procedure="games" datasource="dsname">
  <cfprocparam cfsqltype="CF_SQL_VARCHAR" value="#form.game1#">
  <cfprocparam cfsqltype="CF_SQL_VARCHAR" value="#form.game2#">
</cfstoredproc>
```