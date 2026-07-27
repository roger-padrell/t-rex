       identification division.
       program-id. test_search.
       author. Roger Padrell.


       environment division.

       data division.

       WORKING-STORAGE SECTION.
       01 pattern               PIC X(256) VALUE SPACES.
       01 str                   PIC x(256).
       01 matches_bl          PIC 9(1).
       01 str_from           PIC 9(3).
       01 str_to           PIC 9(3).


       LINKAGE SECTION.       

       PROCEDURE DIVISION.
      *    Testing ^
           MOVE "^abc" TO pattern.
           MOVE "abc" TO str.
           CALL "trex_search" USING BY REFERENCE pattern str matches_bl
                   str_from str_to.
           display "Input: '" FUNCTION TRIM(pattern) "', '" 
               FUNCTION TRIM(str) "'".
           display "Output: " matches_bl.
           display "Expected: 1".
           display "  "
           display "---------------------------------"
           MOVE "^abcd" TO pattern.
           MOVE "abcd" TO str.
           CALL "trex_search" USING BY REFERENCE pattern str matches_bl
               str_from str_to.
           display "Input: '" FUNCTION TRIM(pattern) "', '" 
               FUNCTION TRIM(str) "'".
           display "Output: " matches_bl.
           display "Expected: 1".
           display "  "
           display "---------------------------------"
      
      *    Testing order
           MOVE "bc" TO pattern.
           MOVE "abcd" TO str.
           CALL "trex_search" USING BY REFERENCE pattern str matches_bl
               str_from str_to.
           display "Input: '" FUNCTION TRIM(pattern) "', '" 
               FUNCTION TRIM(str) "'".
           display "Output: " matches_bl.
           display "Expected: 1".
           display "  "
           display "---------------------------------"
           MOVE "cb" TO pattern.
           MOVE "abcd" TO str.
           CALL "trex_search" USING BY REFERENCE pattern str matches_bl
               str_from str_to.
           display "Input: '" FUNCTION TRIM(pattern) "', '" 
               FUNCTION TRIM(str) "'".
           display "Output: " matches_bl.
           display "Expected: 0".
           display "  "
           display "---------------------------------"
      
      *    Testing \?
           MOVE "ab?c" TO pattern.
           MOVE "ac" TO str.
           CALL "trex_search" USING BY REFERENCE pattern str matches_bl
               str_from str_to.
           display "Input: '" FUNCTION TRIM(pattern) "', '" 
               FUNCTION TRIM(str) "'".
           display "Output: " matches_bl.
           display "Expected: 1".
           display "  "
           display "---------------------------------"
           MOVE "ab?c" TO pattern.
           MOVE "abc" TO str.
           CALL "trex_search" USING BY REFERENCE pattern str matches_bl
               str_from str_to.
           display "Input: '" FUNCTION TRIM(pattern) "', '" 
               FUNCTION TRIM(str) "'".
           display "Output: " matches_bl.
           display "Expected: 1".
           display "  "
           display "---------------------------------"
           MOVE "a?b?c?" TO pattern.
           MOVE "abc" TO str.
           CALL "trex_search" USING BY REFERENCE pattern str matches_bl
               str_from str_to.
           display "Input: '" FUNCTION TRIM(pattern) "', '" 
               FUNCTION TRIM(str) "'".
           display "Output: " matches_bl.
           display "Expected: 1".
           display "  "
           display "---------------------------------"
           MOVE "a?b?c?" TO pattern.
           MOVE " " TO str.
           CALL "trex_search" USING BY REFERENCE pattern str matches_bl
               str_from str_to.
           display "Input: '" FUNCTION TRIM(pattern) "', '" 
               FUNCTION TRIM(str) "'".
           display "Output: " matches_bl.
           display "Expected: 1".
           display "  "
           display "---------------------------------"
           MOVE "ab?c" TO pattern.
           MOVE "ab" TO str.
           CALL "trex_search" USING BY REFERENCE pattern str matches_bl
               str_from str_to.
           display "Input: '" FUNCTION TRIM(pattern) "', '" 
               FUNCTION TRIM(str) "'".
           display "Output: " matches_bl.
           display "Expected: 0".

      *    Testing \*
           MOVE "a*" TO pattern.
           MOVE " " TO str.
           CALL "trex_search" USING BY REFERENCE pattern str matches_bl
               str_from str_to.
           display "Input: '" FUNCTION TRIM(pattern) "', '" 
               FUNCTION TRIM(str) "'".
           display "Output: " matches_bl.
           display "Expected: 1".
           display "  "
           display "---------------------------------"
           MOVE "a*" TO pattern.
           MOVE "aaaaaaaa" TO str.
           CALL "trex_search" USING BY REFERENCE pattern str matches_bl
               str_from str_to.
           display "Input: '" FUNCTION TRIM(pattern) "', '" 
               FUNCTION TRIM(str) "'".
           display "Output: " matches_bl.
           display "Expected: 1".
           display "  "
           display "---------------------------------"
           MOVE "a*b" TO pattern.
           MOVE "aaaaaab" TO str.
           CALL "trex_search" USING BY REFERENCE pattern str matches_bl
               str_from str_to.
           display "Input: '" FUNCTION TRIM(pattern) "', '" 
               FUNCTION TRIM(str) "'".
           display "Output: " matches_bl.
           display "Expected: 1".
           display "  "
           display "---------------------------------"
           MOVE "^a*b$" TO pattern.
           MOVE "abbb" TO str.
           CALL "trex_search" USING BY REFERENCE pattern str matches_bl
               str_from str_to.
           display "Input: '" FUNCTION TRIM(pattern) "', '" 
               FUNCTION TRIM(str) "'".
           display "Output: " matches_bl.
           display "Expected: 0".
           display "  "
           display "---------------------------------"
           MOVE "^a*b$" TO pattern.
           MOVE "bbbb" TO str.
           CALL "trex_search" USING BY REFERENCE pattern str matches_bl
               str_from str_to.
           display "Input: '" FUNCTION TRIM(pattern) "', '" 
               FUNCTION TRIM(str) "'".
           display "Output: " matches_bl.
           display "Expected: 0".
           display "  "
           display "---------------------------------"

           MOVE "a+" TO pattern.
           MOVE "aaa" TO str.
           CALL "trex_search" USING BY REFERENCE pattern str matches_bl
               str_from str_to.
           display "Input: '" FUNCTION TRIM(pattern) "', '" 
               FUNCTION TRIM(str) "'".
           display "Output: " matches_bl.
           display "Expected: 1".
           display "  "
           display "---------------------------------"
           MOVE "a+" TO pattern.
           MOVE " " TO str.
           CALL "trex_search" USING BY REFERENCE pattern str matches_bl
               str_from str_to.
           display "Input: '" FUNCTION TRIM(pattern) "', '" 
               FUNCTION TRIM(str) "'".
           display "Output: " matches_bl.
           display "Expected: 0".
           display "  "
           display "---------------------------------"
           MOVE "a+" TO pattern.
           MOVE "aaa" TO str.
           CALL "trex_search" USING BY REFERENCE pattern str matches_bl
               str_from str_to.
           display "Input: '" FUNCTION TRIM(pattern) "', '" 
               FUNCTION TRIM(str) "'".
           display "Output: " matches_bl.
           display "Expected: 1".
           display "  "
           display "---------------------------------"

           MOVE "a{2,4}" TO pattern.
           MOVE "aaa" TO str.
           CALL "trex_search" USING BY REFERENCE pattern str matches_bl
               str_from str_to.
           display "Input: '" FUNCTION TRIM(pattern) "', '" 
               FUNCTION TRIM(str) "'".
           display "Output: " matches_bl.
           display "Expected: 1".
           display "  "
           display "---------------------------------"
           MOVE "a{2,4}" TO pattern.
           MOVE "aa" TO str.
           CALL "trex_search" USING BY REFERENCE pattern str matches_bl
               str_from str_to.
           display "Input: '" FUNCTION TRIM(pattern) "', '" 
               FUNCTION TRIM(str) "'".
           display "Output: " matches_bl.
           display "Expected: 1".
           display "  "
           display "---------------------------------"
           MOVE "a{2,4}" TO pattern.
           MOVE "aaaa" TO str.
           CALL "trex_search" USING BY REFERENCE pattern str matches_bl
               str_from str_to.
           display "Input: '" FUNCTION TRIM(pattern) "', '" 
               FUNCTION TRIM(str) "'".
           display "Output: " matches_bl.
           display "Expected: 1".
           display "  "
           display "---------------------------------"
           MOVE "a{2,4}" TO pattern.
           MOVE "a" TO str.
           CALL "trex_search" USING BY REFERENCE pattern str matches_bl
               str_from str_to.
           display "Input: '" FUNCTION TRIM(pattern) "', '" 
               FUNCTION TRIM(str) "'".
           display "Output: " matches_bl.
           display "Expected: 0".
           display "  "
           display "---------------------------------"
           MOVE "a{2,4}" TO pattern.
           MOVE "aaaaa" TO str.
           CALL "trex_search" USING BY REFERENCE pattern str matches_bl
               str_from str_to.
           display "Input: '" FUNCTION TRIM(pattern) "', '" 
               FUNCTION TRIM(str) "'".
           display "Output: " matches_bl.
           display "Expected: 1".
           display "  "
           display "---------------------------------"
           MOVE "^a{2,4}$" TO pattern.
           MOVE "aaaaa" TO str.
           CALL "trex_search" USING BY REFERENCE pattern str matches_bl
               str_from str_to.
           display "Input: '" FUNCTION TRIM(pattern) "', '" 
               FUNCTION TRIM(str) "'".
           display "Output: " matches_bl.
           display "Expected: 0".
           display "  "
           display "---------------------------------"
           MOVE "a{2,4}" TO pattern.
           MOVE " " TO str.
           CALL "trex_search" USING BY REFERENCE pattern str matches_bl
               str_from str_to.
           display "Input: '" FUNCTION TRIM(pattern) "', '" 
               FUNCTION TRIM(str) "'".
           display "Output: " matches_bl.
           display "Expected: 0".
           display "  "
           display "---------------------------------"
           MOVE "a{10,11}" TO pattern.
           MOVE "aaaaaaaaaa" TO str.
           CALL "trex_search" USING BY REFERENCE pattern str matches_bl
               str_from str_to.
           display "Input: '" FUNCTION TRIM(pattern) "', '" 
               FUNCTION TRIM(str) "'".
           display "Output: " matches_bl.
           display "Expected: 1".
           display "  "
           display "---------------------------------"

           MOVE "\\a" TO pattern.
           MOVE "\a" TO str.
           CALL "trex_search" USING BY REFERENCE pattern str matches_bl
               str_from str_to.
           display "Input: '" FUNCTION TRIM(pattern) "', '" 
               FUNCTION TRIM(str) "'".
           display "Output: " matches_bl.
           display "Expected: 1".
           display "  "
           display "---------------------------------"
           MOVE "\d" TO pattern.
           MOVE "2" TO str.
           CALL "trex_search" USING BY REFERENCE pattern str matches_bl
               str_from str_to.
           display "Input: '" FUNCTION TRIM(pattern) "', '" 
               FUNCTION TRIM(str) "'".
           display "Output: " matches_bl.
           display "Expected: 1".
           display "  "
           display "---------------------------------"
           MOVE "\D" TO pattern.
           MOVE "2" TO str.
           CALL "trex_search" USING BY REFERENCE pattern str matches_bl
               str_from str_to.
           display "Input: '" FUNCTION TRIM(pattern) "', '" 
               FUNCTION TRIM(str) "'".
           display "Output: " matches_bl.
           display "Expected: 0".
           display "  "
           display "---------------------------------"
           MOVE "\w" TO pattern.
           MOVE "a" TO str.
           CALL "trex_search" USING BY REFERENCE pattern str matches_bl
               str_from str_to.
           display "Input: '" FUNCTION TRIM(pattern) "', '" 
               FUNCTION TRIM(str) "'".
           display "Output: " matches_bl.
           display "Expected: 1".
           display "  "
           display "---------------------------------"
           MOVE "\w" TO pattern.
           MOVE "_" TO str.
           CALL "trex_search" USING BY REFERENCE pattern str matches_bl
               str_from str_to.
           display "Input: '" FUNCTION TRIM(pattern) "', '" 
               FUNCTION TRIM(str) "'".
           display "Output: " matches_bl.
           display "Expected: 1".
           display "  "
           display "---------------------------------"
           MOVE "\W" TO pattern.
           MOVE "!" TO str.
           CALL "trex_search" USING BY REFERENCE pattern str matches_bl
               str_from str_to.
           display "Input: '" FUNCTION TRIM(pattern) "', '" 
               FUNCTION TRIM(str) "'".
           display "Output: " matches_bl.
           display "Expected: 1".
           display "  "
           display "---------------------------------"
       
           STOP RUN.
       