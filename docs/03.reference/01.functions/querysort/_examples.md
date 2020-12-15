```luceescript+trycf
people = QueryNew( "name,dob,age", "varchar,date,int", [
    [ "Susi", CreateDate( 1970, 1, 1 ), 70 ],
    [ "Urs" , CreateDate( 1995, 1, 1 ), 40 ],
    [ "Fred", CreateDate( 1960, 1, 1 ), 50 ],
    [ "Jim" , CreateDate( 1988, 1, 1 ), 30 ]
]);

Dump( var=people, label="people - original query" );

QuerySort(people, 'name', 'asc');
dump(var=people, label='people - sorted by name');

QuerySort(people, function(row1, row2){
	return compare(arguments.row1.age, arguments.row2.age);
});
dump(var=people, label='people - sorted by age');

```