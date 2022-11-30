echo RRBTOSSA test start
#get to the proper directory
cd ..

# set the path to the MF source code
export CWFM_source_dir=CWF/EPROD/SATL/SORC

# copy the latest version of the source code for testing
cp $CWFM_source_dir/RRBTOSSA.TXT RRBTOSSA.cbl

# compile the code for testing
./cobol-compile.sh RRBTOSSA.cbl RRBTOSSA -m
./cobol-compile.sh RRBTOSSA-Launch.tcbl RRBTOSSA-Launch -x

# get to the proper directory that has the binary files
cd load

# set the environment variable to file access
export RRBFILE=rrb-test.tst

# execute the test
./RRBTOSSA-Launch

# get back to the unit test directory and return control
cd ../unittests

echo RRBTOSSA test complete
