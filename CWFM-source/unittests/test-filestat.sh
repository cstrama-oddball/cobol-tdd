echo FILESTAT test start
#get to the proper directory
cd ..

# set the path to the MF source code
export CWFM_source_dir=CWF/EPROD/SATL/SORC

# copy the latest version of the source code for testing
cp $CWFM_source_dir/FILESTAT.TXT FILESTAT.cbl

# compile the code for testing
./cobol-compile.sh FILESTAT.cbl FILESTAT -m
./cobol-compile.sh FILESTAT-Launch.cob FILESTAT-Launch -x

# get to the proper directory that has the binary files
cd load

# set the environment variable to file access
export FSFILE=file-status-test.tst

# execute the test
./FILESTAT-Launch > file-status-out.TXT
python3 FILESTAT-Check.py

# get back to the unit test directory and return control
cd ../unittests

echo FILESTAT test complete
