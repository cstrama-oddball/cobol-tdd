@echo off
export CWFM_source_pull=load\
cd ..

if [ -d $CWFM_source_pull ] 
then
    echo "Directory /path/to/dir exists." 
else
    echo "Error: Directory /path/to/dir does not exists."

# git clone the CWFM source repo

fi



cd $CWFM_source_pull

# git pull the latest version of the source
# git pull


cd ../unittests

# list of unit test script files to be exected in order
./test-rrbtossa.sh