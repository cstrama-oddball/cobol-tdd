cd ..
./cobol-compile.sh RRBTOSSA.cbl RRBTOSSA -m
./cobol-compile.sh RRBTOSSA-Launch.cbl RRBTOSSA-Launch -x
cd load
./RRBTOSSA-Launch
