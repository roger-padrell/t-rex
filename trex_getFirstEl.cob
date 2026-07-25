       identification division.
       program-id. trex_getFirstEl recursive.
       author. Roger Padrell.


       environment division.

       data division.

       WORKING-STORAGE SECTION.
       01 firstChar             PIC X(1) VALUE SPACE.
       01 patternLen            PIC 9(3).
       01 loopIndex             PIC 9(3).


       LINKAGE SECTION.
       01 pattern               PIC X(256) VALUE SPACES.
       01 firstEl               PIC X(256) VALUE SPACES.
       01 newPattern            PIC X(256) VALUE SPACES.
       

       PROCEDURE DIVISION USING pattern firstEl newPattern.
           COMPUTE patternLen = FUNCTION STORED-CHAR-LENGTH(pattern).
           MOVE pattern(1:1) TO firstChar.
           evaluate firstChar
           WHEN "["
               MOVE " " TO firstEl
               PERFORM VARYING loopIndex FROM 1 BY 1 UNTIL 
                   firstChar = "]"
                   MOVE pattern(loopIndex:1) TO firstChar
                   STRING firstEl DELIMITED BY SPACES
                       firstChar DELIMITED BY SIZE
                       INTO firstEl
                   END-STRING
      D            display firstChar
               END-PERFORM
               MOVE pattern(loopIndex:patternLen) TO newPattern
           WHEN "{"
               MOVE " " TO firstEl
               PERFORM VARYING loopIndex FROM 1 BY 1 UNTIL 
                   firstChar = "}"
                   MOVE pattern(loopIndex:1) TO firstChar
                   STRING firstEl DELIMITED BY SPACES
                       firstChar DELIMITED BY SIZE
                       INTO firstEl
                   END-STRING
      D            display firstChar
               END-PERFORM
               MOVE pattern(loopIndex:patternLen) TO newPattern
           WHEN "("
               MOVE " " TO firstEl
               PERFORM VARYING loopIndex FROM 1 BY 1 UNTIL 
                   firstChar = ")"
                   MOVE pattern(loopIndex:1) TO firstChar
                   STRING firstEl DELIMITED BY SPACES
                       firstChar DELIMITED BY SIZE
                       INTO firstEl
                   END-STRING
      D            display firstChar
               END-PERFORM
               MOVE pattern(loopIndex:patternLen) TO newPattern
           WHEN OTHER
               MOVE firstChar TO firstEl
               MOVE pattern(2:patternLen) TO newPattern
           end-evaluate.

           GOBACK.
       