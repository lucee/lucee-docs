```lucee+trycf
<cfset arr =["I Love Lucee"] >
<cfset str.myVal ="Save water, Plant green" >
<cfset  intVar=10 >
<cfset char ="Smile & Enjoy your life" >
<cfdump var="#arr#" label="Array" />
<cfdump var="#str#" label="Structure" />
<cfdump var="#intVar#" label="Integer" />
<cfdump var="#char#"  label="String"/>

<cfscript>
	writeOutput("<br><br>Using CFscript<br><br>");
	array=["this is sample array"];
	struct.userVal=1;
	numb=1006;
	str="I'm String";
	writeDump(var=array,label="Array");;
	writeDump(var=struct,label="Structure");;
	writeDump(var=numb,label="Integer");
	writeDump(var=str,label="String");
</cfscript>
```