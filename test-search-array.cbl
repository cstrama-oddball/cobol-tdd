       IDENTIFICATION DIVISION.
       PROGRAM-ID. TEST-SEARCH-ARRAY.

       DATA DIVISION. 

       WORKING-STORAGE SECTION. 

       01 LIST-LENGTH PIC 9(4).
      
       01 LIST-RECORD.
          05 LIST-EXAMPLE OCCURS 3 TIMES.
             10 LIST-VALUE PIC X(4).

       01 SEARCH-VALUE PIC X(4).

       01 RECORD-FOUND PIC S9(1).

       PROCEDURE DIVISION.

      * arrange
           MOVE 3 TO LIST-LENGTH.

           MOVE '1111' TO LIST-EXAMPLE(1).
           MOVE '2222' TO LIST-EXAMPLE(2).
           MOVE '3333' TO LIST-EXAMPLE(3).

           MOVE '0000' TO SEARCH-VALUE.

      * act
           CALL 'SEARCH-EDIT-LIST' USING LIST-RECORD, LIST-LENGTH 
                                          , RECORD-FOUND, SEARCH-VALUE.

      * assert
           IF RECORD-FOUND NOT = -1
              DISPLAY 'RECORD-FOUND INVALID, EXPECTING -1, GOT '
                 RECORD-FOUND
           END-IF.

      * arrange
           MOVE '2222' TO SEARCH-VALUE.

      * act
           CALL 'SEARCH-EDIT-LIST' USING LIST-RECORD, LIST-LENGTH 
                                          , RECORD-FOUND, SEARCH-VALUE.
      * assert
           IF RECORD-FOUND NOT = 2
              DISPLAY 'RECORD-FOUND INVALID, EXPECTING 2, GOT '
                 RECORD-FOUND
           END-IF.
