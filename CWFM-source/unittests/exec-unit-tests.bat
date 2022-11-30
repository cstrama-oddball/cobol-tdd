@echo off
set CWFM-source-pull=CWF\
FOR /F %%i IN (git-creds.txt) DO set GIT_CREDS=%%i
cd ..
if exist %CWFM-source-pull% (
    goto pull_source
)

git clone https://%GIT_CREDS%@github.cms.gov/common-working-file-modernization/CWF.git

:pull_source

cd %CWFM-source-pull%

rem ###
rem # git pull the latest version of the source
git pull

:exec_tests

cd ..\unittests

rem list of unit test script files to be exected in order
call test-rrbtossa.bat
