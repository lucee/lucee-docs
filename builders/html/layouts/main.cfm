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

		<script src="assets/js/base.min.js" type="text/javascript"></script>
	</body>
</html></cfoutput>