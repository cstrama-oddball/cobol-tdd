@echo off
cd ..
call cobol-compile.bat RRBTOSSA.cbl RRBTOSSA -m
call cobol-compile.bat RRBTOSSA-Launch.cbl RRBTOSSA-Launch -x
cd load
set RRBFILE=rrb-test.tst

RRBTOSSA-Launch

cd ..\unittests