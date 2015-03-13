<cfparam name="args.body"   type="string" />
<cfparam name="args.page"   type="any" />
<cfparam name="args.crumbs" type="array" />

<cfoutput><!DOCTYPE html>
<html>
	<head>
		<title>Lucee Documentation :: #args.page.getTitle()#</title>
		<base href="#( repeatString( '../', args.page.getDepth()-1 ) )#">

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
				<ol class="breadcrumb" role="navigation">
					<li><a href="index.html">Home</a></li>
					<cfloop array="#args.crumbs#" item="pageId" index="i">
						<li>{{ref:#pageId#}}</li>
					</cfloop>
					<li>#args.page.getTitle()#</li>
				</ol>
				#args.body#
			</article>
		</div>
	</body>
</html></cfoutput>