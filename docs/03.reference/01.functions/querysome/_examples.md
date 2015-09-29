```luceescript
qryPeople = queryNew("name,dob","varchar,date",[["Susi", CreateDate(1970,1,1)],["Urs",CreateDate(1995,1,1)],["Fred", CreateDate(1960,1,1)],["Jim", CreateDate(1988,1,1)]]);

dump(var=qryPeople, label='qryPeople - origional query');

	// query has someone named Fred
	valid = qryPeople.some(function(row, rowNumber, qryData){
		return row.name == 'Fred';
	});
	dump(var=valid, label='some() - query has someone named Fred');
	// query has someone named Nathan
	valid = qryPeople.some(function(row, rowNumber, qryData){
		return row.name == 'Nathan';
	});
	dump(var=valid, label='some() - query has someone named Nathan');
````
