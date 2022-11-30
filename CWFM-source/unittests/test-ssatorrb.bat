@echo off
echo SSATORRB test start
rem get to the proper directory that has source code
cd ..

rem set the CWF source directory to reference the latest MF code
set CWFM-source-dir=CWF\EPROD\SATL\SORC

rem clear out the source file to be tested and get the latest
del SSATORRB.cbl /Q /F
copy %CWFM-source-dir%\SSATORRB.TXT SSATORRB.cbl /Y

rem compile the relevant files needed for the test
call cobol-compile.bat SSATORRB.cbl SSATORRB -m
call cobol-compile.bat SSATORRB-Launch.cob SSATORRB-Launch -x

rem get to the proper directory that has the binary files
cd load

rem set the environment variable for file access
set RRBFILE=rrb-ssa-test.tst

rem execute the test
SSATORRB-Launch

rem get back to the original directory and transfer control back to calling bat file
cd ..\unittests

echo SSATORRB test complete