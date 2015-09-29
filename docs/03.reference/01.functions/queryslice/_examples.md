```luceescript
qryPeople = queryNew("name,dob","varchar,date",[["Susi", CreateDate(1970,1,1)],["Urs",CreateDate(1995,1,1)],["Fred", CreateDate(1960,1,1)],["Jim", CreateDate(1988,1,1)]]);

dump(var=qryPeople, label='qryPeople - origional query');

	// paging
	qrySlice = qryPeople.slice(3,2)
	dump(var=qrySlice, label='slice() - qrySlice = from record 3, 2 records');
````
