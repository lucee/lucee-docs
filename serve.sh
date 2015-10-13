#!/bin/bash

cd `dirname $0`
CWD="`pwd`"

box start name=luceedocslocalserver heapSize=102 directory=$CWD/server/ force=true rewritesEnable=true rewritesConfig=$CWD/server/urlrewrite.xml port=4040 trayIcon=$CWD/luceelogoicon.png
