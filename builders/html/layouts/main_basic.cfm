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
	<div class="content">
		<h1 class="heading">#HtmlEditFormat( args.page.getTitle() )#</h1>
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

	<footer class="footer">
		<div class="container">
			<p>The Lucee Documentation is developed and maintained by the Lucee Association Switzerland and is licensed under a
				<a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/3.0/"><img alt="Creative Commons License" style="border-width:0" src="//i.creativecommons.org/l/by-nc-sa/3.0/80x15.png"></a>
				<a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/3.0/">Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License</a>.
			</p>
		</div>
	</footer>

	</body>
</html></cfoutput>
