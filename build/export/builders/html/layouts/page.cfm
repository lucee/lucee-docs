<cfparam name="args.body"  type="string" />
<cfparam name="args.title" type="string" />
<cfparam name="args.base"  type="string" default="./" />

<cfoutput><!DOCTYPE html>
<html>
	<head>
		<title>#args.title#</title>
		<base href="#args.base#">

		<link rel="stylesheet" href="http://fonts.googleapis.com/css?family=Source+Sans+Pro:400,700,400italic&subset=latin-ext">
		<link href="http://netdna.bootstrapcdn.com/font-awesome/4.0.3/css/font-awesome.css" rel="stylesheet">
		<link href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css" rel="stylesheet">
		<link href="assets/css/docs.css" rel="stylesheet">
	</head>
	<body>
		<nav class="navigation" role="navigation">
		</nav>
		<div class="main" role="main">
			<article class="body">
				#args.body#
			</article>
		</div>
	</body>
</html></cfoutput>