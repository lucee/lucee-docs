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
	// 2. System Properties  (provider: "sysprop")
	// ---------------------------------------------------------

	// Fetch a JVM system property (e.g., java.version, user.home)
	dump(label:"SYSPROP - java.version", var=secretproviderget("java.version", "sysprop"));
	dump(label:"SYSPROP - user.home", var=secretproviderget("user.home", "sysprop"));

	// System properties support case-insensitive lookup (as configured)
	dump(label:"SYSPROP - case insensitive", var=secretproviderget("JAVA.VERSION", "sysprop"));


	// ---------------------------------------------------------
	// 3. JSON File Secrets  (provider: "json")
	// ---------------------------------------------------------

	// Auto-discover
	dump(label:"JSON - any provider", var=secretproviderget("example_secret"));

	// Explicit
	dump(label:"JSON - explicit provider", var=secretproviderget(key:"example_secret", name:"json"));


	// ---------------------------------------------------------
	// 4. AWS Secrets Manager  (provider: "sm")
	// ---------------------------------------------------------

	// Fetch the raw secret - returns a JSON string
	dump(label:"SM - raw JSON string", var=secretproviderget("mysecret", "sm"));

	// Parse the JSON string into a struct for easier access
	dump(label:"SM - parsed struct", var=deserializeJson(secretproviderget("mysecret", "sm")));

	// With jsonTraversal=true in config, you can dot-navigate into JSON keys directly
	dump(label:"SM - dot traversal (password)", var=secretproviderget("mysecret.password", "sm"));


	// ---------------------------------------------------------
	// 5. AWS Parameter Store  (provider: "ps")
	// ---------------------------------------------------------

	// Fetch a simple string parameter
	dump(label:"PS - raw value", var=secretproviderget("myparameter", "ps"));

	// If the parameter value is JSON, dot traversal works here too
	dump(label:"PS - dot traversal (password)", var=secretproviderget("myparameter.password", "ps"));


	// =========================================================
	// NEW: Listing, Setting, and Removing Secrets
	// =========================================================
	// These functions are part of the SecretProviderExtended API.
	// Not all providers support these operations:
	// - env: read-only (cannot set/remove)
	// - sysprop: read-write via System.setProperty/clearProperty
	// - json: read-write when readonly=false in config
	// - sm/ps: not yet supported
	// =========================================================


	// ---------------------------------------------------------
	// 6. List Secret Names
	// ---------------------------------------------------------

	// List all secret names from all providers that support listing
	dump(label:"All secret names", var=secretproviderlistnames());

	// List secret names from a specific provider
	dump(label:"ENV - secret names", var=secretproviderlistnames("env"));
	dump(label:"SYSPROP - secret names", var=secretproviderlistnames("sysprop"));
	dump(label:"JSON - secret names", var=secretproviderlistnames("json"));


	// ---------------------------------------------------------
	// 7. List Secrets (names with references)
	// ---------------------------------------------------------

	// List all secrets from all providers (values are lazy-loaded references)
	dump(label:"All secrets (lazy)", var=secretproviderlist());

	// List all secrets with immediate resolution
	dump(label:"All secrets (resolved)", var=secretproviderlist(resolve:true));

	// List secrets from a specific provider
	dump(label:"JSON - all secrets", var=secretproviderlist("json"));
	dump(label:"SYSPROP - all secrets", var=secretproviderlist("sysprop"));


// ---------------------------------------------------------
	// 8. Set Secrets (only writable providers)
	// ---------------------------------------------------------

	// Set a string system property at runtime
	secretproviderset("my.custom.property", "super-secret-value", "sysprop");
	dump(label:"SYSPROP - newly set property", var=secretproviderget("my.custom.property", "sysprop"));

	// Set a boolean system property
	secretproviderset("feature.enabled", true, "sysprop");
	dump(label:"SYSPROP - boolean property", var=secretproviderget("feature.enabled", "sysprop"));

	// Set an integer system property
	secretproviderset("max.connections", 100, "sysprop");
	dump(label:"SYSPROP - integer property", var=secretproviderget("max.connections", "sysprop"));

	// Note: Setting on read-only providers will throw an exception
	// secretproviderset("TEST_VAR", "value", "env"); // Throws: Environment variables are read-only
	// secretproviderset("my_secret", "value", "json"); // Throws: File provider is read-only


	// ---------------------------------------------------------
	// 9. Remove Secrets (only writable providers)
	// ---------------------------------------------------------

	// Remove a system property at runtime
	secretproviderremove("my.custom.property", "sysprop");

	// Verify removal - this will throw an exception since the property no longer exists
	// dump(label:"SYSPROP - property removed", var=secretproviderget("my.custom.property", "sysprop"));

	// Clean up other properties we set
	secretproviderremove("feature.enabled", "sysprop");
	secretproviderremove("max.connections", "sysprop");

	// Note: Removing from read-only providers will throw an exception
	// secretproviderremove("EXAMPLE_ENV_VAR", "env"); // Throws: Environment variables are read-only
	// secretproviderremove("my_secret", "json"); // Throws: File provider is read-only
</cfscript>