```lucee+trycf
// List all system properties  
<cfdump var="#GetSystemPropOrEnvVar()#" />  

// Return the configured value; otherwise, return empty  
<cfdump var="#GetSystemPropOrEnvVar('lucee.cache.variableKeys')#" />  

```