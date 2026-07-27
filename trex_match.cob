       identification division.
       program-id. trex_match recursive.
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

       01 firstEl               PIC X(256) VALUE SPACES.
       01 newPattern            PIC X(256) VALUE SPACES.
       01 secondEl               PIC X(256) VALUE SPACES.
       01 secondPattern            PIC X(256) VALUE SPACES.


       LINKAGE SECTION.
       01 pattern               PIC X(256) VALUE SPACES.
       01 str                   PIC x(256).
       01 matches_bool          PIC 9(1).
       01 str_left           PIC 9(3).
       

       PROCEDURE DIVISION USING pattern str matches_bool str_left.
           COMPUTE pattern_len = FUNCTION STORED-CHAR-LENGTH(pattern).
           COMPUTE str_len = FUNCTION STORED-CHAR-LENGTH(str).
           CALL "trex_getFirstEl" USING BY REFERENCE pattern 
               firstEl newPattern.
           CALL "trex_getFirstEl" USING BY REFERENCE newPattern 
               secondEl secondPattern.
      D    display " "
      D    display "Pattern: " FUNCTION TRIM(pattern) " Str: " 
      D        FUNCTION TRIM(str).
           EVALUATE TRUE
               WHEN pattern = SPACES OR pattern_len = 0 
               or pattern = low-value
      D            display "Pattern blank"
                   MOVE 1 TO matches_bool
      D            display "String left (" str_len "): " 
      D                FUNCTION TRIM(str)
                   MOVE str_len TO str_left
               WHEN pattern = "$"
                   IF (str = SPACES OR str_len = 0) 
                       OR str = low-value THEN
                       MOVE 1 TO matches_bool
      D                display "Pattern $"
                   ELSE
                       MOVE 0 TO matches_bool
               WHEN FUNCTION TRIM(secondEl) = "?"
      D            display "Found '?'"
                   CALL "trex_matchQuestion" USING BY REFERENCE pattern 
                       str matches_bool str_left
               WHEN FUNCTION TRIM(secondEl) = "*"
      D            display "Found '*'"
                   CALL "trex_matchStar" USING BY REFERENCE pattern str
                       matches_bool str_left
               WHEN FUNCTION TRIM(secondEl) = "+"
      D            display "Found '+'"
                   CALL "trex_matchPlus" USING BY REFERENCE pattern str
                       matches_bool str_left
               WHEN FUNCTION TRIM(secondEl)(1:1) = "{"
      D            display "Found '{'"
                   CALL "trex_matchBrack" USING BY REFERENCE pattern str
                       matches_bool str_left
               WHEN FUNCTION TRIM(firstEl)(1:1) = "\"
      D            display "Found '\'"
                   CALL "trex_matchBackSlash" USING BY REFERENCE 
                       pattern str matches_bool str_left
               WHEN OTHER
                   MOVE firstEl TO one_pattern
                   MOVE str(1:1) TO one_str
                   CALL "trex_matchOne" USING BY REFERENCE one_pattern 
                       one_str one_matches_bool
      D            display "Same character(" FUNCTION TRIM(one_pattern)
      D             ", " FUNCTION TRIM(one_str) "): " one_matches_bool
                   
                   IF one_matches_bool=1 THEN
                       MOVE newPattern TO two_pattern
                       MOVE str(2:str_len) TO two_str
                       CALL "trex_match" USING BY REFERENCE two_pattern 
                       two_str two_matches_bool str_left
                       
      D                display "Same following: " two_matches_bool
                       IF two_matches_bool=1 then
                           MOVE 1 TO matches_bool
                       ELSE
                           MOVE 0 TO matches_bool
                       END-IF
                   ELSE
                       MOVE 0 TO matches_bool
                   END-IF
           END-EVALUATE.
           
           GOBACK.
       