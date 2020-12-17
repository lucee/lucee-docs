```luceescript+trycf
people = QueryNew( "name,dob,age", "varchar,date,int", [
    [ "Susi", CreateDate( 1970, 1, 1 ), 0 ],
    [ "Urs" , CreateDate( 1995, 1, 1 ), 0 ],
    [ "Fred", CreateDate( 1960, 1, 1 ), 0 ],
    [ "Jim" , CreateDate( 1988, 1, 1 ), 0 ]
]);

Dump( var=people, label="people - original query" );

/* Output:

| name | dob                 | age |
------------------------------------
| Susi | 1970-01-01 00:00:00 | 0   |
| Urs  | 1995-01-01 00:00:00 | 0   |
| Fred | 1960-01-01 00:00:00 | 0   |
| Jim  | 1988-01-01 00:00:00 | 0   |
*/

// data validation - age between 0 and 120
valid = people.every(function(row, rowNumber, qryData){
    return ((DateDiff('yyyy', row.dob, Now()) > 0) && (DateDiff('yyyy', row.dob, Now()) <= 100))
});
dump(var=valid, label='valid - age between 0 and 120');
/* Output: true */

// data validation - age between 40 and 50
valid = people.every(function(row, rowNumber, qryData){
    return ((DateDiff('yyyy', row.dob, Now()) > 40) && (DateDiff('yyyy', row.dob, Now()) <= 50))
});
dump(var=valid, label='valid - age between 40 and 50');
/* Output: false */
```
