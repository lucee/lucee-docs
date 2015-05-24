<cfparam name="args.body"       type="string" />
<cfparam name="args.page"       type="any" />
<cfparam name="args.crumbs"     type="string" />
<cfparam name="args.navTree"    type="string" />
<cfparam name="args.seeAlso"    type="string" />

<cfoutput><!DOCTYPE html>
<html>
	<head>
		<title>Lucee Documentation :: #args.page.getTitle()#</title>
		<base href="#( repeatString( '../', args.page.getDepth()-1 ) )#">

		<link href="assets/css/base.min.css" rel="stylesheet">
		<link rel="icon" type="image/png" href="assets/images/luceelogoicon.png">
	</head>

	<body class="avoid-fout #LCase( args.page.getPageType() )#">
		<div class="avoid-fout-indicator avoid-fout-indicator-fixed">
			<div class="progress-circular progress-circular-alt progress-circular-center">
				<div class="progress-circular-wrapper">
					<div class="progress-circular-inner">
						<div class="progress-circular-left">
							<div class="progress-circular-spinner"></div>
						</div>
						<div class="progress-circular-gap"></div>
						<div class="progress-circular-right">
							<div class="progress-circular-spinner"></div>
						</div>
					</div>
				</div>
			</div>
		</div>

		<nav class="menu menu-left nav-drawer" id="menu">
			<div class="menu-scroll">
				<div class="menu-wrap">
					<div class="menu-content">
						<a class="nav-drawer-logo" href="index.html"><img class="Lucee" src="assets/images/lucee-logo-bw.png"></a>
						#args.navTree#
						<hr>
						<ul class="nav">
							<li>
								<a href="http://lucee.org"><span class="fa fa-fw fa-globe"></span>Lucee Website</a>
							</li>
							<li>
								<a href="https://bitbucket.org/lucee/lucee"><span class="fa fa-fw fa-bitbucket"></span>Source repository</a>
							</li>
						</ul>
					</div>
				</div>
			</div>
		</nav>

		<header class="header">
			<ul class="hidden-lg nav nav-list pull-left">
				<li>
					<a class="menu-toggle" href="##menu">
						<span class="access-hide">Menu</span>
						<span class="icon icon-menu icon-lg"></span>
						<span class="header-close icon icon-close icon-lg"></span>
					</a>
				</li>
			</ul>
			<a class="header-logo hidden-lg" href="index.html"><img alt="Lucee" src="assets/images/lucee-logo.png"></a>
			<ul class="nav nav-list pull-right">
				<cfset prevPage = args.page.getPreviousPage() />
				<cfset nextPage = args.page.getNextPage() />
				<cfif not IsNull( prevPage )>
					<li>
						<a href="#( prevPage.getPath() == '/home' ? '/' : '#prevPage.getPath()#.html' )#">
							<span class="access-hide">Previous page: #HtmlEditFormat( prevPage.getTitle() )#</span>
							<span class="icon icon-arrow-back icon-lg"></span>
						</a>
					</li>
				</cfif>
				<cfif not IsNull( nextPage )>
					<li>
						<a href="#( nextPage.getPath() == '/home' ? '/' : '#nextPage.getPath()#.html' )#">
							<span class="access-hide">Previous page: #HtmlEditFormat( nextPage.getTitle() )#</span>
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
		</header>
		<form class="menu menu-right menu-search" id="search">
			<div class="menu-scroll">
				<div class="menu-wrap">
					<div class="menu-content">
						<div class="menu-content-inner">
							<label class="access-hide" for="menu-search">Search</label>
							<input class="form-control form-control-lg menu-search-focus" id="menu-search" placeholder="Search" type="search">
							<button class="access-hide" type="submit">Search</button>
							<div class="p">
							</div>
						</div>
					</div>
				</div>
			</div>
		</form>

		<script src="assets/js/base.min.js" type="text/javascript"></script>
	</body>
</html></cfoutput>