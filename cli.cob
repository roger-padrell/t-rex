       identification division.
       program-id. cli.
       author. Roger Padrell.


       environment division.

       data division.

       WORKING-STORAGE SECTION.
       01 ptrn               PIC X(256) VALUE SPACES.
       01 str                   PIC x(256).
       01 matches_bl          PIC 9(1).


       LINKAGE SECTION.       

       PROCEDURE DIVISION.
           DISPLAY "  #######     ######  ####### #     # "
           DISPLAY "     #        #     # #        #   #  "
           DISPLAY "     #        #     # #         # #   "
           DISPLAY "     #  ##### ######  #####      #    "
           DISPLAY "     #        #   #   #         # #   "
           DISPLAY "     #        #    #  #        #   #  "
           DISPLAY "     #        #     # ####### #     # "
                                          
           DISPLAY "Enter an expression (or q to quit): ".
           accept ptrn.
           perform until ptrn = "q" or str = "q"
               display "Enter string to test (q to quit, c to change"
               " expression)"
               accept str
               perform until str = "q" or str = "c"
                   CALL "trex_search" USING BY REFERENCE ptrn 
                       str matches_bl
                   display "Match (1=yes)?: " matches_bl
                   display " "
                   display "Enter string to test (q to quit, c to"
                       " change expression)"
                   accept str
               end-perform
               display " "
               display " "
               DISPLAY "Enter an expression (or q to quit): "
               accept ptrn
           end-perform.
           
           stop run.
