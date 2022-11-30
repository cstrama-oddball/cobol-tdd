
export CWFM_source_pull=CWF/
GIT_CREDS=`cat git-creds.txt`

cd ..
pwd

if [ -d $CWFM_source_pull ] 
then
    # don't need to clone the CWFM source code project
	echo "CWFM source code repo is cloned"
else
    echo "Need to clone the source code project"

    git clone https://$GIT_CREDS@github.cms.gov/common-working-file-modernization/CWF.git

fi

cd $CWFM_source_pull
pwd

# git pull the latest version of the source
git pull

######################
# EXEC UNIT TESTS
cd ../unittests
pwd

# list of unit test script files to be exected in order
./test-rrbtossa.sh
