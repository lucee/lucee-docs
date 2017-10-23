<cfscript>
  styles = '
			<?xml version="1.0" encoding="UTF-8"?>
			<html xsl:version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
				<body style="font-family:Arial;font-size:12pt;background-color:##EEEEEE">
				<xsl:for-each select="notes/note">
					<div style="margin-bottom: 2.0em">
						<div style="background-color:teal;color:white;padding:4px">
							<div style="margin-bottom:1em;font-size: 1.2em; font-style: italic">
								<xsl:value-of select="heading"/>
							</div>
							<div style="font-size: 0.8em">
								From: <xsl:value-of select="from"/>
							</div>
							<div style="font-size: 0.8em">
								To: <xsl:value-of select="to"/>
							</div>
						</div>
						<div style="margin-top:1em;font-size: 0.9em">
							<xsl:value-of select="body"/>
						</div>
					</div>
				</xsl:for-each>
				</body>
			</html>
		';

		xml_stream = '
			<?xml version="1.0" encoding="UTF-8"?>
			<notes>
				<note>
					<to>Alice</to>
					<from>Bob</from>
					<heading>Reminder</heading>
					<body>Here is the message you requested.</body>
				</note>
				<note>
					<to>Bob</to>
					<from>Alice</from>
					<heading>Your request</heading>
					<body>I got your message; all is well.</body>
				</note>
			</notes>';

		xml_document = XmlParse(xml_stream);

		echo(xmlTransform(xml_document,styles));
</cfscript>
