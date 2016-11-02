```lucee+trycf
<cfhttp url="http://www.google.com" method="get" result="myresult">
<cfdump var="#myresult#">
```

```luceescript+trycf
http url="http://www.google.com" method="get" result="myresult";
dump(myresult);
```
