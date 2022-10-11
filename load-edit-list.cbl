       IDENTIFICATION DIVISION.
       PROGRAM-ID. LOAD-EDIT-LIST.
      
       ENVIRONMENT DIVISION. 
       INPUT-OUTPUT SECTION. 
       FILE-CONTROL.
           SELECT INPUT-FILE  ASSIGN TO INPUT-FILE-NAME
                  ORGANIZATION  IS LINE SEQUENTIAL
                  ACCESS MODE   IS SEQUENTIAL
                  FILE STATUS   IS FILE-IN-STATUS.

       DATA DIVISION.
       FILE SECTION.

       FD INPUT-FILE
           DATA RECORD IS FILE-IN-RECORD.

       01 FILE-IN-RECORD.
           05 FILE-IN-RECORD-IS-USED PIC X(1).
           05 FILE-IN-RECORD-VALUE PIC X(4).
           05 FILE-IN-RECORD-CR-NUM PIC X(6).

       WORKING-STORAGE SECTION. 
         01 LIST-COUNT   PIC 9(4) VALUE 0.

         01 FILE-IN-STATUS PIC 9(2).

         01 FILE-IN-VALUE PIC 9(4).

         01 DONE-FLAG PIC X(1).

      * CONSTANTS
         01 FILE-STATUS-OK PIC 9(2) VALUE 00.
         01 FILE-STATUS-EOF PIC 9(2) VALUE 01.
         01 FILE-IGNORE-RECORD-FLAG PIC X(1) VALUE '*'.
         01 FILE-ADVANCE-RECORD-COUNT PIC 9(1) VALUE 1.
         01 ALL-DONE PIC X(1) VALUE 'Y'.
         01 NOT-DONE PIC X(1) VALUE 'N'.

       LINKAGE SECTION.
         01 INPUT-FILE-NAME   PIC X(12).

         01 LIST-LENGTH  PIC 9(4).
       
         01 LIST-RECORD.
            05 LIST-ITEMS OCCURS 0 TO 1024 TIMES 
                DEPENDING ON LIST-LENGTH.
              10 LIST-VALUE PIC X(4).
      
      * By Ref variables
      * LIST-RECORD is the list that is filled and passed back
      * LIST-LENGTH is the length of LIST-RECORD after it is filled
      *   and passed back
      * INPUT-FILE-NAME is passed in and is the file that contains
      *   the values to load the list

       PROCEDURE DIVISION USING LIST-RECORD, LIST-LENGTH 
                              , INPUT-FILE-NAME.
           MOVE NOT-DONE TO DONE-FLAG.
           PERFORM 000-INITIALIZE.
           PERFORM 001-OPEN-INPUT-FILE.
           PERFORM 003-PROCESS-RECORDS.
           PERFORM 002-CLOSE-INPUT-FILE.
           MOVE ALL-DONE TO DONE-FLAG.

           EXIT PROGRAM.

       000-INITIALIZE.
           IF DONE-FLAG = ALL-DONE
              EXIT PARAGRAPH 
           END-IF.

           MOVE FILE-STATUS-OK TO FILE-IN-STATUS.

           EXIT PARAGRAPH.

       001-OPEN-INPUT-FILE.
           IF DONE-FLAG = ALL-DONE
              EXIT PARAGRAPH 
           END-IF.

           OPEN INPUT INPUT-FILE.

           EXIT PARAGRAPH.

       002-CLOSE-INPUT-FILE.
           IF DONE-FLAG = ALL-DONE
              EXIT PARAGRAPH 
           END-IF.

           CLOSE INPUT-FILE.

           EXIT PARAGRAPH.

       003-PROCESS-RECORDS.
           IF DONE-FLAG = ALL-DONE
              EXIT PARAGRAPH 
           END-IF.

           PERFORM UNTIL FILE-IN-STATUS NOT = FILE-STATUS-OK
              PERFORM 004-READ-RECORD
              IF FILE-IN-STATUS = FILE-STATUS-OK
                 PERFORM 005-LOAD-RECORD
              END-IF
           END-PERFORM.

           EXIT PARAGRAPH.

       004-READ-RECORD.
           IF DONE-FLAG = ALL-DONE
              EXIT PARAGRAPH 
           END-IF.
           MOVE SPACES TO FILE-IN-RECORD.
           READ INPUT-FILE
              AT END MOVE FILE-STATUS-EOF TO FILE-IN-STATUS.

           EXIT PARAGRAPH.

       005-LOAD-RECORD.
           IF DONE-FLAG = ALL-DONE
              EXIT PARAGRAPH 
           END-IF.
           
           IF FILE-IN-RECORD-IS-USED NOT = FILE-IGNORE-RECORD-FLAG
               AND FILE-IN-RECORD NOT = SPACES
                ADD FILE-ADVANCE-RECORD-COUNT TO LIST-COUNT 
                  GIVING LIST-COUNT
                MOVE LIST-COUNT TO LIST-LENGTH
                MOVE FILE-IN-RECORD-VALUE TO LIST-ITEMS(LIST-COUNT)
           END-IF.

           EXIT PARAGRAPH.
