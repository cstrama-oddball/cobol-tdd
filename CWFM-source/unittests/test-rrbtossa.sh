cd ..
export CWFM_source_dir=CWFM_Source_Code
cp $CWFM_source_dir/RRBTOSSA.cbl RRBTOSSA.cbl
./cobol-compile.sh RRBTOSSA.cbl RRBTOSSA -m
./cobol-compile.sh RRBTOSSA-Launch.tcbl RRBTOSSA-Launch -x
cd load
export RRBFILE=rrb-test.tst
./RRBTOSSA-Launch
cd ../unittests
echo RRBTOSSA test complete
