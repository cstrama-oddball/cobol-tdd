       IDENTIFICATION DIVISION.
       PROGRAM-ID. TEST-LOAD-CONFIG-FILE.

       DATA DIVISION. 

       WORKING-STORAGE SECTION. 

       01 LIST-LENGTH PIC 9(4).

       01 LOOP-COUNT  PIC 9(2) VALUE 01.

       01 EC-IN-NAME  PIC X(12) VALUE 'test_cfg.txt'.

       01 LIST-RECORD.
          05 LIST-EXAMPLE OCCURS 0 TO 1024 TIMES 
                DEPENDING ON LIST-LENGTH.
             10 LIST-KEY   PIC X(25).
             10 LIST-VALUE PIC X(1024).

      * expected values
       01 EXPECTED-RECORD.
          05 EXPECTED-EXAMPLE OCCURS 2 TIMES.
             10 EXAMPLE-KEY   PIC X(25).
             10 EXAMPLE-VALUE PIC X(1024).

       PROCEDURE DIVISION.

      * arrange
           MOVE 'test key' TO EXAMPLE-KEY(1).
           MOVE 'test value' TO EXAMPLE-VALUE(1).
           MOVE 'test key 2' TO EXAMPLE-KEY(2).
           MOVE 'test value 2' TO EXAMPLE-VALUE(2).

      * act
           CALL 'LOAD-CONFIG-LIST' USING LIST-RECORD, LIST-LENGTH 
                                        , EC-IN-NAME.

      * assert
           IF LIST-LENGTH NOT = 2
              DISPLAY 
                 'LIST LENGTH INVALID. EXPECTING 2, GOT ' LIST-LENGTH 
           END-IF.

           PERFORM UNTIL LOOP-COUNT > 2
              IF LIST-VALUE(LOOP-COUNT) NOT = EXAMPLE-VALUE(LOOP-COUNT)
                 DISPLAY 'LIST VALUE ' LOOP-COUNT ' INVALID. EXPECTING ' 
                   EXAMPLE-VALUE(LOOP-COUNT) ', GOT ' 
                   LIST-VALUE(LOOP-COUNT)
                 ADD 10 TO LOOP-COUNT
              ELSE IF LIST-KEY(LOOP-COUNT) NOT = EXAMPLE-KEY(LOOP-COUNT)
                 DISPLAY 'LIST KEY ' LOOP-COUNT ' INVALID. EXPECTING '
                    EXAMPLE-KEY(LOOP-COUNT) ', GOT '
                    LIST-KEY(LOOP-COUNT)
                 ADD 10 TO LOOP-COUNT
              ELSE
                 ADD 1 TO LOOP-COUNT
              END-IF
           END-PERFORM.