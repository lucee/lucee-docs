```luceescript
qryPeople = queryNew("name,dob","varchar,date",[["Susi", CreateDate(1970,1,1)],["Urs",CreateDate(1995,1,1)],["Fred", CreateDate(1960,1,1)],["Jim", CreateDate(1988,1,1)]]);

dump(var=qryPeople, label='qryPeople - origional query');

//each - calculate age
people = [];
qryPeopleOldEnough = qryPeople.each(function(row, rowNumber, qryData){
	people.Append({'age': DateDiff('yyyy', row.dob, Now())})
});
dump(var=people, label='each() - calculated age');
```
