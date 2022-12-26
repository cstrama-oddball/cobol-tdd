       ID DIVISION. 
       PROGRAM-ID. FILESTAT-LAUNCH.

       ENVIRONMENT DIVISION. 

       INPUT-OUTPUT SECTION.

       FILE-CONTROL.  

           SELECT INPUTFILE       ASSIGN TO FSFILE
                                  FILE STATUS IS FILE-STATUS
                                  ORGANIZATION LINE SEQUENTIAL.

       DATA DIVISION.

       FILE SECTION. 

       FD INPUTFILE 
           RECORD CONTAINS 50 CHARACTERS.

       01  FILE-STATUS-REC.
           02 FILE-STATUS-NUMBER  PIC X(2).
           02 FILE-STATUS-MSG     PIC X(48).

       01  FILE-ASSERT-REC.
           02 ASSERT-PREFIX       PIC X(22).
           02 ASSERT-CODE         PIC X(2).
           02 ASSERT-MESSAGE      PIC X(48).

       WORKING-STORAGE SECTION. 

       01 FILE-STATUS    PIC X(2).

       01 NO-MORE-RECORDS PIC X(1) VALUE 'N'.

       01  FILESTAT-PARAMETERS.
           05  FILE-STATUS-CODE         PIC  X(2).

       PROCEDURE DIVISION.

           OPEN INPUT INPUTFILE.

           PERFORM UNTIL NO-MORE-RECORDS = 'Y'

              READ INPUTFILE 
                 AT END MOVE 'Y' TO NO-MORE-RECORDS
              END-READ

              IF NO-MORE-RECORDS = 'N'
                    MOVE FILE-STATUS-NUMBER TO FILE-STATUS-CODE
         
                    CALL 'FILESTAT' USING FILESTAT-PARAMETERS
              END-IF 

           END-PERFORM.

           CLOSE INPUTFILE.

           STOP RUN.