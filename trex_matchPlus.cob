       identification division.
       program-id. trex_matchPlus recursive.
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
           
           CALL "trex_getFirstEl" USING BY REFERENCE pattern firstEl
               newPattern.
           MOVE firstEl TO one_pattern.
           MOVE str(1:1) TO one_str.
           CALL "trex_matchOne" USING BY REFERENCE one_pattern one_str 
               one_matches_bool.
           
           IF one_matches_bool=1 then
      *        Change the '+' in the pattern for a *
               STRING 
                   firstEl delimited by space
                   "*" delimited by size
                   newPattern(2:pattern_len) DELIMITED BY SPACE
                   INTO two_pattern
               END-STRING

               MOVE str(2:str_len) TO two_str
               CALL "trex_match" USING BY REFERENCE two_pattern two_str 
                   two_matches_bool str_left
               MOVE two_matches_bool TO matches_bool
           ELSE 
               MOVE 0 TO matches_bool
           END-IF
           
           GOBACK.
       