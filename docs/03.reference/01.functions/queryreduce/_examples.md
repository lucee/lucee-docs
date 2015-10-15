```luceescript
qryPeople = queryNew("name,dob","varchar,date",[["Susi", CreateDate(1970,1,1)],["Urs",CreateDate(1995,1,1)],["Fred", CreateDate(1960,1,1)],["Jim", CreateDate(1988,1,1)]]);

dump(var=qryPeople, label='qryPeople - origional query');

	// number of people over the age of 21
	counter = qryPeople.reduce(function(result, row, rowNumber, qryData){
		//dump(var=arguments, abort=false);
		if (DateDiff('yyyy', row.dob, Now()) > 21)
			result +=1;
		return result;
	}, 0);
	dump(var=counter, label='reduce() - number of people over the age of 21');
````
