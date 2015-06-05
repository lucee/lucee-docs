#!/bin/bash

cd `dirname $0`
CWD="`pwd`"
echo "Building documentation with Lucee :)"
box $CWD/build.cfm
echo "Building complete"
if [[ $TRAVIS_BRANCH == 'master' ]] ; then
  echo "Zipping up docs for offline download..."
  cd builds/html
  zip -q -r lucee-docs.zip *
  cd ../../
  echo "Zipped."
  echo "Preparing dash artifacts..."
  cp -r builds/html builds/artifacts
  mkdir builds/artifacts/dash
  cp builds/dash/lucee.xml builds/artifacts/dash/
  cd builds/dash
  tar -cvzf ../../builds/artifacts/dash/lucee.tgz lucee.docset
  cd ../../
  echo "Prepared."
  echo "Syncing with S3..."
  s3_website push
  echo "All done :)"
fi