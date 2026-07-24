       identification division.
       program-id. trex_matchOneEl.
       author. Roger Padrell.


       environment division.
       configuration section.
       special-names.
           class lowerCase IS "a" thru "z".
           class upperCase IS "A" thru "Z".
           class anyNumber IS "0" thru "9".

       data division.

       WORKING-STORAGE SECTION.
       01 pattern_len           PIC 9(3).
       01 str_len           PIC 9(3).


       LINKAGE SECTION.
       01 pattern               PIC X(256) VALUE SPACES.
       01 str                   PIC x(256).
       01 matches_bool          PIC 9(1).
       

       PROCEDURE DIVISION USING pattern str matches_bool.
           EVALUATE TRUE
               WHEN FUNCTION TRIM(pattern) = "(a-z)"
                   IF FUNCTION TRIM(str) is lowerCase THEN
      D                DISPLAY FUNCTION TRIM (str) " is lowercase a-z"
                       MOVE 1 TO matches_bool
                   ELSE
                       MOVE 0 TO matches_bool
                   END-IF
               WHEN FUNCTION TRIM(pattern) = "(A-Z)"
                   IF FUNCTION TRIM(str) is upperCase THEN
      D                DISPLAY FUNCTION TRIM (str) " is uppercase A-Z"
                       MOVE 1 TO matches_bool 
                   ELSE
                       MOVE 0 TO matches_bool
                   END-IF
               WHEN FUNCTION TRIM(pattern) = "(0-9)"
                   IF FUNCTION TRIM(str) is anyNumber THEN
      D                DISPLAY FUNCTION TRIM (str) " is number 0-9"
                       MOVE 1 TO matches_bool
                   ELSE
                       MOVE 0 TO matches_bool 
                   END-IF
               WHEN FUNCTION TRIM(pattern) = "(a-Z)"
                   IF FUNCTION TRIM(str) is upperCase OR
                    FUNCTION TRIM(str) is lowerCase THEN
      D               DISPLAY FUNCTION TRIM (str) " is upper/lower a-Z"
                      MOVE 1 TO matches_bool
                   ELSE
                       MOVE 0 TO matches_bool
                   END-IF
      D        WHEN OTHER
      D           display "Pattern " FUNCTION TRIM(pattern)
      D                 "not understood"
           END-EVALUATE.
           GOBACK.
       