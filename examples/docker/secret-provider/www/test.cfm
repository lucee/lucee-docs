<cfscript>
	// =========================================================
	// Lucee Secret Provider Examples
	// =========================================================
	// Lucee supports multiple secret providers simultaneously.
	// You can fetch secrets by key alone (first matching provider wins)
	// or target a specific provider by name.
	// =========================================================


	// ---------------------------------------------------------
	// 1. Environment Variables  (provider: "env")
	// ---------------------------------------------------------

	// Auto-discover: returns the value from whichever provider has this key first
	dump(label:"ENV - any provider", var=secretproviderget("EXAMPLE_ENV_VAR"));

	// Explicit: target the "env" provider directly
	dump(label:"ENV - explicit provider", var=secretproviderget(key:"EXAMPLE_ENV_VAR", name:"env"));


	// ---------------------------------------------------------
	// 2. JSON File Secrets  (provider: "json")
	// ---------------------------------------------------------

	// Auto-discover
	dump(label:"JSON - any provider", var=secretproviderget("example_secret"));

	// Explicit
	dump(label:"JSON - explicit provider", var=secretproviderget(key:"example_secret", name:"json"));


	// ---------------------------------------------------------
	// 3. AWS Secrets Manager  (provider: "sm")
	// ---------------------------------------------------------

	// Fetch the raw secret - returns a JSON string
	dump(label:"SM - raw JSON string", var=secretproviderget("mysecret", "sm"));

	// Parse the JSON string into a struct for easier access
	dump(label:"SM - parsed struct", var=deserializeJson(secretproviderget("mysecret", "sm")));

	// With jsonTraversal=true in config, you can dot-navigate into JSON keys directly
	dump(label:"SM - dot traversal (password)", var=secretproviderget("mysecret.password", "sm"));


	// ---------------------------------------------------------
	// 4. AWS Parameter Store  (provider: "ps")
	// ---------------------------------------------------------

	// Fetch a simple string parameter
	dump(label:"PS - raw value", var=secretproviderget("myparameter", "ps"));

	// If the parameter value is JSON, dot traversal works here too
	dump(label:"PS - dot traversal (password)", var=secretproviderget("myparameter.password", "ps"));

</cfscript>