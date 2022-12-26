@echo off
echo RRBTOSSA test start
rem get to the proper directory that has source code
cd ..

rem set the CWF source directory to reference the latest MF code
set CWFM-source-dir=CWF\EPROD\SATL\SORC

rem get the latest file to be tested
copy %CWFM-source-dir%\RRBTOSSA.TXT RRBTOSSA.cbl /Y

rem compile the relevant files needed for the test
call cobol-compile.bat RRBTOSSA.cbl RRBTOSSA -m
call cobol-compile.bat RRBTOSSA-Launch.cob RRBTOSSA-Launch -x

rem clear out the source file to be tested
del RRBTOSSA.cbl /Q /F

rem get to the proper directory that has the binary files
cd load

rem set the environment variable for file access
set RRBFILE=rrb-test.tst

rem execute the test
RRBTOSSA-Launch

rem get back to the original directory and transfer control back to calling bat file
cd ..\unittests

echo RRBTOSSA test complete