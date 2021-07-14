### Tags

```lucee+trycf
<cfset count = 0 />
<cfloop from="1" to="10" index="x">
	<!--- ignoring row 5 and continue the loop --->
	<cfif x is 5>
		<cfcontinue />
	</cfif>
	<cfset count++ />
</cfloop>
<cfdump var="#count#" label="Count variable is" abort />
```

### Script

```luceescript+trycf
count = 0;
count2 = 0;
for (x = 1; x <= 10; x++) {
	count2++;
	// ignoring row 5 and continue the loop
	if (x is 5) {
		continue;
	}
	count++;
}
dump(var=count, label="Count variable is");
dump(var=count2, label="Count2 variable is");
```
