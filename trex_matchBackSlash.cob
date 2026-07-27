       identification division.
       program-id. trex_matchBackSlash recursive.
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

       01 firstEl               PIC X(256) VALUE SPACES.
       01 newPattern            PIC X(256) VALUE SPACES.


       LINKAGE SECTION.
       01 pattern               PIC X(256) VALUE SPACES.
       01 str                   PIC x(256).
       01 matches_bool          PIC 9(1).
       01 str_left           PIC 9(3).
       

       PROCEDURE DIVISION USING pattern str matches_bool str_left.
           COMPUTE pattern_len = FUNCTION STORED-CHAR-LENGTH(pattern).
           COMPUTE str_len = FUNCTION STORED-CHAR-LENGTH(str).
      D    display "Called backslash: " FUNCTION TRIM(pattern) " - "
      D        FUNCTION TRIM(str).
           
           evaluate pattern(2:1)
                WHEN "d"
                   MOVE "[0-9]" TO one_pattern
                   MOVE str(1:1) TO one_str
                   CALL "trex_matchOneEl" USING BY REFERENCE one_pattern
                       one_str one_matches_bool
               WHEN "D"
                   MOVE "[^0-9]" TO one_pattern
                   MOVE str(1:1) TO one_str
                   CALL "trex_matchOneEl" USING BY REFERENCE one_pattern
                       one_str one_matches_bool
               WHEN "W"
                   MOVE "[^a-zA-Z0-9___]" TO one_pattern
                   MOVE str(1:1) TO one_str
                   CALL "trex_matchOneEl" USING BY REFERENCE one_pattern
                       one_str one_matches_bool
               WHEN "w"
                   MOVE "[a-zA-Z0-9___]" TO one_pattern
                   MOVE str(1:1) TO one_str
                   CALL "trex_matchOneEl" USING BY REFERENCE 
                       one_pattern one_str one_matches_bool
               WHEN other
                   IF pattern(2:1) = str(1:1) then
                       MOVE 1 TO one_matches_bool
                   ELSE
                       MOVE 0 TO one_matches_bool
                   END-IF
           end-evaluate.

           IF one_matches_bool = 1 THEN
               MOVE pattern(3:pattern_len) TO two_pattern
               MOVE str(2:str_len) TO two_str
               CALL "trex_match" USING BY REFERENCE two_pattern 
                   two_str matches_bool str_left
           ELSE
               move 0 to matches_bool
           END-IF.
           
           GOBACK.
       