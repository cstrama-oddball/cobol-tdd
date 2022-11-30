echo SSATORRB test start
#get to the proper directory
cd ..

# set the path to the MF source code
export CWFM_source_dir=CWF/EPROD/SATL/SORC

# copy the latest version of the source code for testing
cp $CWFM_source_dir/SSATORRB.TXT SSATORRB.cbl

# compile the code for testing
./cobol-compile.sh SSATORRB.cbl SSATORRB -m
./cobol-compile.sh SSATORRB-Launch.cob SSATORRB-Launch -x

# get to the proper directory that has the binary files
cd load

# set the environment variable to file access
export RRBFILE=rrb-ssa-test.tst

# execute the test
./SSATORRB-Launch

# get back to the unit test directory and return control
cd ../unittests

echo SSATORRB test complete
