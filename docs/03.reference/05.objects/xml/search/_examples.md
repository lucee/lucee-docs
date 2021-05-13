```lucee+trycf
<cfxml variable="xmlobject">
	<office>
		<employee>
			<emp_role>lucee_dev
				<emp_name>mark</emp_name>
				<emp_id>102</emp_id>
				<emp_jobrole>software</emp_jobrole>
			</emp_role>
		</employee>
	</office>
</cfxml>
<cfset res = xmlobject.search("/office/employee/")>
<cfdump var="#res#" />
```
