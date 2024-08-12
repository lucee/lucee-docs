<cfscript>
	echo("<pre>#fileRead("/opt/lucee/server/lucee-server/context/logs/deploy.log")#</pre>");
	echo("<pre>#fileExists("/opt/lucee/extensions/redis.extension-3.0.0.51.lex")#</pre>");
	dump(directoryList("/opt/lucee/server/lucee-server/"));
	dump(fileRead(getCurrentTemplatePath()));
</cfscript>