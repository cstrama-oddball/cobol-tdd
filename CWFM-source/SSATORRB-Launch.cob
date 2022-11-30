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