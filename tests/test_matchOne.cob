       identification division.
       program-id. test_matchOne.
       author. Roger Padrell.


       environment division.

       data division.

       WORKING-STORAGE SECTION.
       01 ptrn               PIC X(256) VALUE SPACES.
       01 str                   PIC x(256).
       01 matches_bl          PIC 9(1).


       LINKAGE SECTION.       

       PROCEDURE DIVISION.
           MOVE "a" TO ptrn.
           MOVE "a" TO str.
           CALL "trex_matchOne" USING BY REFERENCE ptrn str matches_bl.
           display "Input: '" FUNCTION TRIM(ptrn) "', '" 
               FUNCTION TRIM(str) "'".
           display "Output: " matches_bl.
           display "Expected: 1".
           
           MOVE "." TO ptrn.
           MOVE "z" TO str.
           CALL "trex_matchOne" USING BY REFERENCE ptrn str matches_bl.
           display "Input: '" FUNCTION TRIM(ptrn) "', '" 
               FUNCTION TRIM(str) "'".
           display "Output: " matches_bl.
           display "Expected: 1".

           MOVE " " TO ptrn.
           MOVE "h" TO str.
           CALL "trex_matchOne" USING BY REFERENCE ptrn str matches_bl.
           display "Input: '" FUNCTION TRIM(ptrn) "', '" 
               FUNCTION TRIM(str) "'".
           display "Output: " matches_bl.
           display "Expected: 0".

           MOVE "a" TO ptrn.
           MOVE "b" TO str.
           CALL "trex_matchOne" USING BY REFERENCE ptrn str matches_bl.
           display "Input: '" FUNCTION TRIM(ptrn) "', '" 
               FUNCTION TRIM(str) "'".
           display "Output: " matches_bl.
           display "Expected: 0".

           MOVE "p" TO ptrn.
           MOVE " " TO str.
           CALL "trex_matchOne" USING BY REFERENCE ptrn str matches_bl.
           display "Input: '" FUNCTION TRIM(ptrn) "', '" 
               FUNCTION TRIM(str) "'".
           display "Output: " matches_bl.
           display "Expected: 0".

           STOP RUN.
       