### Index & Conditional loop

```lucee+trycf
<cfloop index = "LoopCount" from = "1" to = "5">
	The loop index is <cfoutput>#LoopCount#</cfoutput><br>
</cfloop>
<br><u>Conditional loop</u><br>
<cfset CountVar = 1>
<cfloop condition = "CountVar LESS THAN OR EQUAL TO 5">
	<cfset CountVar = CountVar + 1>
	CountVar is <cfoutput>#CountVar#</cfoutput><br>
</cfloop>
```

### List loop

```lucee+trycf
<cfset listEle = "lucee,test,case">
<br><u>Simple list loop</u><br>
<cfloop list="#listEle#" index="res">
	<cfoutput>#res#</cfoutput><br>
</cfloop>
<br><u>List loop</u><br>
<cfset listDeliEle = "I;Love;Lucee">

<cfloop list="#listDeliEle#" index="element" delimiters=";">
	<cfoutput>#element#</cfoutput><br>
</cfloop>
<br><u>deli loop with index</u><br>

<cfloop index="a" from="1" to="#listlen(listEle)#">
	<cfoutput>#listgetat(listEle,a)#</cfoutput><br>
</cfloop>
<br><u>Condition with list</u><br>
<cfset cV = 1>
<cfloop condition="cv lte #listlen(listele)#">
	<cfoutput>#listgetat(listEle,cV)#</cfoutput><br>
	<cfset cV = cV+1>
</cfloop>
```

### Array loop & Struct loop

```lucee+trycf
<cfoutput>
	<cfset arr = ["I","Love","Lucee"]>
	<br><u>Array using index loop</u><br>
	<cfloop array="#arr#" index="arr">
		#arr#<br>
	</cfloop>

	<cfset Departments = {"Save ":"Water ", "Plant ":"gren ", "Protect ":"Earth "}>
    <br><u>Struct  loop</u><br>
	<cfloop collection="#Departments#" item = "person">
			#person#
			#StructFind(Departments, person)#<br>
	</cfloop>
</cfoutput>
```