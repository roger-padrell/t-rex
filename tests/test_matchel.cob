       identification division.
       program-id. test_matchel.
       author. Roger Padrell.


       environment division.

       data division.

       WORKING-STORAGE SECTION.
       01 pattern               PIC X(256) VALUE SPACES.
       01 str                   PIC x(256).
       01 matches_bool          PIC 9(1).
       01 str_left              PIC 9(3).


       LINKAGE SECTION.       

       PROCEDURE DIVISION.
           MOVE "[a-z]" TO pattern.
           MOVE "b" TO str.
           CALL "trex_match" USING BY REFERENCE pattern str 
               matches_bool str_left.
           display "Input: '" FUNCTION TRIM(pattern) "', '" 
               FUNCTION TRIM(str) "'".
           display "Output: " matches_bool.
           display "Expected: 1".
           display "  "
           display "---------------------------------"
           MOVE "[a-z]" TO pattern.
           MOVE "2" TO str.
           CALL "trex_match" USING BY REFERENCE pattern str
               matches_bool str_left.
           display "Input: '" FUNCTION TRIM(pattern) "', '" 
               FUNCTION TRIM(str) "'".
           display "Output: " matches_bool.
           display "Expected: 0".
           display "  "
           display "---------------------------------"

           MOVE "[A-Z]" TO pattern.
           MOVE "C" TO str.
           CALL "trex_match" USING BY REFERENCE pattern str 
               matches_bool str_left.
           display "Input: '" FUNCTION TRIM(pattern) "', '" 
               FUNCTION TRIM(str) "'".
           display "Output: " matches_bool.
           display "Expected: 1".
           display "  "
           display "---------------------------------"
           MOVE "[A-Z]" TO pattern.
           MOVE "d" TO str.
           CALL "trex_match" USING BY REFERENCE pattern str
               matches_bool str_left.
           display "Input: '" FUNCTION TRIM(pattern) "', '" 
               FUNCTION TRIM(str) "'".
           display "Output: " matches_bool.
           display "Expected: 0".
           display "  "
           display "---------------------------------"

           MOVE "[0-9]" TO pattern.
           MOVE "3" TO str.
           CALL "trex_match" USING BY REFERENCE pattern str 
               matches_bool str_left.
           display "Input: '" FUNCTION TRIM(pattern) "', '" 
               FUNCTION TRIM(str) "'".
           display "Output: " matches_bool.
           display "Expected: 1".
           display "  "
           display "---------------------------------"
           MOVE "[0-9]" TO pattern.
           MOVE "f" TO str.
           CALL "trex_match" USING BY REFERENCE pattern str
               matches_bool str_left.
           display "Input: '" FUNCTION TRIM(pattern) "', '" 
               FUNCTION TRIM(str) "'".
           display "Output: " matches_bool.
           display "Expected: 0".
           display "  "
           display "---------------------------------"

           MOVE "[a-zA-Z]" TO pattern.
           MOVE "b" TO str.
           CALL "trex_match" USING BY REFERENCE pattern str 
               matches_bool str_left.
           display "Input: '" FUNCTION TRIM(pattern) "', '" 
               FUNCTION TRIM(str) "'".
           display "Output: " matches_bool.
           display "Expected: 1".
           display "  "
           display "---------------------------------"
           MOVE "[a-zA-Z]" TO pattern.
           MOVE "D" TO str.
           CALL "trex_match" USING BY REFERENCE pattern str 
               matches_bool str_left.
           display "Input: '" FUNCTION TRIM(pattern) "', '" 
               FUNCTION TRIM(str) "'".
           display "Output: " matches_bool.
           display "Expected: 1".
           display "  "
           display "---------------------------------"
           MOVE "[a-Z]" TO pattern.
           MOVE "C" TO str.
           CALL "trex_match" USING BY REFERENCE pattern str
               matches_bool str_left.
           display "Input: '" FUNCTION TRIM(pattern) "', '" 
               FUNCTION TRIM(str) "'".
           display "Output: " matches_bool.
           display "Expected: 1".
           display "  "
           display "---------------------------------"
           MOVE "[a-Z]" TO pattern.
           MOVE "2" TO str.
           CALL "trex_match" USING BY REFERENCE pattern str
               matches_bool str_left.
           display "Input: '" FUNCTION TRIM(pattern) "', '" 
               FUNCTION TRIM(str) "'".
           display "Output: " matches_bool.
           display "Expected: 0".
           display "  "
           display "---------------------------------"

           MOVE "[^a-z]" TO pattern.
           MOVE "b" TO str.
           CALL "trex_match" USING BY REFERENCE pattern str 
               matches_bool str_left.
           display "Input: '" FUNCTION TRIM(pattern) "', '" 
               FUNCTION TRIM(str) "'".
           display "Output: " matches_bool.
           display "Expected: 0".
           display "  "
           display "---------------------------------"
           MOVE "[^a-Z]" TO pattern.
           MOVE "2" TO str.
           CALL "trex_match" USING BY REFERENCE pattern str 
               matches_bool str_left.
           display "Input: '" FUNCTION TRIM(pattern) "', '" 
               FUNCTION TRIM(str) "'".
           display "Output: " matches_bool.
           display "Expected: 1".
           display "  "
           display "---------------------------------"

           STOP RUN.
       