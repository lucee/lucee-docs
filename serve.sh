#!/bin/bash

CWD="$(dirname $(readlink -f $0))"
box start name=luceedocslocalserver directory=$CWD/server/ force=true rewritesEnable=true rewritesConfig=$CWD/server/urlrewrite.xml port=4040 trayIcon=$CWD/luceelogoicon.png