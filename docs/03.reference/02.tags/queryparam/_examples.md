```luceescript
<cfscript>
	_test = queryNew("_id,_need,_forWorld","integer,varchar,varchar", [[01,'plant', 'agri'],[02, 'save','water']]);
</cfscript>

<cfquery name="qTest" dbtype="query">
	select * from _test
	where _id = <cfqueryparam sqltype="integer" value="2" /> 
</cfquery>

<cfdump var="#qtest#" />
```
