possible values are:
String "request": If original query was created within the current request, cached query data is used.
a timespan (created with function CreateTimeSpan): If original query date falls within the time span, cached query data is used.

To use cached data, the current query must use the same SQL statement, data source, query name, user name, and password.