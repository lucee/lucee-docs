component output=false {
	function getDatesForFolder( repo, folder, stats={}, skip ) {
		var path = arguments.repo & "\" & arguments.folder;
		systemOutput("stats:" & structCount(stats), true);
		var files = directoryList(path=path, filter="*.md",listinfo="query");
		var _stats= arguments.stats;
		var _skip = arguments.skip;
		var jGit = new jGit();

		files = queryFilter(files, function(file){
			return !structKeyExists( _skip, file.name );
		});

		var stFiles = QueryToStruct( query=files, columnKey="name" );
		
		structEach(stFiles, function(name, file){
			if ( structKeyExists(_stats, name) ){
				structAppend(file, _stats[name], false);
				file.isDirty = !(structKeyExists(_stats, name) && DateCompare(_stats[name].dateLastModified, file.dateLastModified) == 0);
			} else {
				file.isDirty = true;
			}
		});
		
		return jGit.getFileCommitDates(repo, folder, stFiles , "all");
	}

	function convertToQuery(stats){
		var q = queryNew("name,created,updated");
		
		structEach(arguments.stats, function(k, v){
			var r = QueryAddRow(q);
			QuerySetCell(q, "name", k, r);
			QuerySetCell(q, "created", arrayLast(v.commits), r);
			QuerySetCell(q, "updated", arrayFirst(v.commits), r);
			//QuerySetCell(q, "age", DateDiff("d", q.created[r],q.updated[r]), r);
		});
		return q
	}
}
