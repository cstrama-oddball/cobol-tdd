@echo off
echo RRBTOSSA test start
cd ..
set CWFM-source-dir=CWF\EPROD\SATL\SORC
copy %CWFM-source-dir%\RRBTOSSA.TXT RRBTOSSA.cbl /Y

call cobol-compile.bat RRBTOSSA.cbl RRBTOSSA -m
call cobol-compile.bat RRBTOSSA-Launch.tcbl RRBTOSSA-Launch -x
cd load
set RRBFILE=rrb-test.tst

RRBTOSSA-Launch

cd ..\unittests

echo RRBTOSSA test complete