<cfparam name="args.body"       type="string" />
<cfparam name="args.page"       type="any" />
<cfparam name="args.crumbs"     type="string" />
<cfparam name="args.navTree"    type="string" />
<cfparam name="args.seeAlso"    type="string" />

<cfoutput><!DOCTYPE html>
<html>
	<head>
		<title>#HtmlEditFormat( args.page.getTitle() )# :: Lucee Documentation</title>
		<base href="">
		<meta content="#getMetaDescription( args.page, args.body )#" name="description">
		<meta content="initial-scale=1.0, width=device-width" name="viewport">
		<link href="assets/css/base.min.css" rel="stylesheet">
		<link href="assets/css/highlight.css" rel="stylesheet">
		<link rel="icon" type="image/png" href="assets/images/favicon.png">
	</head>

	<body class="#LCase( args.page.getPageType() )#" style="margin-bottom:150px;">
		<header class="header">
			<a class="header-logo hidden-lg" href="index.html"><img alt="Lucee" src="assets/images/lucee-logo.png"></a>
			<ul class="nav nav-list pull-right">
				<cfset prevPage = args.page.getPreviousPage() />
				<cfset nextPage = args.page.getNextPage() />
				<cfif not IsNull( prevPage )>
					<li>
						<a href="#( prevPage.getPath() == '/home' ? '/' : '#prevPage.getId()#.html' )#">
							<span class="access-hide">Previous page: #HtmlEditFormat( prevPage.getTitle() )#</span>
							<span class="icon icon-arrow-back icon-lg"></span>
						</a>
					</li>
				</cfif>
				<cfif not IsNull( nextPage )>
					<li>
						<a href="#( nextPage.getPath() == '/home' ? '/' : '#nextPage.getId()#.html' )#">
							<span class="access-hide">Previous page: #HtmlEditFormat( nextPage.getTitle() )#</span>
							<span class="icon icon-arrow-forward icon-lg"></span>
						</a>
					</li>
				</cfif>
			</ul>
			<span class="header-fix-show header-logo pull-none text-overflow">#HtmlEditFormat( args.page.getTitle() )#</span>
		</header>

		<div class="content">
			<div class="content-heading">
				<div class="container">
					<div class="row">
						<div class="col-lg-10 col-lg-push-1">
							<h1 class="heading">#HtmlEditFormat( args.page.getTitle() )#</h1>
						</div>
					</div>
				</div>
			</div>

			<div class="content-inner">
				<div class="container">
					<div class="row">
						<div class="col-lg-10 col-lg-push-1 body">
							<div class="tile-wrap">
								<div class="tile">
									#args.crumbs#
								</div>
							</div>
							#args.body#
							#args.seeAlso#
						</div>
					</div>
				</div>
			</div>
		</div>

		<footer class="footer">
			<div class="container">
				<p>The Lucee Documentation is developed and maintained by the Lucee Association Switzerland and is licensed under a
					<a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/3.0/">Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License</a>.
				</p>
			</div>
		</footer>
	</body>
</html></cfoutput>