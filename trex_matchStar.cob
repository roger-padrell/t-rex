       identification division.
       program-id. trex_matchStar recursive.
       author. Roger Padrell.


       environment division.

       data division.

       WORKING-STORAGE SECTION.
       01 pattern_len           PIC 9(3).
       01 str_len           PIC 9(3).
       01 one_pattern               PIC X(256) VALUE SPACES.
       01 one_str                   PIC x(256).
       01 one_matches_bool          PIC 9(1).

       01 two_pattern               PIC X(256) VALUE SPACES.
       01 two_str                   PIC x(256).
       01 two_matches_bool          PIC 9(1).

       01 thr_pattern               PIC X(256) VALUE SPACES.
       01 thr_str                   PIC x(256).
       01 thr_matches_bool          PIC 9(1).


       LINKAGE SECTION.
       01 pattern               PIC X(256) VALUE SPACES.
       01 str                   PIC x(256).
       01 matches_bool          PIC 9(1).
       01 str_left           PIC 9(3).
       

       PROCEDURE DIVISION USING pattern str matches_bool str_left.
           
           COMPUTE pattern_len = FUNCTION STORED-CHAR-LENGTH(pattern).
           COMPUTE str_len = FUNCTION STORED-CHAR-LENGTH(str).
           
           MOVE pattern(1:1) TO one_pattern.
           MOVE str(1:1) TO one_str.
           CALL "trex_matchOne" USING BY REFERENCE one_pattern one_str 
               one_matches_bool.
      D    display "Star! Pattern: " function TRIM(pattern)
      D        " Str: " function TRIM(str) " first match: " 
      D        one_matches_bool.
           
           IF one_matches_bool=1 then
      *        Test rest of the input with the same expression, as the *
      *        means that the same character can appear again.
               MOVE pattern TO two_pattern
               MOVE str(2:str_len) TO two_str
               CALL "trex_match" USING BY REFERENCE two_pattern two_str 
                   two_matches_bool str_left
               MOVE two_matches_bool TO matches_bool
           ELSE 
               MOVE pattern(3:pattern_len) TO thr_pattern
               MOVE str TO thr_str
               CALL "trex_match" USING BY REFERENCE thr_pattern thr_str 
                   thr_matches_bool str_left
               MOVE thr_matches_bool TO matches_bool
           END-IF
           
           GOBACK.
       