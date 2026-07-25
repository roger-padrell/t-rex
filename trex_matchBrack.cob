       identification division.
       program-id. trex_matchBrack recursive.
       author. Roger Padrell.


       environment division.

       data division.

       WORKING-STORAGE SECTION.
       01 pattern_len               PIC 9(3).
       01 str_len                   PIC 9(3).

       01 firstChar                 PIC X(1) VALUE SPACE.
       01 loopIndex                 PIC 9(3).
       01 count_pattern             PIC X(256) VALUE SPACES.
       01 min_match                 PIC 9(3).
       01 max_match                 PIC 9(3).
       01 min_as_str                PIC X(256) VALUE SPACES.
       01 max_as_str                PIC X(256) VALUE SPACES.
       

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
       01 secEl               PIC X(256) VALUE SPACES.
       01 newPattern            PIC X(256) VALUE SPACES.


       LINKAGE SECTION.
       01 pattern               PIC X(256) VALUE SPACES.
       01 str                   PIC x(256).
       01 matches_bool          PIC 9(1).
       01 str_left           PIC 9(3).
       

       PROCEDURE DIVISION USING pattern str matches_bool str_left.
      D    display "Matched {range}: " pattern.
      *    Get the digits for min and max
           UNSTRING pattern 
               DELIMITED BY "," 
               INTO min_as_str, max_as_str 
           END-UNSTRING.
           COMPUTE min_match = FUNCTION STORED-CHAR-LENGTH(min_as_str).
           MOVE min_as_str(3:min_match - 1) TO min_as_str.
           COMPUTE min_match = FUNCTION NUMVAL(min_as_str).
           
           COMPUTE max_match = FUNCTION STORED-CHAR-LENGTH(max_as_str).
           MOVE max_as_str(1:max_match - 1) TO max_as_str.
           COMPUTE max_match = FUNCTION NUMVAL(max_as_str).
      D    DISPLAY "Min: " min_match ", max: " max_match.
      D    display "For string: " FUNCTION TRIM(str).
           
                          
           CALL "trex_getFirstEl" USING BY REFERENCE pattern firstEl
               newPattern
           CALL "trex_getFirstEl" USING BY REFERENCE newPattern 
                   secEl thr_pattern

      *    Initial checks
           IF max_match = 0 THEN
               MOVE str TO thr_str
               CALL "trex_match" USING BY REFERENCE thr_pattern 
               thr_str thr_matches_bool str_left
               MOVE thr_matches_bool TO matches_bool
      D        display "Max is 0"
      D        display "Result: " thr_matches_bool
      D        display "New pat: " thr_pattern
           ELSE
               COMPUTE pattern_len = 
                   FUNCTION STORED-CHAR-LENGTH(pattern)
               COMPUTE str_len = FUNCTION STORED-CHAR-LENGTH(str)

               MOVE firstEl TO one_pattern
               MOVE str(1:1) TO one_str
               CALL "trex_matchOne" USING BY REFERENCE one_pattern 
               one_str one_matches_bool
      D        display "Star! Pattern: " function TRIM(pattern)
      D            " Str: " function TRIM(str) " first match: " 
      D            one_matches_bool
               
               IF one_matches_bool=1 then
      *        Test rest of the input with the same expression, as the *
      *        means that the same character can appear again.
                   if min_match = 1 OR min_match = 0 then
                       MOVE 0 TO min_match
                   else
                       COMPUTE min_match = min_match - 1
                   end-if
                   if max_match = 1 OR max_match = 0 then
                       MOVE 0 TO max_match
                   else
                       COMPUTE max_match = max_match - 1
                   end-if
                   move min_match to min_as_str
                   move max_match to max_as_str
                   STRING 
                       firstEl delimited by space
                       "{" delimited by size
                       FUNCTION TRIM(min_as_str) delimited by size
                       "," delimited by size
                       FUNCTION TRIM(max_as_str) delimited by size
                       "}" delimited by size
                       thr_pattern DELIMITED BY SPACE
                       INTO two_pattern
                   END-STRING
                   MOVE str(2:str_len) TO two_str
                   CALL "trex_match" USING BY REFERENCE two_pattern 
                   two_str two_matches_bool str_left
                   MOVE two_matches_bool TO matches_bool
               ELSE
                   IF min_match = 0 THEN
                       MOVE str TO thr_str
                       CALL "trex_match" USING BY REFERENCE thr_pattern 
                       thr_str thr_matches_bool str_left
                       MOVE thr_matches_bool TO matches_bool
                   ELSE
                       MOVE 0 TO matches_bool
                   END-IF
               END-IF
           END-IF.
           GOBACK.
       