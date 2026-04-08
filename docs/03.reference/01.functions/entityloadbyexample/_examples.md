```luceescript
// Create an example entity with filter criteria
example = entityNew( "User" );
example.setStatus( "active" );
example.setRole( "admin" );

// Load all matching entities
matches = entityLoadByExample( example );

// Load a single unique match
example = entityNew( "User" );
example.setEmail( "susi@example.com" );
user = entityLoadByExample( example, true );
```
