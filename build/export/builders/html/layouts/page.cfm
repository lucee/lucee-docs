<cfparam name="args.body"  type="string" />
<cfparam name="args.title" type="string" />

<cfoutput>
<!DOCTYPE html>
<html>
	<head>
		<title>#args.title#</title>
	</head>
	<body>
		#args.body#
	</body>
</html>
</cfoutput>