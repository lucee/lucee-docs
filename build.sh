#!/bin/bash

cd `dirname $0`
CWD="`pwd`"

echo "Starting Lucee5 server with which to build the docs..."
box server stop luceedocsbuilder
box start \
name="luceedocsbuilder" \
cfengine="lucee@5" \
port=8765 \
openbrowser=false \
directory=$CWD \
javaVersion=openjdk8_jre_jdk8u262-b10 \
heapSize=1024;

echo "Done!";
echo "Importing reference docs from previously undocumented functions and tags..."
curl --no-progress-meter http://localhost:8765/import.cfm?textlogs=true

echo "Building documentation (please be patient, it may take some time)..."

curl --no-progress-meter http://localhost:8765/build.cfm?textlogs=true

echo "Stopping Lucee5 server..."
box server stop luceedocsbuilder

if [ -f .exitcode ]; then
  exitcode=$(<.exitcode)
  rm -f .exitcode
  echo "Exiting build, documentation build failed. Exit code: $exitcode"
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

echo "Ping search engines with sitemaps"

curl https://google.com/ping?sitemap=https://docs.lucee.org/sitemap.xml


