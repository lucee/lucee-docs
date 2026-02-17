<cfscript>
	cfsetting(showdoc=true);

	// get secret from any provider, don't care which one
	dump(eval:'secretproviderget("EXAMPLE_ENV_VAR")');
	
	// get secret from provider "env", don't care which one
	dump(eval:'secretproviderget(key:"EXAMPLE_ENV_VAR",name:"env")');
	

	
</cfscript>