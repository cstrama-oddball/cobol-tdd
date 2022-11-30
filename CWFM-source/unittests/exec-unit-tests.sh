# set the directory that has the MF source code
export CWFM_source_pull=CWF/

# set the git credentials
GIT_CREDS=`cat git-creds.txt`

# get to the proper directory
cd ..
pwd

# check if the MF source code repo has been cloned
if [ -d $CWFM_source_pull ] 
then
    # don't need to clone the CWFM source code project
	echo "CWFM source code repo is cloned"
else
    echo "Need to clone the source code project"

    # clone the repo for the MF source code
    git clone https://$GIT_CREDS@github.cms.gov/common-working-file-modernization/CWF.git

fi

# get to the proper directory to pull the MF source code repo
cd $CWFM_source_pull
pwd

# git pull the latest version of the source
git pull

######################
# EXEC UNIT TESTS
cd ../unittests
pwd

# list of unit test script files to be exected in order
source ./test-rrbtossa.sh
