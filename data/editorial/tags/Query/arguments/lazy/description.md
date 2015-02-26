
			if "lazy" is set to true (default "false") Lucee does not initially load all the data from the datasource,
			in that case the data are only loaded when requested, so this means the data are depending on the datasource connection.
			if the datasource connection is gone and the data are not requested yet, lucee throws a error if you try to access the data.
			lazy is only working when the following attributes are not used: cachewithin,cacheafter,result
			