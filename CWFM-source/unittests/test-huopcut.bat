@echo off
echo HUOPCUT test start
rem get to the proper directory that has source code
cd ..

rem set the CWF source directory to reference the latest MF code
set CWFM-source-dir=CWF\EPROD\SATL\SORC

rem clear out the source file to be tested and get the latest
del HUOPCUT.cbl /Q /F
copy %CWFM-source-dir%\HUOPCUT.TXT HUOPCUT.cbl /Y

rem compile the relevant files needed for the test
call cobol-compile.bat HUOPCUT.cbl HUOPCUT -m
call cobol-compile.bat HUOPCUT-Launch.cob HUOPCUT-Launch -x

rem get to the proper directory that has the binary files
cd load

rem set the environment variable for file access
set RRBFILE=rrb-ssa-test.tst

rem execute the test
HUOPCUT-Launch

rem get back to the original directory and transfer control back to calling bat file
cd ..\unittests

echo HUOPCUT test complete