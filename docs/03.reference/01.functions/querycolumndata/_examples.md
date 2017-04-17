```luceescript
qryPeople = queryNew("name,dob","varchar,date",[["Susi", CreateDate(1970,1,1)],["Urs",CreateDate(1995,1,1)],["Fred", CreateDate(1960,1,1)],["Jim", CreateDate(1988,1,1)]]);

dump(var=qryPeople, label='qryPeople - origional query');


	ListOfName = qryPeople.ColumnData('name')
	dump(var=ListOfName, label='ColumnData() - ListOfName');

	ListOfName = qryPeople.ColumnData('name', function(name){
		//dump(var=arguments, label='ListOfName', abort=true);
		return 'Person name is: ' & name;
	})
	dump(var=ListOfName, label='ColumnData(with closure ) - ListOfName');
````
