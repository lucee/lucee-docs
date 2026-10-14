```luceescript
// Load all entities of a type
allUsers = entityLoad( "User" );

// Load by filter struct — returns an array
activeAdmins = entityLoad( "User", { status: "active", role: "admin" } );

// Sorted
users = entityLoad( "User", { status: "active" }, "name ASC" );

// Paginated
page = entityLoad( "User", { status: "active" }, "name ASC", { maxresults: 10, offset: 0 } );
```
