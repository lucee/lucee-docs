set CWD=%cd%
box stop name=luceedocslocalserver
box start name=luceedocslocalserver directory=%CWD%/server/ force=true rewritesEnable=true rewritesConfig=%CWD%/server/urlrewrite.xml port=4040 trayIcon=%CWD%/luceelogoicon.png heapSize=2048 cfengine="http://update.lucee.org/rest/update/provider/forgebox/5.3.4.80"
