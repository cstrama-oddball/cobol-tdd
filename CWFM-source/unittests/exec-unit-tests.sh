
export CWFM_source_pull=CWFM_Source_Code/
cd ..

if [ -d $CWFM_source_pull ] 
then
    # don't need to clone the CWFM source code project
	echo "CWFM source code repo is cloned"
else
    echo "Need to clone the source code project"

# git clone the CWFM source repo

fi

# git pull the latest version of the source
# git pull

######################
# EXEC UNIT TESTS
cd unittests

# list of unit test script files to be exected in order
./test-rrbtossa.sh
