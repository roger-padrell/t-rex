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
       01 str_len               PIC 9(3).

       01 patternLowCase        PIC 9(1) VALUE 0.
       01 patternUpCase         PIC 9(1) VALUE 0.
       01 patternNum            PIC 9(1) VALUE 0.
       01 loopLen               PIC 9(1).
       01 patternSlice          PIC X(3).

       01 patternNegate         PIC 9(1).
       01 startSliceFrom        PIC 9(1).


       LINKAGE SECTION.
       01 pattern               PIC X(256) VALUE SPACES.
       01 str                   PIC x(256).
       01 matches_bool          PIC 9(1).
       

       PROCEDURE DIVISION USING pattern str matches_bool.
           IF pattern(2:1) = "^" THEN
               MOVE 1 TO patternNegate
           ELSE
               MOVE 0 TO patternNegate
           END-IF.
           COMPUTE startSliceFrom = 2 + patternNegate.
      *    Check valid pattern types
           COMPUTE pattern_len = FUNCTION STORED-CHAR-LENGTH(pattern).
           MOVE 0 TO patternLowCase.
           MOVE 0 TO patternUpCase.
           MOVE 0 TO patternNum.
           PERFORM VARYING loopLen FROM startSliceFrom BY 3 UNTIL
               loopLen = pattern_len
               MOVE pattern(loopLen:3) TO patternSlice

               EVALUATE patternSlice
                   WHEN "a-z"
                       MOVE 1 TO patternLowCase
      D                display "Pattern is lowercase"
                   WHEN "A-Z"
                       MOVE 1 TO patternUpCase
      D                display "Pattern is uppercase"
                   WHEN "a-Z"
                       MOVE 1 TO patternLowCase
                       MOVE 1 TO patternUpCase
      D                display "Pattern is lower-upper"
                   WHEN "0-9"
                       MOVE 1 TO patternNum
      D                display "Patter is number"
      D            WHEN OTHER
      D                display "Pattern " FUNCTION TRIM(pattern)
      D                    "not understood"
               END-EVALUATE
           END-PERFORM.
EQUAL
      D    display "Lower: " patternLowCase " Upper: " patternUpCase
      D        " Num: " patternNum.

      *    Match pattern types and string values
           EVALUATE TRUE
               WHEN patternLowCase = 1 AND 
               FUNCTION TRIM(str) is lowerCase
      D            DISPLAY FUNCTION TRIM (str) " is lowercase a-z"
                   MOVE 1 TO matches_bool
               WHEN patternUpCase = 1 AND
               FUNCTION TRIM(str) is upperCase
      D            DISPLAY FUNCTION TRIM (str) " is uppercase A-Z"
                   MOVE 1 TO matches_bool
               WHEN patternNum = 1 AND
               FUNCTION TRIM(str) is anyNumber
      D            DISPLAY FUNCTION TRIM (str) " is number 0-9"
                   MOVE 1 TO matches_bool
               WHEN OTHER
                   MOVE 0 to matches_bool
           END-EVALUATE.

           IF patternNegate = 1 THEN
               COMPUTE matches_bool = 1 - matches_bool
           END-IF.
           GOBACK.
       