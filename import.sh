#!/bin/bash

CWD="$(dirname $(readlink -f $0))"
box $CWD/import.cfm
