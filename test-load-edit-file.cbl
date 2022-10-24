       IDENTIFICATION DIVISION.
       PROGRAM-ID. TEST-LOAD-EDIT-FILE.

       DATA DIVISION. 

       WORKING-STORAGE SECTION. 

       01 LIST-LENGTH PIC 9(4) VALUE 0.

       01 LOOP-COUNT  PIC 9(2) VALUE 01.

       01 EC-IN-NAME  PIC X(12) VALUE 'ec-infl.txt'.

       01 LIST-RECORD.
          05 LIST-EXAMPLE OCCURS 0 TO 1024 TIMES 
                DEPENDING ON LIST-LENGTH.
             10 LIST-VALUE PIC X(4).

      * expected values
       01 EXPECTED-RECORD.
          05 EXPECTED-EXAMPLE OCCURS 9 TIMES.
             10 EXAMPLE-VALUE PIC X(4).

       PROCEDURE DIVISION.

      * arrange
           MOVE 5273 TO EXAMPLE-VALUE(1).
           MOVE 5274 TO EXAMPLE-VALUE(2).
           MOVE 5275 TO EXAMPLE-VALUE(3).
           MOVE 5276 TO EXAMPLE-VALUE(4).
           MOVE 5311 TO EXAMPLE-VALUE(5).
           MOVE 5318 TO EXAMPLE-VALUE(6).
           MOVE 5319 TO EXAMPLE-VALUE(7).
           MOVE 5346 TO EXAMPLE-VALUE(8).
           MOVE 5805 TO EXAMPLE-VALUE(9).

      * act
           CALL 'LOAD-EDIT-LIST' USING LIST-RECORD, LIST-LENGTH 
                                        , EC-IN-NAME.

      * assert
           IF LIST-LENGTH NOT = 9
              DISPLAY 
                 'LIST LENGTH INVALID. EXPECTING 9, GOT ' LIST-LENGTH 
           END-IF.

           PERFORM UNTIL LOOP-COUNT > 9
              IF LIST-VALUE(LOOP-COUNT) NOT = EXAMPLE-VALUE(LOOP-COUNT)
                 DISPLAY 'LIST VALUE ' LOOP-COUNT ' INVALID. EXPECTING ' 
                   EXAMPLE-VALUE(LOOP-COUNT) ', GOT ' 
                   LIST-VALUE(LOOP-COUNT)
                 ADD 10 TO LOOP-COUNT
              ELSE
                 ADD 1 TO LOOP-COUNT
              END-IF
           END-PERFORM.
