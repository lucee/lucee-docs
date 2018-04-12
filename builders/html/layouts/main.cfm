<cfparam name="args.body"       type="string" />
<cfparam name="args.page"       type="any" />
<cfparam name="args.crumbs"     type="string" />
<cfparam name="args.navTree"    type="string" />
<cfparam name="args.seeAlso"    type="string" />

<cfscript>
	local.baseHref = ( repeatString( '../', args.page.getDepth()-1 ) );
	// this breaks the /static/ local server mode
	//if (baseHref eq "")
	//	baseHref = "/";
	local.pageHref = "http://docs.lucee.org#args.page.getPath()#.html";
	local.pagePath = "#args.page.getPath()#.html";
	local.pageTitle = HtmlEditFormat( args.page.getTitle() ) & " :: Lucee Documentation";
	local.pageDescription = getMetaDescription( args.page, args.body );
</cfscript>

<cfoutput><!DOCTYPE html>
<html lang="en">
	<head>
		<title>#pageTitle#</title>
		<script async src="https://www.googletagmanager.com/gtag/js?id=UA-116664465-1"></script>
		<script>
			window._gaTrackingID = 'UA-116664465-1';
			window.dataLayer = window.dataLayer || [];
			function gtag(){dataLayer.push(arguments);}
			gtag('js', new Date());
			gtag('config', window._gaTrackingID);
		</script>
		<cfif args.edit>
			<base href="#local.baseHref#">
		</cfif>
		<link rel="canonical" href="#local.pageHref#" />
		<meta content="#getMetaDescription( args.page, args.body )#" name="description">
		<meta content="initial-scale=1.0, width=device-width" name="viewport">
		<link rel="alternate" href="http://open.iframe.ly/api/oembed?url=#local.pageHref#&origin=lucee"
            type="application/json+oembed" />
    	<link rel="alternate" href="http://open.iframe.ly/api/oembed?url=#local.pageHref#&origin=lucee&format=xml"
            type="application/xml+oembed"/>
		<meta name="twitter:card" content="summary" />
		<meta name="twitter:site" content="@lucee_server" />
		<meta name="twitter:title" content="#local.pageTitle#" />
		<meta name="twitter:description" content="#local.pageDescription#" />
		<meta name="twitter:image" content="http://docs.lucee.org/assets/images/favicon.png" />
		<meta name="twitter:image:alt" content="Lucee" />
		<meta property="og:title" content="#pageTitle#" />
		<meta property="og:url" content="#pageHref#" />
		<meta property="og:type" content="article" />
		<meta property="og:image" content="http://docs.lucee.org/assets/images/favicon.png" />
		<meta property="og:image:alt" content="Lucee" />
		<cfif args.edit>
		<link href="/assets/css/base.css" rel="stylesheet">
		<cfelse>
		<link href="/assets/css/base.min.css" rel="stylesheet">
		</cfif>
		<link href="/assets/css/highlight.css" rel="stylesheet">
		<link rel="icon" type="image/png" href="/assets/images/favicon.png">
		<!-- ie -->
		<!--[if lt IE 9]>
			<script src="/assets/js/html5shiv.js" type="text/javascript"></script>
			<script src="/assets/js/respond.js" type="text/javascript"></script>
		<![endif]-->
	</head>

	<body class="#LCase( args.page.getPageType() )#">
		<nav class="menu menu-left nav-drawer" id="menu">
			<div class="menu-scroll">
				<div class="menu-wrap">
					<div class="menu-content">
						<a class="nav-drawer-logo" href="index.html"><img class="Lucee" src="/assets/images/lucee-logo-bw.png"></a>
						#args.navTree#
						<hr>
						<ul class="nav">
							<li>
								<a href="http://lucee.org"><span class="fa fa-fw fa-globe"></span>Lucee Website</a>
							</li>
							<li>
								<a href="https://dev.lucee.org"><span class="fa fa-fw fa-comments"></span>Mailing List</a>
							</li>
							<li>
								<a href="https://luceeserver.atlassian.net/browse/"><span class="fa fa-fw fa-bug"></span>Issue Tracker</a>
							</li>
							<li>
								<a href="https://github.com/lucee/lucee-docs"><span class="fa fa-fw fa-github"></span>Source repository</a>
							</li>
							<li>
								<a href="http://javadoc.lucee.org"><span class="fa fa-fw fa-code"></span>JavaDocs</a>
							</li>
							<li>
								<a href="https://rorylaitila.gitbooks.io/lucee/content/"><span class="fa fa-fw fa-book"></span>Git Book</a>
							</li>
							<li>
								<a href="download.html"><span class="fa fa-fw fa-download"></span>Download</a>
							</li>
							<li>
								<a href="https://www.youtube.com/channel/UCdsCTvG8-gKUu4zA309EZYA"><span class="fa fa-fw fa-youtube-play"></span>Lucee on YouTube</a>
							</li>
						</ul>
					</div>
				</div>
			</div>
		</nav>

		<header class="header">
			<ul class="hidden-lg nav nav-list pull-left">
				<li>
					<a class="menu-toggle menu-toggle-sidebar" href="##menu">
						<span class="access-hide">Menu</span>
						<span class="icon icon-menu icon-lg"></span>
						<span class="header-close icon icon-close icon-lg"></span>
					</a>
				</li>
			</ul>
			<a class="header-logo hidden-lg" href="index.html"><img alt="Lucee" src="/assets/images/lucee-logo.png"></a>
			<ul class="nav nav-list pull-right">
				<cfif args.edit>
					<li>
						<a href="/build_docs" title="Docs Administration">
							<span class="access-hide">Docs Administration</span>
							<span class="icon icon-settings icon-lg"></span>
						</a>
					</li>
					<li>
						<a href="#local.pagePath#?reload=true" title="Reload Sources">
							<span class="access-hide">Reload Sources</span>
							<span class="icon icon-refresh icon-lg"></span>
						</a>
					</li>
				</cfif>
				<cfset local.prevPage = args.page.getPreviousPage() />
				<cfset local.nextPage = args.page.getNextPage() />
				<cfif not IsNull( local.prevPage )>
					<li>
						<a href="#( local.prevPage.getPath() == '/home' ? '/' : '#local.prevPage.getPath()#.html' )#"
							title="#HtmlEditFormat( local.prevPage.getTitle() )#">
							<span class="access-hide">Previous page: #HtmlEditFormat( local.prevPage.getTitle() )#</span>
							<span class="icon icon-arrow-back icon-lg"></span>
						</a>
					</li>
				</cfif>
				<cfif not IsNull( local.nextPage )>
					<li>
						<a href="#( local.nextPage.getPath() == '/home' ? '/' : '#local.nextPage.getPath()#.html' )#"
							title="#HtmlEditFormat( local.nextPage.getTitle() )#">
							<span class="access-hide">Previous page: #HtmlEditFormat( local.nextPage.getTitle() )#</span>
							<span class="icon icon-arrow-forward icon-lg"></span>
						</a>
					</li>
				</cfif>
				<li>
					<a class="menu-toggle" href="##search">
						<span class="access-hide">Search</span>
						<span class="icon icon-search icon-lg"></span>
						<span class="header-close icon icon-close icon-lg"></span>
					</a>
				</li>
			</ul>
			<span class="header-fix-show header-logo pull-none text-overflow">#HtmlEditFormat( args.page.getTitle() )#</span>
		</header>
		<div class="menu menu-right menu-search" id="search">
			<div class="menu-scroll">
				<div class="menu-wrap">
					<div class="menu-content">
						<div class="menu-content-inner">
							<label class="access-hide" for="lucee-docs-search-input">Search</label>
							<input class="form-control form-control-lg menu-search-focus" id="lucee-docs-search-input" placeholder="Search" type="search">
						</div>
					</div>
				</div>
			</div>
		</div>

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
					<a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/3.0/"><img alt="Creative Commons License" style="border-width:0" src="http://i.creativecommons.org/l/by-nc-sa/3.0/80x15.png"></a>
					<a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/3.0/">Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License</a>.
				</p>
			</div>
		</footer>

		<cfif args.edit>
		<script src="/assets/js/base.js" type="text/javascript"></script>
		<script src="/assets/js/docsEditor.js" type="text/javascript"></script>
		<cfelse>
		<script src="/assets/js/dist/base.15.min.js" type="text/javascript"></script>
		</cfif>
	</body>
</html></cfoutput>
