       identification division.
       program-id. trex_matchOne.
       author. Roger Padrell.


       environment division.

       data division.

       WORKING-STORAGE SECTION.
       01 pattern_len           PIC 9(3).
       01 str_len           PIC 9(3).


       LINKAGE SECTION.
       01 pattern               PIC X(256) VALUE SPACES.
       01 str                   PIC x(256).
       01 matches_bool          PIC 9(1).
       

       PROCEDURE DIVISION USING pattern str matches_bool.
           COMPUTE pattern_len = FUNCTION STORED-CHAR-LENGTH(pattern).
           COMPUTE str_len = FUNCTION STORED-CHAR-LENGTH(str).
           IF pattern = SPACES OR pattern_len = 0 
           or pattern = low-value THEN
               MOVE 0 TO matches_bool
           ELSE IF str = SPACES OR str_len = 0 OR str = low-value THEN
               MOVE 0 TO matches_bool
           ELSE IF FUNCTION TRIM(pattern) = "." THEN
      D        display "pattern is ."
               MOVE 1 TO matches_bool
           ELSE IF pattern = str THEN
               MOVE 1 TO matches_bool
           ELSE IF pattern(1:1) = "(" THEN
               CALL "trex_matchOneEl" USING BY REFERENCE pattern 
                   str matches_bool
      D        display "Matching element: " TRIM(pattern)
           ELSE 
               MOVE 0 TO matches_bool
           END-IF.
           
           GOBACK.
       