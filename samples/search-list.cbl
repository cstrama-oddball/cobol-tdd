       IDENTIFICATION DIVISION.
       PROGRAM-ID. SEARCH-EDIT-LIST.
      
       DATA DIVISION.
       WORKING-STORAGE SECTION. 
         01 LIST-COUNT PIC 9(4).

      * CONSTANTS
         01 RECORD-NOT-FOUND-FLAG PIC S9(1) VALUE -1.
         01 FIRST-RECORD PIC 9(1) VALUE 1.
         01 LIST-ADVANCE-RECORD-COUNT PIC 9(1) VALUE 1.

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
           PERFORM 000-INITIALIZE THRU 000-EXIT.
           PERFORM 001-SEARCH THRU 001-EXIT.
           
           GOBACK.

       000-INITIALIZE.
      *    INITIALIZE THE LOOP COUNTER AND RETURN VALUE
           MOVE FIRST-RECORD TO LIST-COUNT.
           MOVE RECORD-NOT-FOUND-FLAG TO RECORD-FOUND.

       000-EXIT.
           EXIT.

       001-SEARCH.
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

       001-EXIT.
           EXIT.
