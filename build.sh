#!/bin/bash

cd `dirname $0`
CWD="`pwd`"

echo "Importing reference docs from previously undocumented functions and tags..."
box $CWD/import.cfm

echo "Building documentation..."

box $CWD/build.cfm
if [ -f .exitcode ]; then
  exitcode=$(<.exitcode)
  rm -f .exitcode
  echo "Exiting build, documentation build failed."
  exit $exitcode
fi

echo "Building complete"

if [ "$TRAVIS_BRANCH" = "master" ] && [ "$TRAVIS_PULL_REQUEST" = "false" ] ; then
  echo "Zipping up docs for offline download..."
  cd builds/html
  cp ../../.cloudfront-distribution-id ./
  zip -q -r lucee-docs.zip *
  cd ../../
  echo "Zipped."
  echo "Preparing dash artifacts..."
  cp -r builds/html builds/artifacts
  mkdir builds/artifacts/dash
  cp builds/dash/lucee.xml builds/artifacts/dash/
  cd builds/dash
  tar -czf ../../builds/artifacts/dash/lucee.tgz lucee.docset
  cd ../../
  echo "Prepared."
  echo "Syncing with S3..."
  s3_website push
  echo "All done :)"
fi
