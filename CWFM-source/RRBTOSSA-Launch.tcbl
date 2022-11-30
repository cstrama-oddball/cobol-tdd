       ID DIVISION. 
       PROGRAM-ID. RRBTOSSA-LAUNCH.

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
           02 RRB-NUMBER  PIC X(12).
           02 RRB-CONVERT-ASSERT PIC X(12).

       WORKING-STORAGE SECTION. 

       01 FILE-STATUS PIC X(2).

       01 NO-MORE-RECORDS PIC X(1) VALUE 'N'.

       01  RRBTOSSA-PARAMETERS.
           05  RP-RRB-HIC              PIC  X(12).
           05  RP-SSA-HIC              PIC  X(11).

       PROCEDURE DIVISION.

           OPEN INPUT INPUTFILE.

           PERFORM UNTIL NO-MORE-RECORDS = 'Y'

              READ INPUTFILE 
                 AT END MOVE 'Y' TO NO-MORE-RECORDS
              END-READ

              IF NO-MORE-RECORDS = 'N'
                    MOVE RRB-NUMBER TO RP-RRB-HIC
         
                    CALL 'RRBTOSSA' USING RRBTOSSA-PARAMETERS
         
                    IF RP-SSA-HIC NOT = RRB-CONVERT-ASSERT
                       DISPLAY RP-RRB-HIC " converted to " RP-SSA-HIC
                    END-IF 
              END-IF 

           END-PERFORM.

           CLOSE INPUTFILE.

           STOP RUN.