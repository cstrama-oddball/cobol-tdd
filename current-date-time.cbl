       IDENTIFICATION DIVISION.
       PROGRAM-ID. CURRDJUL.
      
       DATA DIVISION.
       WORKING-STORAGE SECTION. 

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

       LINKAGE SECTION. 

       01 DATE-CONV-SUBMOD PIC X(8).

       01  DS-JULIAN-DATE  PIC  9(07).

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

      *++INCLUDE DATEAREA

       PROCEDURE DIVISION USING DS-JULIAN-DATE
                              , DISPLAY-DATE-TIME
                              , W-DATE-AREA
                              , DATE-CONV-SUBMOD.

           MOVE  FUNCTION CURRENT-DATE TO  RUN-DATE-TIME                        
           MOVE  RUN-MONTH             TO  DISPLAY-MONTH                        
           MOVE  RUN-DAY               TO  DISPLAY-DAY                          
           MOVE  RUN-YEAR              TO  DISPLAY-YEAR                         
           MOVE  RUN-HOUR              TO  DISPLAY-HOUR                         
           MOVE  RUN-MINUTE            TO  DISPLAY-MINUTE                       
           MOVE  RUN-SECOND            TO  DISPLAY-SECOND                       
                                                                                
      *    TESTING SHOWED THAT USING CMNDATCV TO CONVERT THE                    
      *    GREGORIAN SYSTEM DATE TO JULIAN IS ALMOST TWICE AS                   
      *    EFFICIENT AS CONVERTING IT USING INTRINSIC FUNCTIONS                 
      *    OR USING THE ACCEPT ... DAY YYYYDDD STATEMENT.                       
                                                                          
           MOVE  RUN-DATE (1:4)        TO  W-DATE-1-8 (5:4)                     
           MOVE  RUN-DATE (5:4)        TO  W-DATE-1-8 (1:4)                     
                                                                                
           CALL  DATE-CONV-SUBMOD      USING  W-DATE-AREA                       
                                                                                
           MOVE  W-DATE-2-7            TO  DS-JULIAN-DATE

           EXIT PROGRAM. 
