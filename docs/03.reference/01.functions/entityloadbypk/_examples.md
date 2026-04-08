```luceescript
// Load by primary key
user = entityLoadByPK( "User", 42 );
if ( isNull( user ) )
	throw( message="User not found" );

// Composite primary key
enrolment = entityLoadByPK( "Enrolment", { studentId: "abc", courseId: 101 } );
```
