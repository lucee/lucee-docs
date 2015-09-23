```luceescript
qryPeople = queryNew("name,dob","varchar,date",[["Susi", CreateDate(1970,1,1)],["Urs",CreateDate(1995,1,1)],["Fred", CreateDate(1960,1,1)],["Jim", CreateDate(1988,1,1)]]);

dump(var=qryPeople, label='qryPeople - origional query');

	//filter - older than 21
	qryPeopleOldEnough = qryPeople.filter(function(row, rowNumber, qryData){
		return DateDiff('yyyy', row.dob, Now()) > 21
	});
	dump(var=qryPeopleOldEnough, label='filter() - qryPeopleOldEnough = older than 21');
````
