```luceescript
<cfscript>
    writeDump(label:"structure with invoke()", var:invoke(variables,'myStruct',{a:'First'}));
    private function myStruct(){
    	return "myStruct:"&serializeJson(arguments);
    }
    
    writeDump(label:"Adding numbers with invoke()", var:invoke(variables,'calc',{a:3,b:2}));
    private function calc(numeric a, numeric b){
    	return a+b;
    }
</cfscript>

```