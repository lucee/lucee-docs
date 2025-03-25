The SQL data type that the parameter will be bound to.
	
Common types include:

- `varchar`: For strings (default)
- `integer`, `bigint`, `smallint`, `tinyint`: For various sized integers
- `double`, `decimal`, `money`: For floating point/decimal values
- `bit`, `boolean`: For boolean values
- `date`, `time`, `timestamp`: For date/time values
- `binary`, `blob`: For binary data

A list of SQL types can be found on the [SQL Type page](/guides/cookbooks/Sql-Types.html). All can be used with or without the `CF_SQL_` prefix.
	Using the correct type improves security, enables proper type checking, and optimizes query execution. 
