<cfset local.args = arguments.args>
<cfparam name="args.body"       type="string" />
<cfparam name="args.page"       type="any" />
<cfparam name="args.crumbs"     type="string" />
<cfparam name="args.navTree"    type="string" />
<cfparam name="args.seeAlso"    type="string" />
<cfparam name="args.seeAlso"    type="string" />
<cfparam name="args.htmlOpts"   type="any" />

<cfoutput><!DOCTYPE html>
<html lang="en">
	<cfinclude template="html_head.cfm">
	
	<body class="#LCase( args.page.getPageType() )#">
		<nav class="menu menu-left nav-drawer" id="menu">
			<div class="menu-scroll">
				<div class="menu-wrap">
					<div class="menu-content">
						<a class="nav-drawer-logo" href="/index.html"><img alt="Lucee" class="Lucee" src="/assets/images/lucee-logo-bw.png"></a>
						#args.navTree#
						<hr>
						<ul class="nav">
							<li>
								<a href="https://lucee.org"><span class="material-symbols-outlined">public</span>Lucee Website</a>
							</li>
							<li>
								<a href="https://dev.lucee.org"><span class="material-symbols-outlined">forum</span>Developer Forum</a>
							</li>
							<li>
								<a href="https://lucee.us12.list-manage.com/subscribe?u=a8314f9282c07e84232a26805&id=172dc8293d"><span class="material-symbols-outlined">forum</span>Newsletter Signup</a>
							</li>
							<li>
								<a href="https://luceeserver.atlassian.net/browse/"><span class="material-symbols-outlined">bug_report</span>Issue Tracker</a>
							</li>
							<li>
								<a href="https://github.com/lucee/lucee-docs"><span class="material-symbols-outlined">code</span>Source repository</a>
							</li>
							<li>
								<a href="https://www.javadoc.io/doc/org.lucee/lucee/latest/index.html"><span class="material-symbols-outlined">code</span>Lucee JavaDocs</a>
							</li>
							<li>
								<a href="https://rorylaitila.gitbooks.io/lucee/content/"><span class="material-symbols-outlined">menu_book</span>Git Book</a>
							</li>
							<li>
								<a href="/download.html"><span class="material-symbols-outlined">download</span>Download</a>
							</li>
							<li>
								<a href="https://www.youtube.com/channel/UCdsCTvG8-gKUu4zA309EZYA"><span class="material-symbols-outlined">play_circle</span>Lucee on YouTube</a>
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
						<span class="material-symbols-outlined">menu</span>
						<span class="header-close material-symbols-outlined">close</span>
					</a>
				</li>
			</ul>
			<a class="header-logo hidden-lg" href="/index.html"><img alt="Lucee" src="/assets/images/lucee-logo.png"></a>
			<ul class="nav nav-list pull-right">
				<cfif args.edit>
					<li>
						<a href="/build_docs" title="Docs Administration">
							<span class="access-hide">Docs Administration</span>
							<span class="material-symbols-outlined">settings</span>
						</a>
					</li>
					<li>
						<a href="#local.pagePath#?reload=true" title="Reload Sources">
							<span class="access-hide">Reload Sources</span>
							<span class="material-symbols-outlined">refresh</span>
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
							<span class="material-symbols-outlined">arrow_back</span>
						</a>
					</li>
				</cfif>
				<cfif not IsNull( local.nextPage )>
					<li>
						<a href="#( local.nextPage.getPath() == '/home' ? '/' : '#local.nextPage.getPath()#.html' )#"
							title="#HtmlEditFormat( local.nextPage.getTitle() )#">
							<span class="access-hide">Previous page: #HtmlEditFormat( local.nextPage.getTitle() )#</span>
							<span class="material-symbols-outlined">arrow_forward</span>
						</a>
					</li>
				</cfif>
				<li>
					<a class="menu-random" title="Open a random documentation page">
						<span class="access-hide">Random page</span>
						<span class="material-symbols-outlined">swap_calls</span>
					</a>
				</li>
				<li>
					<a class="menu-toggle" href="##search">
						<span class="access-hide">Search</span>
						<span class="material-symbols-outlined">search</span>
						<span class="header-close material-symbols-outlined">close</span>
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
						<cfif local.path eq "/index">
                            <div class="col-lg-6 col-lg-push-1 body">
                        <cfelse>
                            <div class="col-lg-10 col-lg-push-1 body">
                        </cfif>
							<cfif len(trim(args.crumbs))>
							<div class="tile-wrap">
								<div class="tile breadcrumbs">
									#args.crumbs#
								</div>
							</div>
							</cfif>
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
					<a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/3.0/"><img alt="Creative Commons License" style="border-width:0" src="//i.creativecommons.org/l/by-nc-sa/3.0/80x15.png"></a>
					<a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/3.0/">Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License</a>.
				</p>
			</div>
		</footer>

		<cfif args.edit>
		<script src="/assets/js/base.js" type="text/javascript"></script>
		<script src="/assets/js/docsEditor.js" type="text/javascript"></script>
		<cfelse>
		<script src="/assets/js/dist/base.#application.assetBundleVersion#.min.js" type="text/javascript"></script>
		</cfif>
	</body>
</html></cfoutput>
