set CWD=%cd%
box stop name=luceedocslocalserver
box start name=luceedocslocalserver directory=%CWD%/server/ force=true rewritesEnable=true rewritesConfig=%CWD%/server/urlrewrite.xml port=4040 trayIcon=%CWD%/luceelogoicon.png heapSize=2048 cfengine="lucee@5.3.8-SNAPSHOT+154"
