<cfscript>
	local.baseHref = ( repeatString( '../', args.page.getDepth()-1 ) );
	// this breaks the /static/ local server mode
	//if (baseHref eq "")
	//	baseHref = "/";
	local.path = args.page.getPath();
	if ( local.path eq "/home" )
		local.path = "/index";
	local.pageHref = "https://docs.lucee.org#local.path#.html";
	local.pagePath = "#local.path#.html";
	local.pagePathMd = "#local.path#.md";
	if (args.page.getTitle() neq "Lucee Documentation")
		local.pageTitle = args.page.getTitle() & " :: Lucee Documentation";
	else
		local.pageTitle = args.page.getTitle();
	// many sites (slack, discord one box etc) can't handle the escaped <cfcontent> and strip out the tag name from previews
	local.safePageTitle = EncodeForHtml( Replace( Replace( local.pageTitle, "<", "", "all" ), ">", "", "all" ) );
	local.pageTitle = EncodeForHtml( local.pageTitle );
	local.pageDescription = getMetaDescription( args.page, args.body );
</cfscript>

<cfoutput>
	<head>
		<title>#local.pageTitle#</title>
		<cfif !structKeyExists(args.htmlOpts, "no_google_analytics")>
			<script async src="https://www.googletagmanager.com/gtag/js?id=UA-116664465-1"></script>
			<script>
				window._gaTrackingID = 'UA-116664465-1';
				window.dataLayer = window.dataLayer || [];
				function gtag(){dataLayer.push(arguments);}
				gtag('js', new Date());
				gtag('config', window._gaTrackingID);
			</script>
		</cfif>
		<cfif args.edit>
			<base href="#local.baseHref#">
		</cfif>
		<link rel="canonical" href="#local.pageHref#">
		<link rel="alternate" type="text/markdown" href="#local.pagePathMd#">
		<meta name="robots" content="index, follow">
		<meta content="#getMetaDescription( args.page, args.body )#" name="description">
		<meta content="initial-scale=1.0, width=device-width" name="viewport">
		<meta name="twitter:card" content="summary">
		<meta name="twitter:site" content="@lucee_server">
		<meta name="twitter:title" content="#local.safePageTitle#">
		<meta name="twitter:description" content="#local.pageDescription#">
		<meta name="twitter:image" content="https://docs.lucee.org/assets/images/favicon.png">
		<meta name="twitter:image:alt" content="Lucee">
		<meta property="og:title" content="#local.safePageTitle#">
		<meta property="og:url" content="#local.pageHref#">
		<meta property="og:type" content="article">
		<meta property="og:image" content="https://docs.lucee.org/assets/images/favicon.png">
		<meta property="og:image:alt" content="Lucee">
		<cfif !structKeyExists(local.args.htmlOpts, "no_css")>
			<cfif args.edit>
				<link href="/assets/css/base.css" rel="stylesheet">
			<cfelse>
				<link href="/assets/css/base.#application.assetBundleVersion#.min.css" rel="stylesheet">
			</cfif>
			<link href="/assets/css/highlight.css" rel="stylesheet" class="highlight-theme-light">
			<link href="/assets/css/highlight-dark.css" rel="stylesheet" class="highlight-theme-dark">
		</cfif>
		<link rel="icon" type="image/png" href="https://docs.lucee.org/assets/images/favicon.png">
	</head>
</cfoutput>
