echo RRBTOSSA test start
cd ..
export CWFM_source_dir=CWF/EPROD/SATL/SORC
cp $CWFM_source_dir/RRBTOSSA.TXT RRBTOSSA.cbl
./cobol-compile.sh RRBTOSSA.cbl RRBTOSSA -m
./cobol-compile.sh RRBTOSSA-Launch.tcbl RRBTOSSA-Launch -x
cd load
export RRBFILE=rrb-test.tst
./RRBTOSSA-Launch
cd ../unittests
echo RRBTOSSA test complete
