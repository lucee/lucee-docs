<cfparam name="args.body"  type="string" />
<cfparam name="args.title" type="string" />
<cfparam name="args.base"  type="string" default="./" />

<cfoutput><!DOCTYPE html>
<html>
	<head>
		<title>#args.title#</title>
		<base href="#args.base#">

		<link rel="stylesheet" href="assets/css/responsive.grid.css">
		<link rel="stylesheet" href="assets/css/animate.min.css">
		<link rel="stylesheet" href="assets/css/theme.min.css">
		<link rel="stylesheet" href="http://fonts.googleapis.com/css?family=Source+Sans+Pro:400,700,400italic&subset=latin-ext">
		<link href="//netdna.bootstrapcdn.com/font-awesome/4.0.3/css/font-awesome.css" rel="stylesheet">
	</head>
	<body>
		<div class="container azul">
			<div class="single row gutters">
				#args.body#
			</div>
		</div>
	</body>
</html></cfoutput>