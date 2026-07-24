       identification division.
       program-id. trex_search.
       author. Roger Padrell.


       environment division.

       data division.

       WORKING-STORAGE SECTION.
       01 pattern_len           PIC 9(3).
       01 str_len           PIC 9(3).
       01 str_left           PIC 9(3).

       01 ind           PIC 9(3).
       01 two_pattern               PIC X(256) VALUE SPACES.
       01 two_str                   PIC x(256).
       01 two_matches_bool          PIC 9(1).
º

       LINKAGE SECTION.
       01 pattern               PIC X(256) VALUE SPACES.
       01 str                   PIC x(256).
       01 matches_bool          PIC 9(1).
       01 str_from           PIC 9(3).
       01 str_to           PIC 9(3).
       

       PROCEDURE DIVISION USING pattern str matches_bool str_from 
           str_to.
           COMPUTE pattern_len = FUNCTION STORED-CHAR-LENGTH(pattern).
           COMPUTE str_len = FUNCTION STORED-CHAR-LENGTH(str).
      D    display "Analyzing: " FUNCTION TRIM(str) " with " 
      D        FUNCTION TRIM(pattern)
           IF pattern(1:1) = "^" THEN
               MOVE pattern(2:pattern_len) TO two_pattern
               MOVE str TO two_str
               CALL "trex_match" USING BY REFERENCE two_pattern 
                   two_str matches_bool str_left
               MOVE 1 TO str_from
               COMPUTE str_to = str_len - str_left
           ELSE
               MOVE 0 TO two_matches_bool
               MOVE 0 TO matches_bool
               PERFORM VARYING ind FROM 1 BY 1 UNTIL ind>pattern_len
                   IF two_matches_bool=0 THEN
                       MOVE pattern TO two_pattern
                       MOVE str(ind:str_len) TO two_str
      D                display "Sliced: " FUNCTION TRIM(two_str)
                       CALL "trex_match" USING BY REFERENCE two_pattern 
                           two_str two_matches_bool str_left
      D                display "Got: " two_matches_bool
                       IF two_matches_bool=1 then
                           display "Match starts at: " ind
                           MOVE ind TO str_from
                       END-IF
                   END-IF
                   IF two_matches_bool=1 THEN
                       MOVE 1 TO matches_bool
                       COMPUTE str_to = str_len - str_left
                   END-IF
               END-PERFORM
                       
           END-IF.
           
           GOBACK.
       