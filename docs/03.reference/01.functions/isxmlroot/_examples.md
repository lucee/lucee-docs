```lucee+trycf
 <cfxml variable="xmlobject">
	<office>
		<employee>
			<emp_name>lucee_dev</emp_name>
			<emp_no>121</emp_no>
		</employee>
	</office>
</cfxml>
<cfdump var="#IsXmlroot(xmlobject.office)#" />
```