@echo off
set CWFM-source-pull=load\
cd ..
if exist %CWFM-source-pull% (
    goto pull_source
)

rem git clone the CWFM source repo

:pull_source

cd %CWFM-source-pull%

rem git pull the latest version of the source
rem git pull

:exec_tests

cd ..\unittests

rem list of unit test script files to be exected in order
call test-rrbtossa.bat
