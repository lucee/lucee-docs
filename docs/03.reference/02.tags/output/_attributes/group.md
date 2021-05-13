Specifies the query column to use when you group sets of records together. Use this attribute
if you have retrieved a record set ordered on a certain query column. For example, if a record set is
ordered according to "CustomerID" in the cfquery tag, you can group the output on "CustomerID." The
group attribute, which is case sensitive, eliminates adjacent duplicates when the data is sorted by
the specified field. See the groupCaseSensitive attribute for information about specifying a case
insensitive grouping.
