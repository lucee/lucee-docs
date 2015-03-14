<cfparam name="args.body"    type="string" />
<cfparam name="args.page"    type="any" />
<cfparam name="args.crumbs"  type="string" />
<cfparam name="args.navTree" type="string" />
<cfparam name="args.seeAlso" type="string" />

<cfoutput><!DOCTYPE html>
<html>
	<head>
		<title>Lucee Documentation :: #args.page.getTitle()#</title>
		<base href="#( repeatString( '../', args.page.getDepth()-1 ) )#">

		<link rel="stylesheet" href="http://fonts.googleapis.com/css?family=Source+Sans+Pro:400,700,400italic&subset=latin-ext">
		<link href="http://netdna.bootstrapcdn.com/font-awesome/4.0.3/css/font-awesome.css" rel="stylesheet">
		<link href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css" rel="stylesheet">
		<link href="assets/css/docs.css" rel="stylesheet">
		<link href="assets/css/highlight.css" rel="stylesheet">

		<link rel="icon" type="image/png" href="assets/img/luceelogoicon.png">

		<meta name="robots" content="noindex, nofollow">
	</head>
	<body>
		<nav class="navigation" role="navigation">
			#args.navTree#
		</nav>
		<div class="main" role="main">
			<article class="body">
				#args.crumbs#
				#args.body#
				#args.seeAlso#
			</article>
		</div>
	</body>
</html></cfoutput>