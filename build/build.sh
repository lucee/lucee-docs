#!/bin/bash

CWD="$(dirname $(readlink -f $0))"
box execute $CWD/build.cfm