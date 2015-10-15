```luceescript+trycf
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

people = people.map( function( row, rowNumber, recordset ){
    row['age'] = DateDiff( 'yyyy', row.dob, Now() );
    return row;
});

Dump( var=people, label='people - with calculated age' );

/* Output:

| name | dob                 | age |
------------------------------------
| Susi | 1970-01-01 00:00:00 | 45  |
| Urs  | 1995-01-01 00:00:00 | 20  |
| Fred | 1960-01-01 00:00:00 | 55  |
| Jim  | 1988-01-01 00:00:00 | 27  |

*/
```
