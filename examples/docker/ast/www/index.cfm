<cfscript>
// build in functtions
dump(astFromPath(getCurrentTemplatePath()));
dump(astFromString("<cfset susi='Sorglos'>"));

// Java Util
astUtil=new lucee.runtime.util.AstUtil();
res=astUtil.astFromString("<cfset susi='Sorglos'>");
dump(res);

res=astUtil.astFromPath(getCurrentTemplatePath());
dump(res);
</cfscript>