To use this tag in cfscript:

```
<cfscript>
  // This WDDX packet contains a struct with 4 keys: 3 strings and 1 array of numbers
  strWDDX = "<wddxPacket version='1.0'><header/><data><struct><var name='VERSION'><string>1.0.0</string></var><var name='COUNTDOWNARRAY'><array length='5'><number>5.0</number><number>4.0</number><number>3.0</number><number>2.0</number><number>1.0</number></array></var><var name='NAME'><string>Test Struct</string></var><var name='DESCRIPTION'><string>To illustrate serializing to WDDX</string></var></struct></data></wddxPacket>";
  
  wddx action='wddx2cfml' input=strWDDX output='example';
  
  dump(example);
</cfscript>
```

```lucee+trycf
<cfset qry = queryNew("id,test","integer,varchar",[{id:1,test:"test"},{id:2,test:"name"}])>
<cfdump var="#qry#" label="Query">

<cfwddx action="cfml2wddx" input="#qry#" output="WDDX_qry">
<cfdump var="#WDDX_qry#" label="action=cfml2wddx">

<cfwddx action="wddx2cfml" input="#WDDX_qry#" output="CFML_qry">
<cfdump var="#CFML_qry#" label="action=wddx2cfml">

<cfwddx action="cfml2js" topLevelVariable="CFML_js" input="#qry#" output="CFML_js">
<cfdump var="#CFML_js#" label="action=cfml2js">

<cfwddx action="wddx2js" topLevelVariable="test" input="#WDDX_qry#" output="WDDX_js">
<cfdump var="#WDDX_js#" label="action=wddx2js">
```

