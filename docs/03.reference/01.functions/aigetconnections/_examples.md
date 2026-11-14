```lucee
// list all AI connections with their model and default category
connections = AIGetConnections();
loop query=connections {
	writeOutput( "#connections.name# (#connections.source#): #connections.model# #connections.default#<br>" );
}
```
