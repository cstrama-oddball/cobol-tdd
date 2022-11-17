       ID DIVISION.                                                             
       PROGRAM-ID.     CMNDATCV.                                                
       ENVIRONMENT DIVISION.                                                    
       DATA DIVISION.                                                           
       WORKING-STORAGE SECTION.                                                 
                                                                                
       01  SYNC.                                                                
           05                          PIC  X(32)  VALUE                        
                   'CMNDATCV - BEGIN WORKING-STORAGE'.                          
                                                                                
      *    PIVOT YEAR '47' TO GENERATE THE CENTURY FOR TWO-DIGIT YEARS.         
                                                                                
           05  CWF-PIVOT-YEAR          PIC  X(02)  VALUE '47'.                  
                                                                                
      *    RELATIVE-DATE IS DEFINED AS PACKED BECAUSE IT IS USED MORE           
      *    WITH PACKED FIELDS THAN WITH BINARY FIELDS.                          
                                                                                
           05  COMP-3.                                                          
               10  RELATIVE-DATE       PIC S9(09)  VALUE ZERO.                  
               10  DAY-WORK            PIC S9(09)  VALUE ZERO.                  
               10  DATE-SAVE           PIC S9(09)  VALUE ZERO.                  
               10  WORK-DAYS           PIC S9(09)  VALUE ZERO.                  
               10  WEEK-DAY            PIC  9(03)  VALUE ZERO.                  
               10  DAYS-IN-YEAR        PIC S9(03)  VALUE ZERO.                  
               10  ADJUST-YY           PIC S9(03)  VALUE ZERO.                  
               10  ADJUST-MMM          PIC S9(03)  VALUE ZERO.                  
               10  DAYS-INTEGER        PIC S9(09)  VALUE ZERO.                  
               10  DAYS-USED           PIC S9(09)V99                            
                                                   VALUE ZERO.                  
               10  REMAINING-DAYS      PIC S9(09)V99                            
                                                   VALUE ZERO.                  
                                                                                
           05  WORK-FIELDS                         VALUE ZERO.                  
               10  DISPLAY-WEEK-DAY    PIC  9(02).                              
                                                                                
               10  SAVE-JULIAN-DATE.                                            
                   15  SAVE-JUL-YYYY-X PIC  X(04).                              
                   15  SAVE-JUL-DDD    PIC  9(03).                              
                                                                                
               10  JULIAN-DATE.                                                 
                   15  JULIAN-CC-X.                                             
                       20  JULIAN-CC   PIC  9(02).                              
                   15  JULIAN-YY-X.                                             
                       20  JULIAN-YY   PIC  9(02).                              
                   15  JULIAN-DDD-X.                                            
                       20  JULIAN-DDD  PIC  9(03).                              
               10  REDEFINES JULIAN-DATE.                                       
                   15  JULIAN-YYYY-X.                                           
                       20  JULIAN-YYYY PIC  9(04).                              
                   15                  PIC  X(03).                              
               10  REDEFINES JULIAN-DATE.                                       
                   15  JULIAN-YYYYDDD  PIC  9(07).                              
                                                                                
               10  GREGORIAN-DATE.                                              
                   15  GREG-CC-X       PIC  X(02).                              
                   15  GREG-YYMMDD.                                             
                       20  GREG-YY-X   PIC  X(02).                              
                       20  GREG-MM-X.                                           
                           25  GREG-MM PIC  9(02).                              
                       20  GREG-DD-X.                                           
                           25  GREG-DD PIC  9(02).                              
               10  REDEFINES GREGORIAN-DATE.                                    
                   15  GREG-YYYY-X.                                             
                       20  GREG-YYYY   PIC  9(04).                              
                   15  GREG-MMDD-X     PIC  X(04).                              
               10  REDEFINES GREGORIAN-DATE.                                    
                   15  GREG-YYYYMMDD   PIC  9(08).                              
      /                                                                         
      *    FILLER IS USED SO DA-80-HALFWORD MAY BE SYNCHRONIZED WHILE           
      *    RETAINING THE SAME OFFSET IN DATE-AREA AS THE BINARY FULLWORD        
      *    AND HALFWORD FIELDS IN DATEAREA, WHICH ARE ALSO SYNCHRONIZED         
      *    AND OFFSET FROM THE START OF THE DATE FIELDS.                        
                                                                                
           05                          PIC S9(09)  COMP.                        
           05                          PIC  X(01).                              
                                                                                
           05  FORMAT-AND-DATE         PIC  X(12)  VALUE SPACE.                 
           05  REDEFINES FORMAT-AND-DATE.                                       
               10  FORMAT-REC            PIC  X(02).                            
                   88  FORMAT-00-YYDDD             VALUE ZERO.                  
                   88  FORMAT-05-YYYYDDD           VALUE '05'.                  
                   88  FORMAT-08-YYYYDDD-PACKED    VALUE '08'.                  
                   88  FORMAT-10-MMDDYY            VALUE '10'.                  
                   88  FORMAT-11-MMDDYY-SLASHES    VALUE '11'.                  
                   88  FORMAT-12-MMDDYYYY          VALUE '12'.                  
                   88  FORMAT-13-MMDDYYYY-SLASHES  VALUE '13'.                  
                   88  FORMAT-14-0YYYYMMDD-PACKED  VALUE '14'.                  
                   88  FORMAT-20-YYMMDD            VALUE '20'.                  
                   88  FORMAT-21-YYYYMMDD          VALUE '21'.                  
                   88  FORMAT-80-REL-MEDICARE      VALUE '80'.                  
                                                                                
               10  DATE-AREA.                                                   
                   15  DA-08-14-PACKED PIC S9(09)  COMP-3.                      
                   15                  PIC  X(05).                              
               10  REDEFINES DATE-AREA.                                         
                   15                  PIC  X(03).                              
                   15  DA-80-HALFWORD  PIC S9(04)  COMP-5.                      
                   15                  PIC  X(05).                              
      /                                                                         
           05  VALUE 'SUNDAY   MONDAY   TUESDAY  WEDNESDAYTHURSDAY FRIDA        
      -              'Y   SATURDAY '.                                           
               10  DAY-OF-WEEK-X       OCCURS 7 TIMES                           
                                       PIC  X(09).                              
           05  MONTH-TABLE-AREA.                                                
               10                PIC  X(24)  VALUE                              
                   X'F3F1000CF3F1000CF2F8031CF2F9031CF3F1059CF3F1060C'.         
      *               -- JANUARY ---  -- FEBRUARY --  --- MARCH ----            
                                                                                
               10                PIC  X(24)  VALUE                              
                   X'F3F0090CF3F0091CF3F1120CF3F1121CF3F0151CF3F0152C'.         
      *               --- APRIL ----  ---- MAY -----  ---- JUNE ----            
                                                                                
               10                PIC  X(24)  VALUE                              
                   X'F3F1181CF3F1182CF3F1212CF3F1213CF3F0243CF3F0244C'.         
      *               ---- JULY ----  --- AUGUST ---  - SEPTEMBER --            
                                                                                
               10                PIC  X(24)  VALUE                              
                   X'F3F1273CF3F1274CF3F0304CF3F0305CF3F1334CF3F1335C'.         
      *               -- OCTOBER ---  -- NOVEMBER --  -- DECEMBER --            
                                                                                
           05  REDEFINES MONTH-TABLE-AREA.                                      
               10  MONTH-TABLE         OCCURS 12 TIMES                          
                                       INDEXED MONTH-INDEX.                     
                   15                  OCCURS 2 TIMES                           
                                       INDEXED LEAP-INDEX.                      
                       20  MT-DAYS-IN-MONTH                                     
                                       PIC  X(02).                              
                       20  MT-DAYS-BEFORE                                       
                                       PIC S9(03)  COMP-3.                      
                                                                                
           05                          PIC  X(30)  VALUE                        
                   'CMNDATCV - END WORKING-STORAGE'.                            
      /                                                                         
       LINKAGE SECTION.                                                         
                                                                                
           COPY DATEAREA.cpy                                                    
      /                                                                         
       PROCEDURE DIVISION           USING  W-DATE-AREA.                         
                                                                                
           SET   CONVERT-RET-GOOD      TO  TRUE                                 
           MOVE  ZERO                  TO  WORK-FIELDS                          
                                                                                
           EVALUATE  TRUE                                                       
             WHEN  FUNC-CONV-THE-DATE                                           
               MOVE  W-FORMAT-AND-DATE-1                                        
                                       TO  FORMAT-AND-DATE                      
               PERFORM 100-CONVERT-INPUT-DATE                                   
               THRU    100-EXIT                                                 
                                                                                
               IF  CONVERT-RET-GOOD                                             
                   MOVE  W-FORMAT-2    TO  FORMAT-REC                           
                                                                                
                   PERFORM 110-CONVERT-OUTPUT-DATE                              
                   THRU    110-EXIT                                             
               END-IF                                                           
                                                                                
             WHEN  FUNC-ADJUST-THE-DATE                                         
               MOVE  W-FORMAT-AND-DATE-1                                        
                                       TO  FORMAT-AND-DATE                      
               PERFORM 100-CONVERT-INPUT-DATE                                   
               THRU    100-EXIT                                                 
                                                                                
               EVALUATE  TRUE                                                   
                 WHEN  W-NUMBER-FIELD      NOT NUMERIC                          
                   SET   CONVERT-RET-BAD-RANGE-INP                              
                                       TO  TRUE                                 
                                                                                
      *          ADD ADJUSTMENT DAYS TO JULIAN DAYS AND CORRECT THE             
      *          RESULT BY SUBTRACTING OR ADDING DAYS IN YEAR UNTIL             
      *          THE FINAL ADJUSTED YEAR AND DAY ARE REACHED:                   
                                                                                
                 WHEN  CONVERT-RET-GOOD                                         
                   COMPUTE WORK-DAYS    =  W-NUMBER-FIELD + JULIAN-DDD          
                                                                                
                   PERFORM 300-LEAP-YEAR-CHECK                                  
                   THRU    300-EXIT                                             
                                                                                
                   PERFORM                                                      
                     UNTIL WORK-DAYS   <=  DAYS-IN-YEAR                         
                       SUBTRACT  DAYS-IN-YEAR                                   
                                     FROM  WORK-DAYS                            
                       ADD   1         TO  JULIAN-YYYY                          
                                                                                
                       PERFORM 300-LEAP-YEAR-CHECK                              
                       THRU    300-EXIT                                         
                   END-PERFORM                                                  
                                                                                
                   PERFORM                                                      
                     UNTIL WORK-DAYS    >  ZERO                                 
                       SUBTRACT  1   FROM  JULIAN-YYYY                          
                                                                                
                       PERFORM 300-LEAP-YEAR-CHECK                              
                       THRU    300-EXIT                                         
                                                                                
                       ADD   DAYS-IN-YEAR                                       
                                       TO  WORK-DAYS                            
                   END-PERFORM                                                  
                                                                                
                   MOVE  WORK-DAYS     TO  JULIAN-DDD                           
                   MOVE  W-FORMAT-2    TO  FORMAT-REC                           
                                                                                
                   PERFORM 110-CONVERT-OUTPUT-DATE                              
                   THRU    110-EXIT                                             
               END-EVALUATE                                                     
                                                                                
      *      THIS CALCULATION SUBTRACTS DATE TWO FROM DATE ONE.                 
                                                                                
             WHEN  FUNC-CALC-DAYS-BETWEEN                                       
               MOVE  ZERO              TO  W-NUMBER-FIELD                       
               MOVE  W-FORMAT-AND-DATE-1                                        
                                       TO  FORMAT-AND-DATE                      
               PERFORM 100-CONVERT-INPUT-DATE                                   
               THRU    100-EXIT                                                 
                                                                                
               IF  CONVERT-RET-GOOD                                             
                   MOVE  JULIAN-DATE   TO  SAVE-JULIAN-DATE                     
                   MOVE  W-FORMAT-AND-DATE-2                                    
                                       TO  FORMAT-AND-DATE                      
                   PERFORM 100-CONVERT-INPUT-DATE                               
                   THRU    100-EXIT                                             
                                                                                
                   IF  CONVERT-RET-GOOD                                         
                       MOVE  ZERO      TO  GREGORIAN-DATE                       
                                                                                
                       IF  JULIAN-YYYY-X                                        
                                        >  SAVE-JUL-YYYY-X                      
                           PERFORM                                              
                             UNTIL JULIAN-YYYY-X                                
                                        =  SAVE-JUL-YYYY-X                      
                               SUBTRACT  1                                      
                                     FROM  JULIAN-YYYY                          
                               PERFORM 300-LEAP-YEAR-CHECK                      
                               THRU    300-EXIT                                 
                                                                                
                               SUBTRACT  DAYS-IN-YEAR                           
                                     FROM  W-NUMBER-FIELD                       
                           END-PERFORM                                          
                       ELSE                                                     
                           PERFORM                                              
                             UNTIL JULIAN-YYYY-X                                
                                        =  SAVE-JUL-YYYY-X                      
                               PERFORM 300-LEAP-YEAR-CHECK                      
                               THRU    300-EXIT                                 
                                                                                
                               ADD   DAYS-IN-YEAR                               
                                       TO  W-NUMBER-FIELD                       
                               ADD   1 TO  JULIAN-YYYY                          
                           END-PERFORM                                          
                       END-IF                                                   
                                                                                
                       COMPUTE W-NUMBER-FIELD                                   
                                        =  W-NUMBER-FIELD                       
                                        +  SAVE-JUL-DDD                         
                                        -  JULIAN-DDD                           
                   END-IF                                                       
               END-IF                                                           
                                                                                
             WHEN  FUNC-VERIFY-THE-DATE                                         
               MOVE  W-FORMAT-AND-DATE-1                                        
                                       TO  FORMAT-AND-DATE                      
               PERFORM 100-CONVERT-INPUT-DATE                                   
               THRU    100-EXIT                                                 
                                                                                
             WHEN  FUNC-CONV-TO-DAY-OF-WEEK                                     
               MOVE  W-FORMAT-AND-DATE-1                                        
                                       TO  FORMAT-AND-DATE                      
               PERFORM 100-CONVERT-INPUT-DATE                                   
               THRU    100-EXIT                                                 
                                                                                
               IF  CONVERT-RET-GOOD                                             
                   SET   FORMAT-80-REL-MEDICARE                                 
                                       TO  TRUE                                 
                   PERFORM 110-CONVERT-OUTPUT-DATE                              
                   THRU    110-EXIT                                             
                                                                                
                   ADD   W-DATE-2-FULLWORD                                      
                         +1        GIVING  RELATIVE-DATE                        
                                                                                
                   DIVIDE  RELATIVE-DATE                                        
                                       BY  +7                                   
                                   GIVING  RELATIVE-DATE                        
                                REMAINDER  WEEK-DAY                             
                   ADD   +1            TO  WEEK-DAY                             
                   MOVE  WEEK-DAY      TO  DISPLAY-WEEK-DAY                     
                   MOVE  DISPLAY-WEEK-DAY                                       
                                       TO  W-FORMAT-2                           
                   MOVE  DAY-OF-WEEK-X (WEEK-DAY)                               
                                       TO  W-DATE-2                             
               END-IF                                                           
                                                                                
             WHEN  FUNC-CONV-SYSTEM-DATE                                        
               ACCEPT  JULIAN-YYYYDDD                                           
                                     FROM  DAY YYYYDDD                          
               MOVE  W-FORMAT-2        TO  FORMAT-REC                           
                                                                                
               PERFORM 110-CONVERT-OUTPUT-DATE                                  
               THRU    110-EXIT                                                 
                                                                                
      *      ADJUST INPUT DATE BY YEARS AND/OR MONTHS IN                        
                                                                                
             WHEN  FUNC-ADJUST-YYMMM                                            
               MOVE  W-FORMAT-AND-DATE-1                                        
                                       TO  FORMAT-AND-DATE                      
               PERFORM 100-CONVERT-INPUT-DATE                                   
               THRU    100-EXIT                                                 
                                                                                
               EVALUATE  TRUE                                                   
                 WHEN  W-NUMBER-FIELD      NOT NUMERIC                          
                 WHEN  W-NUMBER-FIELD   =  ZERO                                 
                   SET   CONVERT-RET-BAD-RANGE-INP                              
                                       TO  TRUE                                 
                                                                                
      *          W-NUMBER-FIELD IS IN FORMAT YYMMM: DIVIDING BY 1000            
      *          EXTRACTS YEARS AND MONTHS.                                     
                                                                                
                 WHEN  CONVERT-RET-GOOD                                         
                   DIVIDE  W-NUMBER-FIELD                                       
                                       BY  +1000                                
                                   GIVING  ADJUST-YY                            
                                REMAINDER  ADJUST-MMM                           
                                                                                
                   IF  ADJUST-YY    NOT =  ZERO                                 
                   AND ADJUST-MMM   NOT =  ZERO                                 
                       SET   CONVERT-RET-BAD-RANGE-INP                          
                                       TO  TRUE                                 
                   ELSE                                                         
                       IF  ADJUST-YY    =  ZERO                                 
                           DIVIDE  W-NUMBER-FIELD                               
                                       BY  +12                                  
                                   GIVING  ADJUST-YY                            
                                REMAINDER  ADJUST-MMM                           
                       END-IF                                                   
                                                                                
                       PERFORM 220-JULIAN-TO-GREGORIAN                          
                       THRU    220-EXIT                                         
                                                                                
                       ADD   GREG-MM   TO  ADJUST-MMM                           
                                                                                
                       EVALUATE  TRUE                                           
                         WHEN  ADJUST-MMM                                       
                                        >  +12                                  
                           SUBTRACT  +12                                        
                                     FROM  ADJUST-MMM                           
                           ADD   +1    TO  ADJUST-YY                            
                                                                                
                         WHEN  ADJUST-MMM                                       
                                        <  +1                                   
                           ADD   +12   TO  ADJUST-MMM                           
                           SUBTRACT  +1                                         
                                     FROM  ADJUST-YY                            
                       END-EVALUATE                                             
                                                                                
                       MOVE  ADJUST-MMM                                         
                                       TO  GREG-MM                              
                       ADD   ADJUST-YY TO  GREG-YYYY                            
                       MOVE  GREG-YYYY-X                                        
                                       TO  JULIAN-YYYY-X                        
                       PERFORM 300-LEAP-YEAR-CHECK                              
                       THRU    300-EXIT                                         
                                                                                
                       IF  MT-DAYS-IN-MONTH (GREG-MM LEAP-INDEX)                
                                        <  GREG-DD-X                            
                           MOVE  MT-DAYS-IN-MONTH (GREG-MM LEAP-INDEX)          
                                       TO  GREG-DD-X                            
                       END-IF                                                   
                                                                                
                       PERFORM 210-GREGORIAN-TO-JULIAN                          
                       THRU    210-EXIT                                         
                                                                                
                       IF  CONVERT-RET-GOOD                                     
                           MOVE  W-FORMAT-2                                     
                                       TO  FORMAT-REC                           
                           PERFORM 110-CONVERT-OUTPUT-DATE                      
                           THRU    110-EXIT                                     
                       END-IF                                                   
                   END-IF                                                       
               END-EVALUATE                                                     
                                                                                
             WHEN  OTHER                                                        
               SET   CONVERT-RET-BAD-FUNCTION                                   
                                       TO  TRUE                                 
           END-EVALUATE                                                         
                                                                                
           IF  FORMAT-2-REL-MEDICARE                                            
           AND NOT CONVERT-RET-GOOD                                             
               IF  FORMAT-1-REL-MEDICARE                                        
                   MOVE  W-DATE-1      TO  W-DATE-2                             
               ELSE                                                             
                   MOVE  LOW-VALUES    TO  W-DATE-2                             
               END-IF                                                           
           END-IF                                                               
                                                                                
           GOBACK.                                                              
      /                                                                         
       100-CONVERT-INPUT-DATE.                                                  
                                                                                
           EVALUATE  TRUE                                                       
             WHEN  FORMAT-08-YYYYDDD-PACKED                                     
               MOVE  LOW-VALUES        TO  DATE-AREA (1:1)                      
                                                                                
               IF  DA-08-14-PACKED         NUMERIC                              
                   MOVE  DA-08-14-PACKED                                        
                                       TO  JULIAN-YYYYDDD                       
                   PERFORM 200-VALIDATE-JULIAN-DATE                             
                   THRU    200-EXIT                                             
               ELSE                                                             
                   SET   CONVERT-RET-BAD-RANGE-INP                              
                                       TO  TRUE                                 
               END-IF                                                           
                                                                                
             WHEN  FORMAT-05-YYYYDDD                                            
               MOVE  DATE-AREA (1:7)   TO  JULIAN-DATE                          
                                                                                
               PERFORM 200-VALIDATE-JULIAN-DATE                                 
               THRU    200-EXIT                                                 
                                                                                
             WHEN  FORMAT-12-MMDDYYYY                                           
               MOVE  DATE-AREA (5:4)   TO  GREG-YYYY-X                          
               MOVE  DATE-AREA (1:4)   TO  GREG-MMDD-X                          
                                                                                
               PERFORM 210-GREGORIAN-TO-JULIAN                                  
               THRU    210-EXIT                                                 
                                                                                
             WHEN  FORMAT-13-MMDDYYYY-SLASHES                                   
               MOVE  DATE-AREA (7:4)   TO  GREG-YYYY-X                          
               MOVE  DATE-AREA (1:2)   TO  GREG-MM-X                            
               MOVE  DATE-AREA (4:2)   TO  GREG-DD-X                            
                                                                                
               PERFORM 210-GREGORIAN-TO-JULIAN                                  
               THRU    210-EXIT                                                 
                                                                                
             WHEN  FORMAT-14-0YYYYMMDD-PACKED                                   
               IF  DA-08-14-PACKED         NUMERIC                              
                   MOVE  DA-08-14-PACKED                                        
                                       TO  GREG-YYYYMMDD                        
                   PERFORM 210-GREGORIAN-TO-JULIAN                              
                   THRU    210-EXIT                                             
               ELSE                                                             
                   SET   CONVERT-RET-BAD-RANGE-INP                              
                                       TO  TRUE                                 
               END-IF                                                           
                                                                                
             WHEN  FORMAT-21-YYYYMMDD                                           
               MOVE  DATE-AREA (1:8)   TO  GREGORIAN-DATE                       
                                                                                
               PERFORM 210-GREGORIAN-TO-JULIAN                                  
               THRU    210-EXIT                                                 
                                                                                
             WHEN  FORMAT-80-REL-MEDICARE                                       
               MOVE  DA-80-HALFWORD    TO  RELATIVE-DATE                        
                                           DATE-SAVE                            
                                                                                
      *                                    -21917 IS 12/30/1900.                
               IF  RELATIVE-DATE        <  -21917                               
                   SUBTRACT  +1      FROM  RELATIVE-DATE                        
               END-IF                                                           
                                                                                
               DIVIDE  RELATIVE-DATE   BY  +365.25                              
                                   GIVING  RELATIVE-DATE                        
                                REMAINDER  REMAINING-DAYS                       
                                                                                
               IF  REMAINING-DAYS      <=  ZERO                                 
                   SUBTRACT  +1      FROM  RELATIVE-DATE                        
               END-IF                                                           
                                                                                
               ADD   1961                                                       
                     RELATIVE-DATE GIVING  JULIAN-YYYY                          
                                                                                
               IF  RELATIVE-DATE        =  ZERO                                 
                   MOVE  DATE-SAVE     TO  DAY-WORK                             
               ELSE                                                             
                   COMPUTE DAYS-USED    =  RELATIVE-DATE * +365.25              
                                                                                
                   MOVE  DAYS-USED     TO  DAYS-INTEGER                         
                                                                                
                   IF  DAYS-INTEGER        NEGATIVE                             
                   AND DAYS-USED    NOT =  DAYS-INTEGER                         
                       SUBTRACT  +1  FROM  DAYS-INTEGER                         
                   END-IF                                                       
      *                                    -21917 IS 12/30/1900.                
                   IF  DAYS-INTEGER     <  -21917                               
                       ADD   +1        TO  DAYS-INTEGER                         
                   END-IF                                                       
                                                                                
                   SUBTRACT  DAYS-INTEGER                                       
                                     FROM  DATE-SAVE                            
                                   GIVING  DAY-WORK                             
               END-IF                                                           
                                                                                
               IF  DAY-WORK             =  ZERO                                 
                   MOVE  '001'         TO  JULIAN-DDD-X                         
               ELSE                                                             
                   MOVE  DAY-WORK      TO  JULIAN-DDD                           
               END-IF                                                           
                                                                                
             WHEN  FORMAT-00-YYDDD                                              
               MOVE  DATE-AREA (1:5)   TO  JULIAN-DATE (3:5)                    
                                                                                
               IF  JULIAN-YY-X          <  CWF-PIVOT-YEAR                       
                   MOVE  '20'          TO  JULIAN-CC-X                          
               ELSE                                                             
                   MOVE  '19'          TO  JULIAN-CC-X                          
               END-IF                                                           
                                                                                
               PERFORM 200-VALIDATE-JULIAN-DATE                                 
               THRU    200-EXIT                                                 
                                                                                
             WHEN  FORMAT-20-YYMMDD                                             
               MOVE  DATE-AREA (1:6)   TO  GREG-YYMMDD                          
                                                                                
               PERFORM 210-GREGORIAN-TO-JULIAN                                  
               THRU    210-EXIT                                                 
                                                                                
             WHEN  FORMAT-10-MMDDYY                                             
               MOVE  DATE-AREA (5:2)   TO  GREG-YY-X                            
               MOVE  DATE-AREA (1:4)   TO  GREG-MMDD-X                          
                                                                                
               PERFORM 210-GREGORIAN-TO-JULIAN                                  
               THRU    210-EXIT                                                 
                                                                                
             WHEN  FORMAT-11-MMDDYY-SLASHES                                     
               MOVE  DATE-AREA (7:2)   TO  GREG-YY-X                            
               MOVE  DATE-AREA (1:2)   TO  GREG-MM-X                            
               MOVE  DATE-AREA (4:2)   TO  GREG-DD-X                            
                                                                                
               PERFORM 210-GREGORIAN-TO-JULIAN                                  
               THRU    210-EXIT                                                 
                                                                                
             WHEN  OTHER                                                        
               SET   CONVERT-RET-BAD-FORMAT                                     
                                       TO  TRUE                                 
           END-EVALUATE                                                         
           .                                                                    
       100-EXIT.                                                                
           EXIT.                                                                
      /                                                                         
       110-CONVERT-OUTPUT-DATE.                                                 
                                                                                
           MOVE  SPACE                 TO  DATE-AREA                            
                                                                                
           EVALUATE  TRUE                                                       
             WHEN  FORMAT-08-YYYYDDD-PACKED                                     
               MOVE  JULIAN-YYYYDDD    TO  W-DATE-2-5-PACKED                    
                                                                                
             WHEN  FORMAT-05-YYYYDDD                                            
               MOVE  JULIAN-DATE       TO  W-DATE-2 (1:7)                       
                                                                                
             WHEN  FORMAT-12-MMDDYYYY                                           
               PERFORM 220-JULIAN-TO-GREGORIAN                                  
               THRU    220-EXIT                                                 
                                                                                
               STRING  GREG-MMDD-X                                              
                       GREG-YYYY-X                     DELIMITED SIZE           
                                     INTO  W-DATE-2                             
                                                                                
             WHEN  FORMAT-13-MMDDYYYY-SLASHES                                   
               PERFORM 220-JULIAN-TO-GREGORIAN                                  
               THRU    220-EXIT                                                 
                                                                                
               STRING  GREG-MM-X                                                
                       '/'                                                      
                       GREG-DD-X                                                
                       '/'                                                      
                       GREG-YYYY-X                     DELIMITED SIZE           
                                     INTO  W-DATE-2                             
                                                                                
             WHEN  FORMAT-14-0YYYYMMDD-PACKED                                   
               PERFORM 220-JULIAN-TO-GREGORIAN                                  
               THRU    220-EXIT                                                 
                                                                                
               MOVE  GREG-YYYYMMDD     TO  W-DATE-2-5-PACKED                    
                                                                                
             WHEN  FORMAT-21-YYYYMMDD                                           
               PERFORM 220-JULIAN-TO-GREGORIAN                                  
               THRU    220-EXIT                                                 
                                                                                
               MOVE  GREGORIAN-DATE    TO  W-DATE-2 (1:8)                       
                                                                                
             WHEN  FORMAT-10-MMDDYY                                             
               PERFORM 220-JULIAN-TO-GREGORIAN                                  
               THRU    220-EXIT                                                 
                                                                                
               STRING  GREG-MMDD-X                                              
                       GREG-YY-X                       DELIMITED SIZE           
                                     INTO  W-DATE-2                             
                                                                                
             WHEN  FORMAT-11-MMDDYY-SLASHES                                     
               PERFORM 220-JULIAN-TO-GREGORIAN                                  
               THRU    220-EXIT                                                 
                                                                                
               STRING  GREG-MM-X                                                
                       '/'                                                      
                       GREG-DD-X                                                
                       '/'                                                      
                       GREG-YY-X                       DELIMITED SIZE           
                                     INTO  W-DATE-2                             
                                                                                
             WHEN  FORMAT-20-YYMMDD                                             
               PERFORM 220-JULIAN-TO-GREGORIAN                                  
               THRU    220-EXIT                                                 
                                                                                
               MOVE  GREG-YYMMDD       TO  W-DATE-2 (1:6)                       
                                                                                
             WHEN  FORMAT-80-REL-MEDICARE                                       
               COMPUTE DAYS-INTEGER                                             
                       DAYS-USED        = (JULIAN-YYYY - 1961) * 365.25         
               COMPUTE W-DATE-2-FULLWORD                                        
                                        =  DAYS-INTEGER + JULIAN-DDD            
                                                                                
               IF  JULIAN-YYYY-X        <  '1961'                               
               AND DAYS-USED        NOT =  DAYS-INTEGER                         
                   SUBTRACT  +1      FROM  W-DATE-2-FULLWORD                    
               END-IF                                                           
      *                                    -21916 IS 12/29/1900.                
               IF  W-DATE-2-FULLWORD   <=  -21916                               
                   ADD   +1            TO  W-DATE-2-FULLWORD                    
               END-IF                                                           
                                                                                
      *        RESULT OVERFLOWS SIGNED HALFWORD.                                
                                                                                
               IF  W-DATE-2-FULLWORD    <  -32768                               
               OR                       >  +32767                               
                   SET   CONVERT-RET-BAD-BINARY-LARGE                           
                                       TO  TRUE                                 
               END-IF                                                           
                                                                                
             WHEN  OTHER                                                        
               SET   CONVERT-RET-BAD-FORMAT                                     
                                       TO  TRUE                                 
           END-EVALUATE                                                         
           .                                                                    
       110-EXIT.                                                                
           EXIT.                                                                
      /                                                                         
       200-VALIDATE-JULIAN-DATE.                                                
                                                                                
           IF  JULIAN-DDD-X             >  ZERO                                 
           AND JULIAN-CC-X              >  ZERO                                 
           AND JULIAN-DATE                 NUMERIC                              
               PERFORM 300-LEAP-YEAR-CHECK                                      
               THRU    300-EXIT                                                 
                                                                                
               IF  JULIAN-DDD           >  DAYS-IN-YEAR                         
                   SET   CONVERT-RET-BAD-DAY-OR-FMT                             
                                       TO  TRUE                                 
               END-IF                                                           
           ELSE                                                                 
               SET   CONVERT-RET-BAD-RANGE-INP                                  
                                       TO  TRUE                                 
           END-IF                                                               
           .                                                                    
       200-EXIT.                                                                
           EXIT.                                                                
      /                                                                         
       210-GREGORIAN-TO-JULIAN.                                                 
                                                                                
           IF  FORMAT-20-YYMMDD                                                 
           OR  FORMAT-10-MMDDYY                                                 
           OR  FORMAT-11-MMDDYY-SLASHES                                         
               IF  GREG-CC-X            =  ZERO                                 
                   IF  GREG-YY-X        <  CWF-PIVOT-YEAR                       
                       MOVE  '20'      TO  GREG-CC-X                            
                   ELSE                                                         
                       MOVE  '19'      TO  GREG-CC-X                            
                   END-IF                                                       
               END-IF                                                           
           END-IF                                                               
                                                                                
           EVALUATE  TRUE                                                       
             WHEN  GREGORIAN-DATE          NOT NUMERIC                          
             WHEN  GREG-CC-X            =  ZERO                                 
               SET   CONVERT-RET-BAD-RANGE-INP                                  
                                       TO  TRUE                                 
                                                                                
             WHEN  GREG-MM-X            <  '01'                                 
             WHEN  GREG-MM-X            >  '12'                                 
               SET   CONVERT-RET-BAD-MTH-OR-FMT                                 
                                       TO  TRUE                                 
                                                                                
             WHEN  GREG-DD-X            <  '01'                                 
             AND   NOT FUNC-ADJUST-YYMMM                                        
               SET   CONVERT-RET-BAD-DAY-OR-FMT                                 
                                       TO  TRUE                                 
             WHEN  OTHER                                                        
               MOVE  GREG-YYYY-X       TO  JULIAN-YYYY-X                        
                                                                                
               PERFORM 300-LEAP-YEAR-CHECK                                      
               THRU    300-EXIT                                                 
                                                                                
               ADD   MT-DAYS-BEFORE (GREG-MM LEAP-INDEX)                        
                     GREG-DD       GIVING  JULIAN-DDD                           
                                                                                
               IF  GREG-DD-X            >  MT-DAYS-IN-MONTH                     
                                                   (GREG-MM LEAP-INDEX)         
               AND NOT FUNC-ADJUST-YYMMM                                        
                   SET   CONVERT-RET-BAD-DAY-OR-FMT                             
                                       TO  TRUE                                 
               END-IF                                                           
           END-EVALUATE                                                         
           .                                                                    
       210-EXIT.                                                                
           EXIT.                                                                
      /                                                                         
       220-JULIAN-TO-GREGORIAN.                                                 
                                                                                
           PERFORM 300-LEAP-YEAR-CHECK                                          
           THRU    300-EXIT                                                     
                                                                                
           MOVE  JULIAN-YYYY-X         TO  GREG-YYYY-X                          
           MOVE  JULIAN-DDD            TO  DAY-WORK                             
           SET   MONTH-INDEX           TO  +1                                   
                                                                                
           SEARCH  MONTH-TABLE                                                  
             WHEN  MONTH-INDEX          =  +12                                  
             OR    MT-DAYS-BEFORE (MONTH-INDEX + +1 LEAP-INDEX)                 
                                       >=  DAY-WORK                             
               SET   GREG-MM           TO  MONTH-INDEX                          
                                                                                
               COMPUTE GREG-DD          =  DAY-WORK                             
                                        -  MT-DAYS-BEFORE                       
                                                (MONTH-INDEX LEAP-INDEX)        
           END-SEARCH                                                           
           .                                                                    
       220-EXIT.                                                                
           EXIT.                                                                
                                                                                
       300-LEAP-YEAR-CHECK.                                                     
                                                                                
      *    CENTURY YEARS ARE LEAP YEARS ONLY IF THE CENTURY IS EVENLY           
      *    DIVISIBLE BY FOUR: 2000 WAS A LEAP YEAR, BUT NOT 1900.               
                                                                                
           IF (JULIAN-YY-X              >  ZERO                                 
           AND JULIAN-YY                = (JULIAN-YY / +4) * +4)                
           OR (JULIAN-YY-X              =  ZERO                                 
           AND JULIAN-CC                = (JULIAN-CC / +4) * +4)                
               SET   LEAP-INDEX        TO  +2                                   
               MOVE  +366              TO  DAYS-IN-YEAR                         
           ELSE                                                                 
               SET   LEAP-INDEX        TO  +1                                   
               MOVE  +365              TO  DAYS-IN-YEAR                         
           END-IF                                                               
           .                                                                    
       300-EXIT.                                                                
           EXIT.                                                                
