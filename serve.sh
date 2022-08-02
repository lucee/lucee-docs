#!/bin/bash

cd `dirname $0`
CWD="`pwd`"

# add redis extension
export LUCEE_EXTENSIONS="60772C12-F179-D555-8E2CD2B4F7428718;version=3.0.0.44-RC"

box start name=luceedocslocalserver directory=$CWD/server/ force=true rewritesEnable=true rewritesConfig=$CWD/server/urlrewrite.xml port=4040 trayIcon=$CWD/luceelogoicon.png heapSize=1024 cfengine="lucee@5"
