       IDENTIFICATION DIVISION.
       PROGRAM-ID. TEXTADVENTURE.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT ROOMFILE ASSIGN TO 'ROOMS.DAT'
               oRGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
       FD  ROOMFILE.
       01  ROOMRECORD.
           05  R-ID          PIC 9(3).
           05  R-TITLE       PIC X(30).
           05  R-DESC        PIC X(80).
           05  R-NORTH       PIC 9(3).
           05  R-SOUTH       PIC 9(3).
           05  R-EAST        PIC 9(3).
           05  R-WEST        PIC 9(3).

       WORKING-STORAGE SECTION.
       01  WS-CURRENT-ROOM   PIC 9(3) VALUE 1. 
       01  WS-EOF            PIC X    VALUE 'N'.
       01  WS-COMMAND        PIC X(10).
       01  WS-FOUND          PIC X    VALUE 'N'.

       01  WS-DISPLAY-TITLE  PIC X(30).  
       01  WS-DISPLAY-DESC   PIC X(80).
       01  WS-NORTH          PIC 9(3).
       01  WS-SOUTH          PIC 9(3).
       01  WS-EAST           PIC 9(3).
       01  WS-WEST           PIC 9(3).

       PROCEDURE DIVISION.
       MAIN-GAME-LOOP.
           PERFORM INITIALIZE-GAME

           PERFORM UNTIL WS-COMMAND = 'QUIT'
               PERFORM DISPLAY-ROOM
               PERFORM GET-COMMAND
               PERFORM PROCESS-COMMAND
           END-PERFORM

           DISPLAY "Thanks for playing!"
           STOP RUN.

           INITIALIZE-GAME.
               DISPLAY "=== COBOL Text Adventure ==="
               MOVE 1 TO WS-CURRENT-ROOM.


           DISPLAY-ROOM.
               MOVE 'N' TO WS-FOUND
               OPEN INPUT ROOMFILE
               PERFORM UNTIL WS-Found = 'Y' OR WS-EOF = 'Y'
                   READ ROOMFILE INTO ROOMRECORD
                       AT END 
                           MOVE 'Y' TO WS-EOF
                       NOT AT END
                           IF R-ID = WS-CURRENT-ROOM
                               MOVE R-TITLE TO WS-DISPLAY-TITLE
                               MOVE R-DESC TO WS-DISPLAY-DESC
                               MOVE R-NORTH TO WS-NORTH
                               MOVE R-SOUTH TO WS-SOUTH
                               MOVE R-EAST TO WS-EAST
                               MOVE R-WEST TO WS-WEST
                               MOVE 'Y' TO WS-FOUND
                           END-IF
                   END-READ    
               END-PERFORM
               CLOSE ROOMFILE
               MOVE 'N' TO WS-EOF

               IF WS-FOUND = 'Y'
                   DISPLAY "----------------------------------------"
                   DISPLAY "Location: " FUNCTION TRIM(WS-DISPLAY-TITLE)
                   DISPLAY "----------------------------------------"
                   DISPLAY FUNCTION TRIM(WS-DISPLAY-DESC)
                   DISPLAY "----------------------------------------"
               ELSE
                   DISPLAY "Error: Room not found!"
               END-IF.