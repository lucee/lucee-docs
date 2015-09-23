```luceescript
qryPeople = queryNew("name,dob","varchar,date",[["Susi", CreateDate(1970,1,1)],["Urs",CreateDate(1995,1,1)],["Fred", CreateDate(1960,1,1)],["Jim", CreateDate(1988,1,1)]]);

dump(var=qryPeople, label='qryPeople - origional query');

	// data validation - age between 0 and 120
	valid = qryPeople.every(function(row, rowNumber, qryData){
		return ((DateDiff('yyyy', row.dob, Now()) > 0) && (DateDiff('yyyy', row.dob, Now()) <= 100))
	});
	dump(var=valid, label='every() - valid = age between 0 and 120');

	// data validation - age between 18 and 25
	valid = qryPeople.every(function(row, rowNumber, qryData){
		return ((DateDiff('yyyy', row.dob, Now()) > 18) && (DateDiff('yyyy', row.dob, Now()) <= 25))
	});
	dump(var=valid, label='every() - valid = age between 18 and 25');

````
