set CWD=%cd%

# add redis extension
set LUCEE_EXTENSIONS="60772C12-F179-D555-8E2CD2B4F7428718;version=3.0.0.44-RC"

box stop name=luceedocslocalserver
box start name=luceedocslocalserver directory=%CWD%/server/ force=true rewritesEnable=true rewritesConfig=%CWD%/server/urlrewrite.xml port=4040 trayIcon=%CWD%/luceelogoicon.png heapSize=2048 cfengine="lucee@5"
