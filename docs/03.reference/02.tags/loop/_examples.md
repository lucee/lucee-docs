### Index & Conditional loop
```lucee+trycf
<cfloop index = "LoopCount" from = "1" to = "5">
	The loop index is <cfoutput>#LoopCount#</cfoutput><br>
</cfloop>
<br>Conditional loop<br>
<cfloop condition = "CountVar LESS THAN OR EQUAL TO 5" >
	<cfset CountVar = CountVar + 1>
	CountVar is <cfoutput>#CountVar#</cfoutput><br>
</cfloop>
```
### List loop
```lucee+trycf
<cfset listEle = "lucee,test,case">
<br>Simple list loop<br>
<cfloop list="#listEle#" index="res" >
	<cfoutput>#res#</cfoutput><br />
</cfloop>
<br>List loop<br>
<cfset listDeliEle = "I;Love;Lucee">

<cfloop list="#listDeliEle#" index="element" delimiters=";" >
	<cfoutput>#element#</cfoutput><br />
</cfloop>
<br>deli loop with index<br>

<cfloop index="a" from="1" to="#listlen(listEle)#">
	<cfoutput>#listgetat(listEle,a)#</cfoutput><br>
</cfloop>
<br>Condition with list<br>
<cfset cV = 1>
<cfloop condition="cv lte #listlen(listele)#">
	<cfoutput>#listgetat(listEle,cV)#</cfoutput><br>
	<cfset cV = cV+1>
</cfloop>
```
### Array loop & Struct loop
```lucee+trycf
<cfset arr = ["I","Love","Lucee"]>
Array using index loop & Break<br>
<cfloop array="#arr#" index="arr">
	#arr#<br />
</cfloop>

<cfset Departments = {"Save ":"Water ", "Plant ":"gren ", "Protect ":"Earth "}>
<cfoutput>
<cfloop collection="#Departments#" item = "person">
		#person#
		#StructFind(Departments, person)#<br>
</cfloop>
</cfoutput>
```