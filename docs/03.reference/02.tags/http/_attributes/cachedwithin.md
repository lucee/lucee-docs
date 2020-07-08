possible values are:
String "request": If original content was created within the current request, cached content data is used.
a timespan (created with function CreateTimeSpan): If original content date falls within the time span, cached content data is used.

To use cached data, the tag must be called with the exact same arguments.