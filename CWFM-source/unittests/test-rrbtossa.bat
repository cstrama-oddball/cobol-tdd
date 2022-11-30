@echo off
cd ..
set CWFM-source-dir=CWFM_Source_Code
copy %CWFM-source-dir%\RRBTOSSA.cbl RRBTOSSA.cbl /Y

call cobol-compile.bat RRBTOSSA.cbl RRBTOSSA -m
call cobol-compile.bat RRBTOSSA-Launch.tcbl RRBTOSSA-Launch -x
cd load
set RRBFILE=rrb-test.tst

RRBTOSSA-Launch

cd ..\unittests

echo RRBTOSSA test complete