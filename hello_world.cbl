       IDENTIFICATION DIVISION.
       PROGRAM-ID. HW.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
C28755
C28755     SELECT  BTCHCTL-FILE        ASSIGN  BTCHCTL
C28755                                 RECORD  BTCHCTL-KEY
C28755                                 STATUS  FILE-STATUS
C28755                                 ACCESS  RANDOM
C28755                                 ORGANIZATION INDEXED.

       DATA DIVISION. 

       FILE SECTION.

       FD  BTCHCTL-FILE
C28755     RECORD VARYING 316 TO 5450
C28755     DEPENDING LRECL-BTCHCTL.
C28755
C34231 01  WS-BTCHCTL-A               PIC X(316).
C28755     COPY AMNYBATC.

       WORKING-STORAGE SECTION. 

       01  SYNC.
C28755     05                          PIC  X(32)  VALUE
C28755             'AMNBFBTC - BEGIN WORKING STORAGE'.
C28755
C28755     05  COMP.
C28755         10  ABEND-CODE          PIC S9(09)  VALUE +666.
C28755         10  CLEAN-UP            PIC S9(09)  VALUE ZERO.
C28755         10  LRECL-BTCHCTL       PIC  9(04)  VALUE ZERO.
C28755         10  SUB                 PIC S9(04)  VALUE ZERO.
       01  FILE-STATUS         PIC  X(02).
C28755             88  FILE-STATUS-SUCCESS         VALUE ZERO.
C28755             88  FILE-STATUS-END-OF-FILE     VALUE '10'.
C28755             88  FILE-STATUS-VERIFIED        VALUE '97'.
       01 INPUT-TEST PIC X(10).

       LINKAGE SECTION. 

       COPY CICSLINK.

       PROCEDURE DIVISION USING DFHEIBLK.

           DISPLAY 'HELLO, WORLD'.

           DISPLAY EIBTRNID.

           MOVE EIBDATAREC(1:EIBCALEN) TO INPUT-TEST.

           DISPLAY INPUT-TEST.

           GOBACK.