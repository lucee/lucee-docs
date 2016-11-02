<cfhttp url="http://www.google.com" method="get" result="myresult">
<cfdump var="#myresult#">

<cfscript>
	http url="http://www.google.com" method="get" result="myresult";
	dump(myresult);
</cfscript>
