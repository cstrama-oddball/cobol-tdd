@echo off

rem set the CWF source directory that has MF code
set CWFM-source-pull=CWF\

rem set the git credentials from the file
rem create a file called git-creds.txt in the same directory
rem  as this script file
rem put the credentials in as <usernme>:<access token>
FOR /F %%i IN (git-creds.txt) DO set GIT_CREDS=%%i

rem get to the proper directory
cd ..
echo %CD%

rem check for cloned MF source code repo
if exist %CWFM-source-pull% (
    rem the repo is cloned, move on to next step
    goto pull_source
)

rem clone the repo if it has never been cloned before
git clone https://%GIT_CREDS%@github.cms.gov/common-working-file-modernization/CWF.git

:pull_source

rem get to the proper directory that has the MF code repo
cd %CWFM-source-pull%
echo %CD%

rem ###
rem # git pull the latest version of the source
git pull

:exec_tests

rem get to the proper directory to run the unit tests
cd ..\unittests
echo %CD%

rem list of unit test script files to be exected in order
call test-rrbtossa.bat
call test-ssatorrb.bat
