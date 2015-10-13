[run on trycf.com](http://trycf.com/gist/7857e8df81ba3cf10e14/lucee)

```luceescript
people = QueryNew( "name,dob,age", "varchar,date,int", [
    [ "Susi", CreateDate( 1970, 1, 1 ), 0 ],
    [ "Urs" , CreateDate( 1995, 1, 1 ), 0 ],
    [ "Fred", CreateDate( 1960, 1, 1 ), 0 ],
    [ "Jim" , CreateDate( 1988, 1, 1 ), 0 ]
]);

Dump( var=people, label="people - origional query" );

/* Output:

| name | dob                 | age |
------------------------------------
| Susi | 1970-01-01 00:00:00 | 0   |
| Urs  | 1995-01-01 00:00:00 | 0   |
| Fred | 1960-01-01 00:00:00 | 0   |
| Jim  | 1988-01-01 00:00:00 | 0   |
*/

//filter - older than 21
qryPeopleOldEnough = people.filter(function(row, rowNumber, qryData){
    return DateDiff('yyyy', row.dob, Now()) > 21
});
dump(var=qryPeopleOldEnough, label='qryPeopleOldEnough - older than 21');

/* Output:

| name | dob                 | age |
------------------------------------
| Susi | 1970-01-01 00:00:00 | 0   |
| Fred | 1960-01-01 00:00:00 | 0   |
| Jim  | 1988-01-01 00:00:00 | 0   |
*/
```
