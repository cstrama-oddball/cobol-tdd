       IDENTIFICATION DIVISION.
       PROGRAM-ID. HW.

       DATA DIVISION. 
       WORKING-STORAGE SECTION. 

       01 INPUT-TEST PIC X(10).

       LINKAGE SECTION. 

       COPY CICSLINK.

       PROCEDURE DIVISION USING DFHEIBLK.

           DISPLAY 'HELLO, WORLD'.

           DISPLAY EIBTRNID.

           MOVE EIBDATAREC(1:EIBCALEN) TO INPUT-TEST.

           DISPLAY INPUT-TEST.

           GOBACK.
