#!/bin/bash

cd `dirname $0`
CWD="`pwd`"
echo "Building documentation with Lucee :)"
box $CWD/build.cfm
echo "Building complete"
if [[ $TRAVIS_BRANCH == 'master' ]] ; then
  echo "Zipping up docs for offline download..."
  cd builds/html
  zip -r lucee-docs.zip *
  cd ../../
  cp -r builds/html builds/artefacts
  echo "Preparing dash artifacts..."
  mkdir builds/artefacts/dash
  cp builds/dash/lucee.xml builds/artefacts/dash/
  cd builds/dash
  tar -cvzf ../../builds/artefacts/dash/lucee.tgz lucee.docset
  cd ../../
  echo "Syncing with S3..."
  s3_website push
  echo "All done :)"
fi