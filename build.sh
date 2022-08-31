#!/bin/bash

cd `dirname $0`
CWD="`pwd`"

# add redis extension
export LUCEE_EXTENSIONS="60772C12-F179-D555-8E2CD2B4F7428718"

echo "Starting Lucee server with which to build the docs..."
box server stop luceedocsbuilder
box start \
name="luceedocsbuilder" \
cfengine="lucee@5" \
port=8765 \
openbrowser=false \
directory=$CWD \
javaVersion=openjdk8_jre_jdk8u332-b09 \
heapSize=2048;

echo "Local Lucee Server Started!";
echo "Importing reference docs from previously undocumented functions and tags..."
# curl --no-progress-meter http://localhost:8765/import.cfm?textlogs=true
curl http://localhost:8765/import.cfm?textlogs=true

echo "Building documentation (please be patient, it may take some time)..."
#curl --no-progress-meter http://localhost:8765/build.cfm?textlogs=true
curl http://localhost:8765/build.cfm?textlogs=true

echo "Stopping Lucee5 server..."
box server stop luceedocsbuilder

if [ -f .exitcode ]; then
  exitcode=$(<.exitcode)
  rm -f .exitcode
  echo "Exiting build, documentation build failed. Exit code: $exitcode"
  exit $exitcode
fi


echo "Building complete"

if [ "$DOCS_BRANCH" = "refs/heads/master" ] && [ "$DOCS_EVENT" = "push" ] ; then
  echo "Zipping up docs for offline download..."
  cd builds/html
  cp ../../.cloudfront-distribution-id ./
  zip -q -r lucee-docs.zip *
  cd ../../
  echo "Zipped."
  echo "Prepared for s3 upload."
  # this is now done in a github action step
  #echo "Syncing with S3..."
  #s3_website push
  #echo "All done :)"
fi

#echo "Ping search engines with sitemaps"
#curl https://google.com/ping?sitemap=https://docs.lucee.org/sitemap.xml
