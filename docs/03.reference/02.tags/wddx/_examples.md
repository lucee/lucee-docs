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
