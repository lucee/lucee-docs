```luceescript+trycf

        enc = ESAPIEncode("html","<table>");//html
	writeDump(enc);
	enc = ESAPIEncode("url",'https://download.lucee.org/?type=releases');//URL
	writeDump(enc);
	enc = ESAPIEncode("xml","foo()");
	writeDump(enc);
	enc = ESAPIEncode("xml_attr","foo'()");
	writeDump(enc);
	enc = ESAPIEncode("ldap","foo'()");
	writeDump(enc);
	enc = ESAPIEncode("javascript","foo()");
	writeDump(enc);
	enc = ESAPIEncode("DN","foo(),foo");
	writeDump(enc);
```



```lucee+trycf
<cfoutput>
<div style="color:#ESAPIEncode("css",'red')#">Example for encodeforcss</div>
</cfoutput>
<cfoutput><div title="#ESAPIEncode("html_attr","<test>")#"></div></cfoutput>

```