       IDENTIFICATION DIVISION.
       PROGRAM-ID. SEARCH-NUMERIC-LIST.
      
       DATA DIVISION.
       WORKING-STORAGE SECTION. 
         01 LIST-COUNT PIC 9(4).
         01 DONE-FLAG PIC X(1) VALUE 'N'.

      * CONSTANTS
         01 RECORD-NOT-FOUND-FLAG PIC S9(1) VALUE -1.
         01 FIRST-RECORD PIC 9(1) VALUE 1.
         01 LIST-ADVANCE-RECORD-COUNT PIC 9(1) VALUE 1.
         01 ALL-DONE PIC X(1) VALUE 'Y'.
         01 NOT-DONE PIC X(1) VALUE 'N'.

       LINKAGE SECTION.
         01 LIST-LENGTH PIC 9(4).

         01 SEARCH-VALUE PIC X(4).

         01 RECORD-FOUND PIC S9(1).
       
         01 LIST-RECORD.
            05 LIST-ITEMS OCCURS 0 TO 1024 TIMES 
                DEPENDING ON LIST-LENGTH.
            10 LIST-VALUE PIC X(4).
      
      * By Ref variables
      * LIST-RECORD is the list that is filled and passed back
      * LIST-LENGTH is the length of LIST-RECORD
      * SEARCH-VALUE the value to find in the array
      * RECORD-FOUND is the flag to indicate whether to value was 
      *   found or not
      *   1 == found, 0 == not found
       PROCEDURE DIVISION USING LIST-RECORD, LIST-LENGTH 
                              , RECORD-FOUND, SEARCH-VALUE.
           MOVE NOT-DONE TO DONE-FLAG.
           PERFORM 000-INITIALIZE.
           PERFORM 001-SEARCH.
           MOVE ALL-DONE TO DONE-FLAG.
           
           EXIT PROGRAM.

       000-INITIALIZE.
           IF DONE-FLAG = ALL-DONE
              EXIT PARAGRAPH 
           END-IF.
      *    INITIALIZE THE LOOP COUNTER AND RETURN VALUE
           MOVE FIRST-RECORD TO LIST-COUNT.
           MOVE RECORD-NOT-FOUND-FLAG TO RECORD-FOUND.

           EXIT PARAGRAPH.

       001-SEARCH.
           IF DONE-FLAG = ALL-DONE
              EXIT PARAGRAPH 
           END-IF.
           PERFORM UNTIL LIST-COUNT > LIST-LENGTH
              IF LIST-VALUE(LIST-COUNT) = SEARCH-VALUE
                 MOVE LIST-COUNT TO RECORD-FOUND
      *          DROP OUT OF THE LOOP WHEN THE VALUE IS FOUND
                 ADD LIST-ADVANCE-RECORD-COUNT TO LIST-LENGTH 
                    GIVING LIST-COUNT
              ELSE
      *          ADVANCE TO THE NEXT ELEMENT OF THE ARRAY
                 ADD LIST-ADVANCE-RECORD-COUNT TO LIST-COUNT
              END-IF
           END-PERFORM.

           EXIT PARAGRAPH.
