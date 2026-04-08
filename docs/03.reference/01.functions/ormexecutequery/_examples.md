```luceescript
// Named parameters
users = ORMExecuteQuery(
	"FROM User WHERE status = :status",
	{ status: "active" }
);

// Positional parameters
users = ORMExecuteQuery(
	"FROM User WHERE name = ?1",
	[ "Susi" ]
);

// Single result
user = ORMExecuteQuery(
	"FROM User WHERE email = :email",
	{ email: "susi@example.com" },
	true
);

// Pagination
page = ORMExecuteQuery(
	"FROM User ORDER BY name",
	{},
	false,
	{ maxresults: 10, offset: 20 }
);

// IN clause with array
users = ORMExecuteQuery(
	"FROM User WHERE role IN (:roles)",
	{ roles: [ "admin", "editor" ] }
);

// Aggregate
total = ORMExecuteQuery( "select count(u) from User u", {}, true );

// Bulk update (no entity events fired)
ORMExecuteQuery(
	"UPDATE User SET status = :status WHERE lastLogin < :cutoff",
	{ status: "inactive", cutoff: dateAdd( "m", -6, now() ) }
);
```
