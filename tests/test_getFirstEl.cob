       identification division.
       program-id. test_getFirstEl.
       author. Roger Padrell.


       environment division.

       data division.

       WORKING-STORAGE SECTION.
       01 pattern               PIC X(256) VALUE SPACES.
       01 firstEl               PIC X(256) VALUE SPACES.
       01 newPattern            PIC X(256) VALUE SPACES.


       LINKAGE SECTION.       

       PROCEDURE DIVISION.
           MOVE "hello" TO pattern.
           CALL "trex_getFirstEl" USING BY REFERENCE pattern firstEl 
               newPattern.
           display "Input: '" FUNCTION TRIM(pattern) "'".
           display "Output: '" FUNCTION TRIM(firstEl) "','" 
               FUNCTION TRIM(newPattern) "'".
           display "Expected: 'h','ello'".
           MOVE newPattern TO pattern.

           CALL "trex_getFirstEl" USING BY REFERENCE pattern firstEl 
               newPattern.
           display "Input: '" FUNCTION TRIM(pattern) "'".
           display "Output: '" FUNCTION TRIM(firstEl) "','" 
               FUNCTION TRIM(newPattern) "'".
           display "Expected: 'e','llo'".
           MOVE newPattern TO pattern.

           CALL "trex_getFirstEl" USING BY REFERENCE pattern firstEl 
               newPattern.
           display "Input: '" FUNCTION TRIM(pattern) "'".
           display "Output: '" FUNCTION TRIM(firstEl) "','" 
               FUNCTION TRIM(newPattern) "'".
           display "Expected: 'l','lo'".
           MOVE newPattern TO pattern.

           CALL "trex_getFirstEl" USING BY REFERENCE pattern firstEl 
               newPattern.
           display "Input: '" FUNCTION TRIM(pattern) "'".
           display "Output: '" FUNCTION TRIM(firstEl) "','" 
               FUNCTION TRIM(newPattern) "'".
           display "Expected: 'l','o'".
           MOVE newPattern TO pattern.

           CALL "trex_getFirstEl" USING BY REFERENCE pattern firstEl 
               newPattern.
           display "Input: '" FUNCTION TRIM(pattern) "'".
           display "Output: '" FUNCTION TRIM(firstEl) "','" 
               FUNCTION TRIM(newPattern) "'".
           display "Expected: 'o',''".
           MOVE newPattern TO pattern.

           display " "
           display "----------------------------------"

           MOVE "[a-z]hello" TO pattern.
           CALL "trex_getFirstEl" USING BY REFERENCE pattern firstEl 
               newPattern.
           display "Input: '" FUNCTION TRIM(pattern) "'".
           display "Output: '" FUNCTION TRIM(firstEl) "','" 
               FUNCTION TRIM(newPattern) "'".
           display "Expected: '[a-z]','hello'".
           MOVE newPattern TO pattern.
           display " "
           display "----------------------------------"

           MOVE "{1,2,3}hello" TO pattern.
           CALL "trex_getFirstEl" USING BY REFERENCE pattern firstEl 
               newPattern.
           display "Input: '" FUNCTION TRIM(pattern) "'".
           display "Output: '" FUNCTION TRIM(firstEl) "','" 
               FUNCTION TRIM(newPattern) "'".
           display "Expected: '{1,2,3}','hello'".
           MOVE newPattern TO pattern.
           display " "
           display "----------------------------------"

           MOVE "(a-z)hello" TO pattern.
           CALL "trex_getFirstEl" USING BY REFERENCE pattern firstEl 
               newPattern.
           display "Input: '" FUNCTION TRIM(pattern) "'".
           display "Output: '" FUNCTION TRIM(firstEl) "','" 
               FUNCTION TRIM(newPattern) "'".
           display "Expected: '(a-z)','hello'".
           MOVE newPattern TO pattern.
           display " "
           display "----------------------------------"

           MOVE "\whello" TO pattern.
           CALL "trex_getFirstEl" USING BY REFERENCE pattern firstEl 
               newPattern.
           display "Input: '" FUNCTION TRIM(pattern) "'".
           display "Output: '" FUNCTION TRIM(firstEl) "','" 
               FUNCTION TRIM(newPattern) "'".
           display "Expected: '\w','hello'".
           MOVE newPattern TO pattern.
           display " "
           display "----------------------------------"

           MOVE "\\hello" TO pattern.
           CALL "trex_getFirstEl" USING BY REFERENCE pattern firstEl 
               newPattern.
           display "Input: '" FUNCTION TRIM(pattern) "'".
           display "Output: '" FUNCTION TRIM(firstEl) "','" 
               FUNCTION TRIM(newPattern) "'".
           display "Expected: '\\','hello'".
           MOVE newPattern TO pattern.
           display " "
           display "----------------------------------"

           STOP RUN.
       