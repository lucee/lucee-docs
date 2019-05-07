### Tags
```lucee+trycf
<cfhttp url="http://www.google.com" method="get" result="myresult">
<cfdump var="#myresult#">


<cfhttp url="http://www.google.com" method="get" result="myresult">
    <cfhttpparam type="url" name="q" value="Lucee">
</cfhttp>
<cfdump var="#myresult#">
```
### Script
```luceescript+trycf
http url="http://www.google.com" method="get" result="myresult";
dump(myresult);

//You can also pass parameters in script format
http url="http://www.google.com/search" method="get" result="myresult"{
    httpparam type="url" name="q" value="Lucee";
}
dump(myresult);
```
