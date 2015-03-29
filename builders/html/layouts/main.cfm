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

		<link href='http://fonts.googleapis.com/css?family=Muli:400,400italic,300italic,300' rel='stylesheet' type='text/css'>
		<link href="http://netdna.bootstrapcdn.com/font-awesome/4.0.3/css/font-awesome.css" rel="stylesheet">
		<link href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css" rel="stylesheet">
		<link href="assets/css/docs.css" rel="stylesheet">
		<link href="assets/css/highlight.css" rel="stylesheet">

		<link rel="icon" type="image/png" href="assets/img/luceelogoicon.png">

		<meta name="robots" content="noindex, nofollow">
	</head>
	<body class="#LCase( args.page.getPageType() )#">
		<nav class="navigation" role="navigation">
			#args.navTree#
		</nav>
		<div class="main" role="main">
			<article class="body">
				#args.crumbs#
				#args.body#
				#args.seeAlso#

				<div class="prev-next-container" role="navigation">
					<cfset prevPage = args.page.getPreviousPage() />
					<cfset nextPage = args.page.getNextPage() />
					<cfif not IsNull( prevPage )>
						<a href="#prevPage.getPath()#.html" title="Previous page: #HtmlEditFormat( prevPage.getTitle() )#"><i class="fa fa-fw fa-angle-left prev nav-link"></i></a>
					</cfif>
					<cfif not IsNull( nextPage )>
						<a href="#nextPage.getPath()#.html" title="Next page: #HtmlEditFormat( nextPage.getTitle() )#"><i class="fa fa-fw fa-angle-right next nav-link"></i></a>
					</cfif>
				</div>
			</article>

		</div>
	</body>
</html></cfoutput>