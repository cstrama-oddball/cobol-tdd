       IDENTIFICATION DIVISION.
       PROGRAM-ID. SEARCH-NUMERIC-LIST.
      
       DATA DIVISION.
       WORKING-STORAGE SECTION.

       01  DATE-STAMP.                                                  
           05  DS-JULIAN-DATE  PIC  9(07).                              
           05  DS-TIME         PIC  X(06).

       01 DATE-CONV-SUBMOD PIC X(8).

       01  DISPLAY-DATE-TIME       VALUE 'MM/DD/YYYY  HH:MM:SS'.        
           05  DISPLAY-DATE.                                                
               10  DISPLAY-MONTH   PIC  X(02).                              
               10                  PIC  X(01).                              
               10  DISPLAY-DAY     PIC  X(02).                              
               10                  PIC  X(01).                              
               10  DISPLAY-YEAR    PIC  X(04).                              
           05                      PIC  X(02).                              
           05  DISPLAY-TIME.                                                
               10  DISPLAY-HOUR    PIC  X(02).                              
               10                  PIC  X(01).                              
               10  DISPLAY-MINUTE  PIC  X(02).                              
               10                  PIC  X(01).                              
               10  DISPLAY-SECOND  PIC  X(02).

       01  RUN-DATE-TIME.                                               
           05  RUN-DATE.                                                
               10  RUN-YEAR    PIC  X(04).                              
               10  RUN-MONTH   PIC  X(02).                              
               10  RUN-DAY     PIC  X(02).                              
                                                                         
           05  RUN-TIME        PIC  9(06).                              
           05  REDEFINES RUN-TIME.                                      
               10  RUN-HOUR    PIC  X(02).                              
               10  RUN-MINUTE  PIC  X(02).                              
               10  RUN-SECOND  PIC  X(02).

       01 ASSERT-TIME PIC 9(6).

       01 COMPARE-TIME.
           05 COMPARE-HOUR PIC 9(2).
           05 COMPARE-MIN PIC 9(2).
           05 COMPARE-SEC PIC 9(2).

      *++INCLUDE DATEAREA.cpy

       PROCEDURE DIVISION.

      * arrange     
           MOVE 'STUBCUDA' TO DATE-CONV-SUBMOD.
           MOVE  FUNCTION CURRENT-DATE TO  RUN-DATE-TIME. 
           MOVE  RUN-TIME TO ASSERT-TIME.
           SET FUNC-CONV-THE-DATE                                        
                FORMAT-1-YYYYDDD-PACKED                                   
                FORMAT-2-MMDDYYYY TO TRUE

      * act
           CALL 'CURRDJUL' USING DS-JULIAN-DATE
                              , DISPLAY-DATE-TIME 
                              , W-DATE-AREA
                              , DATE-CONV-SUBMOD.

      * assert
           IF DS-JULIAN-DATE NOT = 2022001
              DISPLAY 'INVALID JULIAN DATE, EXPECTED 2022001, GOT '
                 DS-JULIAN-DATE 
           END-IF.

           MOVE DISPLAY-HOUR TO COMPARE-HOUR.
           MOVE DISPLAY-MINUTE TO COMPARE-MIN.
           MOVE DISPLAY-SECOND TO COMPARE-SEC.

           IF COMPARE-TIME < ASSERT-TIME 
              DISPLAY 'INVALID TIME EXPECTED >= ' ASSERT-TIME ', GOT '
                 COMPARE-TIME
           END-IF.
           
           EXIT PROGRAM.
