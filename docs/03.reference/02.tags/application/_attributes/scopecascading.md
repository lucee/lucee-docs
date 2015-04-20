Depending on this setting Lucee scans certain scopes to find a variable called from the CFML source. This will only happen, when the variable is called without a scope. (Example: #myVar# instead of #variables.myVar#), the following values are supported:
- strict: scans only the variables scope
- small: scans the scopes variables,url,form
- standard: scans the scopes variables,cgi,url,form,cookie