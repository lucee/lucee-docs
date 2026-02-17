<cfscript>
	//cfsetting(showdoc=true);

	// get secret from any provider, don't care which one
	dump(eval:'secretproviderget("EXAMPLE_ENV_VAR")');
	
	// get secret from provider "env"
	dump(eval:'secretproviderget(key:"EXAMPLE_ENV_VAR",name:"env")');


	// get secret from any provider, don't care which one
	dump(eval:'secretproviderget("example_secret")');

	// get secret from provider "json"
	dump(eval:'secretproviderget(key:"example_secret",name:"json")');
	
</cfscript>