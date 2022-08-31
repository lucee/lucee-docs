set CWD=%cd%

echo Starting Lucee5 server with which to build the docs...
box server stop luceedocsbuilder
box start ^
name="luceedocsbuilder" ^
cfengine="lucee@5" ^
port=8765 ^
openbrowser=false ^
directory=%CWD% ^
javaVersion=openjdk8_jre_jdk8u332-b09 ^
heapSize=2048

echo Done!
echo Importing reference docs from previously undocumented functions and tags...
curl http://localhost:8765/import.cfm?textlogs=true

echo Building documentation (please be patient, it may take some time)...

curl http://localhost:8765/build.cfm?textlogs=true

echo "Stopping Lucee5 server..."
box server stop luceedocsbuilder
@echo off
IF EXIST .exitcode (
  set /p exitcode=<.exitcode
  del .exitcode
  echo Exiting build, documentation build failed with exitcode %exitcode%
  exit /b %exitcode%
)
echo on

echo Exporting docs TBD for Windows batch file
exit /b

echo Building complete


if [ "$TRAVIS_BRANCH" = "master" ] && [ "$TRAVIS_PULL_REQUEST" = "false" ] ; then
  echo "Zipping up docs for offline download..."
  cd builds/html
  cp ../../.cloudfront-distribution-id ./
  zip -q -r lucee-docs.zip *
  cd ../../
  echo "Zipped."
  echo "Syncing with S3..."
  s3_website push
  echo "All done :)"
fi
