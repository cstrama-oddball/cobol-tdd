# Create Unit Test

- In the CWFM-source folder, create a COBOL program to call the module that will be tested. The naming convention is **[module to be tested]-Launch.cob**<br> Below is an example:<br>
```
       ID DIVISION. 
       PROGRAM-ID. SSATORRB-LAUNCH.

       ENVIRONMENT DIVISION. 

       INPUT-OUTPUT SECTION.

       FILE-CONTROL.  

           SELECT INPUTFILE       ASSIGN TO RRBFILE
                                  FILE STATUS IS FILE-STATUS
                                  ORGANIZATION LINE SEQUENTIAL.

       DATA DIVISION.

       FILE SECTION. 

       FD INPUTFILE 
           RECORD CONTAINS 24 CHARACTERS.

       01  RRB-REC.
           02 RRB-CONVERT-ASSERT  PIC X(12).
           02 SSA-NUMBER          PIC X(12).

       WORKING-STORAGE SECTION. 

       01 FILE-STATUS PIC X(2).

       01 NO-MORE-RECORDS PIC X(1) VALUE 'N'.

       01  SSATORRB-PARAMETERS.
           05  SP-INTERNAL-HIC         PIC  X(11).
           05  SP-EXTERNAL-HIC         PIC  X(12).

       PROCEDURE DIVISION.

      *  arrange
           OPEN INPUT INPUTFILE.

           PERFORM UNTIL NO-MORE-RECORDS = 'Y'

              READ INPUTFILE 
                 AT END MOVE 'Y' TO NO-MORE-RECORDS
              END-READ

              IF NO-MORE-RECORDS = 'N'
                    MOVE SSA-NUMBER TO SP-INTERNAL-HIC
         
      *   act
                    CALL 'SSATORRB' USING SSATORRB-PARAMETERS
         
      *   assert
                    IF SP-EXTERNAL-HIC NOT = RRB-CONVERT-ASSERT
                       DISPLAY SP-INTERNAL-HIC " converted to " 
                          SP-EXTERNAL-HIC
                    END-IF 
              END-IF 

           END-PERFORM.

           CLOSE INPUTFILE.

           STOP RUN.
```
- Ensure that you have included any WORKING-STORAGE members that will be passed as parameters in the LINKAGE SECTION of the module to be tested.
- Since this is code, you can reference and read any configuration and test data files to be used in the test
- Next, create a script file to pull the CWF module to be tested into the testing folder, compile the launcher and the module, and execute the launcher to run the test.<br>Below is an exmaple for Linux Bash:<br>
```
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
```
- Add your new script file to the bottom of the **exec-unit-tests** script (depending on the OS). <br>Below is an example for Linux Bash:<br>
```
# list of unit test script files to be exected in order
source ./test-rrbtossa.sh
source ./test-ssatorrb.sh
[add your new script to the list]
```
- Your new script will be part of the main suite of unit tests