@echo off
echo FILESTAT test start
rem get to the proper directory that has source code
cd ..

rem set the CWF source directory to reference the latest MF code
set CWFM-source-dir=CWF\EPROD\SATL\SORC

rem clear out the source file to be tested and get the latest
del FILESTAT.cbl /Q /F
copy %CWFM-source-dir%\FILESTAT.TXT FILESTAT.cbl /Y

rem compile the relevant files needed for the test
call cobol-compile.bat FILESTAT.cbl FILESTAT -m
call cobol-compile.bat FILESTAT-Launch.cob FILESTAT-Launch -x

rem get to the proper directory that has the binary files
cd load

rem clear out the output file to be asserted
del file-status-out.txt /Q /F

rem set the environment variable for file access
set FSFILE=file-status-test.tst

rem execute the test
FILESTAT-Launch > file-status-out.txt
python3 FILESTAT-Check.py

rem get back to the original directory and transfer control back to calling bat file
cd ..\unittests

echo FILESTAT test complete