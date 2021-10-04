```luceescript
<cfscript>
    writeDump(label:"structure with invoke()", var:invoke(variables,'myStruct',{a:'First'}));
    private function myStruct(){
    	return "myStruct:"&serializeJson(arguments);
    }
    
    writeDump(label:"Adding numbers with invoke()", var:invoke(variables,'calc',{a:3,b:2}));
    private function calc(a numeric,b numeric){
    	return a+b;
    }
</cfscript>

```