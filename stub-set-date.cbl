       IDENTIFICATION DIVISION.
       PROGRAM-ID. STUBCUDA.
      
       DATA DIVISION.
       WORKING-STORAGE SECTION.

       01  DATE-STAMP.                                                  
           05  DS-JULIAN-DATE  PIC  9(07).                              
           05  DS-TIME         PIC  X(06).

       01 DATE-CONV-SUBMOD PIC X(8).

       LINKAGE SECTION. 
      *++INCLUDE DATEAREA

       PROCEDURE DIVISION USING W-DATE-AREA.

           DISPLAY 'STUB DATE CONVERSION'.

           DISPLAY 'FUNCTION CODE: ' W-FUNCTION-CODE
           DISPLAY 'FORMAT 1: ' W-FORMAT-1
           DISPLAY 'FORMAT 2: ' W-FORMAT-2
           
           MOVE '2022001' TO W-DATE-2-7.


           
           EXIT PROGRAM.
