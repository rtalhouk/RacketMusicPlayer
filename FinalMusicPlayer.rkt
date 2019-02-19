;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname FinalMusicPlayer) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp")) #f)))
;; CS2500, MusicPlayer

(require 2htdp/image)
(require 2htdp/universe)
(require neu-fall18)
(require 2htdp/batch-io)

(define-struct song [bytes id title artist])
;A Song is a (make-song ByteString Nat String String)
;and hold the bytes, id number, title, and artist of a song from a server
;Ex:
(define SONG-1 (make-song "asdfasdf" 123 "Hello" "Me"))
(define SONG-2 (make-song " " 456 "Goodbye" "You"))
#;
(define (song-temp s)
  (... (song-bytes s) ... (song-id s) ... (song-title s) ... (song-artist s)))


; A FeedbackString is one of:
; - ""
; - "dislike"
; - "like"
; - "none"
; Interpretation: The feedback that the user gave to the last song played.  The string
; "none" represents that the user gave no feedback, and the string "" represents
; that no feedback has been received yet (i.e., we are playing the first song).
(define FEEDBACKSTRING-EMPTY "")
(define FEEDBACKSTRING-DISLIKE "dislike")
(define FEEDBACKSTRING-LIKE "like")
(define FEEDBACKSTRING-NONE "none")
; (define (feedbackstring-temp fs)
;   (cond
;     [(string=? fs FEEDBACKSTRING-EMPTY) ...]
;     [(string=? fs FEEDBACKSTRING-DISLIKE) ...]
;     [(string=? fs FEEDBACKSTRING-LIKE) ...]
;     [(string=? fs FEEDBACKSTRING-NONE) ...]))



; A Metadata is a (list String String Number String)
; - where the first String is the song's title or "Waiting for song"
; - the second String is the song's artist
; - the Number is the length of the song (in seconds)
; - and the third String is the song's album
(define METADATA-0 (list "Waiting for song" "" 0 ""))
(define METADATA-1 (list "Title" "Artist" 4 "Album"))
(define METADATA-2 (list "Title2" "Artist2" 120 "Album2"))
#;
(define (metadata-temp md)
  ...(first md)...(second md)...(third md)...(fourth md)...)

; A IDMetaPair is a (list Nat Metadata)
; - where the nat is the id of the song
; - and the metadata contains all of the metadata of the song
(define IDMP-1 (list 1 METADATA-1))
(define IDMP-2 (list 2 METADATA-2))

#;
(define (idmp-temp idmp)
  (cond
    [(empty? idmp) ...]
    [(cons? idmp) ... (first idmp)...(metadata-temp (second idmp))...]))


; An ErrorMsg is a (list "ERROR" String)
; where the second string is the message from the server about what went wrong
(define ERROR-1 (list "ERROR" "first example error"))
(define ERROR-2 (list "ERROR" "second example error"))
#;
(define (errormsg-temp er)
  ...(first er)...(rest er)...)

; A SongMsg is a (list "SONG" Nat Metadata String)
; - where the Nat is the song's unique ID#
; - the Metadata is information about the song
; - and the String is the actual byte-string of music

(define SONGMSG-1 (list "SONG" 1 METADATA-1 "bytes1"))
(define SONGMSG-2 (list "SONG" 2 METADATA-2 "bytes2"))
#;
(define (songmsg-temp sm)
  ...(first sm)...(second sm)...(metadata-temp (third sm))...(fourth sm)...)

; A MetadataMsg is a (list "METADATA" [List-of IDMetaPair])
; where the list contains all of the metadata and ids of the songs available on the server
(define METADATAMSG-1 (list "METADATA" (list IDMP-1 IDMP-2)))
#;
(define (metadatamsg-temp mdm)
  (cond
    [(empty? mdm)...]
    [(cons? mdm)...(first mdm)...(second mdm)...]))


; A ServerMsg is one of:
; - ErrorMsg
; - SongMsg
; - MetadataMsg
 
(define SERVERMSG-1 ERROR-1)
(define SERVERMSG-2 ERROR-2)
(define SERVERMSG-3 SONGMSG-1)
(define SERVERMSG-4 SONGMSG-2)
(define SERVERMSG-5 METADATAMSG-1)

#;
(define (servermsg-temp srm)
  (cond
    [(string=? (first srm) "ERROR") ...srm...]
    [(string=? (first srm) "SONG")...(songmsg-temp srm)...]))

; A State is one of
; - 0
; - "waiting"
; - Song
;Interpretation: the state of the program
;without valid song and no request sent
;without valid song and request sent without response
;with song and ready to play
(define STATE-STARTED 0)
(define STATE-WAITING "waiting")
(define STATE-READY SONG-1)
#;
(define (state-temp st)
  (cond
    [(number? st) ...]
    [(string? st) ...]
    [(song? st) ...]))

;A History is a (list String Number)
;and represents the title and ID of a song previously played
;Ex
(define HISTORY-1 (list "Cheese" 1))
(define HISTORY-2 (list "Matthew" 28))
#;
(define (hist-temp h)
  ((cons? h) ... (first h)... (second h)))

(define-struct player [state feedback history metadatamsg])
; A MusicPlayer a (make-player State FeedbackString [List-of History] [List-of IDMP])
; Interpretation: The state of the music player
; - state is the State of the program
; - feedback is the feedback received from the user for the last song played
; - history is a [List-of History] of all song played
; - metadatamsg is the initial [List-of IDMetaPair] received from the server's MetadataMsg
(define MUSICPLAYER-0
  (make-player STATE-STARTED "" (list (list "Hi" 123) (list "Bye" 233)) (second METADATAMSG-1)))
(define MUSICPLAYER-1
  (make-player STATE-WAITING "" '() (second METADATAMSG-1)))
(define MUSICPLAYER-2
  (make-player STATE-READY "dislike" (list (list "Yo" 34)) (second METADATAMSG-1)))
(define MUSICPLAYER-3
  (make-player STATE-READY "none" (list (list "Sup" 234)) (second METADATAMSG-1)))
#;
(define (musicplayer-temp mp)
  ...(state-temp (player-state mp))...
  ... (feedback-temp (player-feedback mp)) ...
  ... (loh-temp (player-history mp))...
  ...(loidmp-temp (player-metadatamsg mp))...)

; A ClientMsg is a Nat
; representing a request for a SongMsg with a specific ID#
(define CLIENTMSG 123)


; A Package is a (make-package MusicPlayer ClientMsg)
; - and dictacts the next state of the world as well as
; - the message sent from the client to the server
(define PACKAGE-1 (make-package MUSICPLAYER-0 CLIENTMSG))
(define PACKAGE-2 (make-package MUSICPLAYER-1 CLIENTMSG))
(define PACKAGE-3 (make-package MUSICPLAYER-2 CLIENTMSG))
(define PACKAGE-4 (make-package MUSICPLAYER-3 CLIENTMSG))


; A PlayerResult is one of:
; - MusicPlayer
; - Package
#;
(define (pr-temp pr)
  (cond
    [(player? pr)...(musicplayer-temp pr)...]
    [(package? pr)]))

; An [NEList-of X] (Non-Empty List of X) is one of:
; - (cons X '())
; - (cons X [NEList-of X])
 
; bin : [X X -> Boolean] [List-of X] -> [List-of [NEList-of X]]
; Bin lox by matches?
(check-expect (bin = '()) '())
(check-expect (bin = (list 2 3 4 2)) (list (list 2 2) (list 3) (list 4)))
(check-expect (bin string=? (list "hi" "hello" "hi")) (list (list "hi" "hi") (list "hello")))
(define (bin matches? lox)
  (local [; find-spot-for-x : X [List-of [NEList-of X]] -> [List-of [NEList-of X]]
          ; Find the spot for x
          (define (find-spot-for-x x bins)
            (find-spot x matches? bins))]
    (foldl find-spot-for-x '() lox)))
 
; find-spot : X [X X -> Boolean] [List-of [NEList-of X]] -> [List-of [NEList-of X]]
; Find where x belongs and place it in the appropriate list (or give it its own)
(check-expect (find-spot 2 = '()) (list (list 2)))
(check-expect (find-spot 2 = (list (list 3) (list 2) (list 4))) (list (list 3) (list 2 2) (list 4)))
(define (find-spot x matches? bins)
  (cond [(empty? bins) (list (list x))]
        [(cons? bins) (if (matches? x (first (first bins)))
                          (cons (cons x (first bins))
                                (rest bins))
                          (cons (first bins)
                                (find-spot x matches? (rest bins))))]))


(define BACKGROUND (empty-scene 400 400 "white"))
(define TITLESIZE 25)
(define ARTISTSIZE 15)
(define ALBUMSIZE 10)
(define FEEDBACKSIZE 20)
(define INSTRSIZE 10)
(define FONTCOLOR "black")
(define INSTR "press space to play the song")


;main/music-player: MusicPlayer -> String
;runs a music player displaying recent feedback and changes song on spacebar
(define (main/music-player mp)
  (write-file "history.csv"
              (make-history
               (player-history
                (big-bang (read-history 0)
                  [to-draw draw-musicplayer]
                  [on-key handle-key]
                  [on-receive handle-message]
                  (register "dictionary.ccs.neu.edu")
                  (port 10001))))))


;read-history: Any -> MusicPlayer
;Reads the song history from a file and places it in the intial player history

;Can't be tested becuase the file that it reads from changes and therefore does not give
;a consistent output

(define (read-history _)
  (local [; idstring->number: [List-of String] -> History
          ;Turns the read id into a number
          ;Given (list "Hello" "1") -> (list "Hello" 1)
          (define (idstring->number los)
            (list (first los) (string->number (second los))))]
    (if (file-exists? "history.csv")
        (make-player STATE-STARTED
                     ""
                     (map idstring->number (read-csv-file "history.csv"))
                     '())
        (make-player STATE-STARTED "" '() '()))))
      

;make-history: [List-of History] -> String
;Makes one string out of the list of History that can be written to a file

(check-expect (make-history (list (list "Bye Bye Bye" 3) (list "Chicken Dance" 21)))
              "Bye Bye Bye, 3\nChicken Dance, 21\n")

(define (make-history loh)
  (local [;make-hist-string: History -> String
          ;Creates a string of one song History
          ;Given (list "Bye Bye Bye" 3) -> "Bye Bye Bye, 3\n"
          (define (make-hist-string h)
            (string-append (first h) ", " (number->string (second h)) "\n"))
          (define STRING-HIST
            (map make-hist-string loh))]
    (foldr string-append "" STRING-HIST)))


; draw-musicplayer : MusicPlayer -> Image
; Draws the user interface for the music player

(check-expect (draw-musicplayer MUSICPLAYER-0)
              (overlay
               (above (text "Waiting for Metadata" TITLESIZE FONTCOLOR)
                      (text " " ARTISTSIZE FONTCOLOR)
                      (text "" FEEDBACKSIZE FONTCOLOR)
                      (text INSTR INSTRSIZE FONTCOLOR)
                      (beside/align "top" (text "Your Choice: " INSTRSIZE "red")
                                    (text (draw-history (player-history MUSICPLAYER-0)
                                                        (player-metadatamsg MUSICPLAYER-0))
                                          INSTRSIZE FONTCOLOR)))
               BACKGROUND))

(check-expect (draw-musicplayer MUSICPLAYER-1)
              (overlay
               (above (text "Pick a Song" TITLESIZE FONTCOLOR)
                      (text " " ARTISTSIZE FONTCOLOR)
                      (text "" FEEDBACKSIZE FONTCOLOR)
                      (text INSTR INSTRSIZE FONTCOLOR)
                      (beside/align "top" (text "Your Choice: " INSTRSIZE "red")
                                    (text (draw-history (player-history MUSICPLAYER-1)
                                                        (player-metadatamsg MUSICPLAYER-1))
                                          INSTRSIZE FONTCOLOR)))
               BACKGROUND))

(check-expect (draw-musicplayer MUSICPLAYER-2)
              (overlay
               (above (text "Hello" TITLESIZE FONTCOLOR)
                      (text "Me" ARTISTSIZE FONTCOLOR)
                      (text "dislike" FEEDBACKSIZE FONTCOLOR)
                      (text INSTR INSTRSIZE FONTCOLOR)
                      (beside/align "top" (text "Your Choice: " INSTRSIZE "red")
                                    (text (draw-history (player-history MUSICPLAYER-2)
                                                        (player-metadatamsg MUSICPLAYER-2))
                                          INSTRSIZE FONTCOLOR)))
               BACKGROUND))

(check-expect (draw-musicplayer MUSICPLAYER-3)
              (overlay
               (above (text "Hello" TITLESIZE FONTCOLOR)
                      (text "Me" ARTISTSIZE FONTCOLOR)
                      (text "none" FEEDBACKSIZE FONTCOLOR)
                      (text INSTR INSTRSIZE FONTCOLOR)
                      (beside/align "top" (text "Your Choice: " INSTRSIZE "red")
                                    (text (draw-history (player-history MUSICPLAYER-3)
                                                        (player-metadatamsg MUSICPLAYER-3))
                                          INSTRSIZE FONTCOLOR)))
               BACKGROUND))

(define (draw-musicplayer mp)
  (local [; write-by-state : MusicPlayer -> String
          ; Deterimes what to draw based on the state of the musicplayer
          ; Given player with 0 state -> "Watiting for Metadata"
          ; Given player with "watiting" state -> "Pick a song"
          ; Given player with song state -> Song Title
          (define (write-by-state mp)
            (cond
              [(number? (player-state mp)) "Waiting for Metadata"]
              [(string? (player-state mp)) "Pick a Song"]
              [(song? (player-state mp)) (song-title (player-state mp))]))]
    (overlay
     (above (text (write-by-state mp)
                  TITLESIZE FONTCOLOR)
            (text (if (song? (player-state mp))
                      (song-artist (player-state mp))
                      " ")
                  ARTISTSIZE FONTCOLOR)
            (text (player-feedback mp) FEEDBACKSIZE FONTCOLOR)
            (text INSTR INSTRSIZE FONTCOLOR)
            (beside/align "top" (text "Your Choice: " INSTRSIZE "red")
                          (text (draw-history (player-history mp) (player-metadatamsg mp))
                                INSTRSIZE FONTCOLOR)))
     BACKGROUND)))



;draw-history: [List-of History] [List-of IDMP] -> String
;Outputs a readable string so the users can see their song history

(check-expect (draw-history (list HISTORY-1 HISTORY-2) (second METADATAMSG-1))
              "Title, 0\nTitle2, 0\n")
(check-expect (draw-history (list HISTORY-1 HISTORY-1 HISTORY-2)
                            (list (list 1 (list "Cheese" "" 0 ""))
                                  (list 28 (list "Matthew" "" 0 ""))))
              "Cheese, 2\nMatthew, 1\n")

(define (draw-history loh loidmp)  
  (local [(define METADATA-TITLES (map first (map second loidmp)))
          (define BINNED-HISTORY (bin history=? loh))
          ; build-line : Number -> [List-of String]
          ; builds the line of text with the title and the number of times it's been played
          ; Given 0 (METADATA-TILES = (second METADATAMSG-1)) -> (list "Title" "0")
          ; Given 1 (METADATA-TILES = (second METADATAMSG-1)) -> (list "Title2" "0")
          (define (build-line n)
            (list (list-ref METADATA-TITLES n)
                  (if (member? (list-ref METADATA-TITLES n)
                               (map first (map first BINNED-HISTORY)))
                      (find-numplays (list-ref METADATA-TITLES n)
                                     BINNED-HISTORY)
                      "0")))
          ; find-numplays : String [List-of [List-of History]] -> String
          ; returns the number of times a specific song has been played
          ; Given "Titanic"
          ;       (list (list (list "Titanic" 0) (list "Titanic" 0)) (list (list "Foobar" 123)))
          ; Returns "2"
          (define (find-numplays title binned)
            (cond
              [(empty? binned) "0"]
              [(cons? binned)
               (if (string=? title (first (first (first binned))))
                   (number->string (length (first binned)))
                   (find-numplays title (rest binned)))]))

          ; fold-line: [List-of String] String -> String
          ; adds a line onto an already existing string of lines
          ; Given (list "Titanic" "2") "Foobar, 1\n" -> "Titanic, 2\nFoobar, 1\n"
          (define (fold-line line str)
            (string-append (first line) ", "
                           (second line) "\n"
                           str))]
    
    (foldr fold-line "" (build-list (length METADATA-TITLES) build-line))))

;history=? : History History -> Boolean
;Are two histories the same?

(check-expect (history=? HISTORY-1 HISTORY-2) #false)
(check-expect (history=? HISTORY-1 HISTORY-1) #true)

(define (history=? h1 h2)
  (and (string=? (first h1) (first h2))
       (= (second h1) (second h2))
       (= (length h1) (length h2))))


;handle-key: MusicPlayer KeyEvent -> PlayerResult
;changes to a new song and returns user feedback
(check-expect (handle-key MUSICPLAYER-0 " ") MUSICPLAYER-0)
(check-expect (handle-key MUSICPLAYER-1 " ") MUSICPLAYER-1)
;Musicplayers 2 and 3 cannot be check-expected with space because handle-space calls a big-bang
(check-expect (handle-key MUSICPLAYER-2 "a") MUSICPLAYER-2)
(check-expect (handle-key MUSICPLAYER-3 "\n") MUSICPLAYER-3)

(define (handle-key mp ke)
  (local [;cycle-list-up: MetadataMsg -> MetadataMsg
          ;cycles the order of the songs in a metadatamsg in the event of an "up" key
          (define (cycle-list-up mdm)
            (append (list (first (reverse mdm)))
                    (reverse (rest (reverse mdm)))))
          ;cycle-list-down: MetadataMsg -> MetadataMsg
          ;cycles the order of the list in the event of an "down" key
          (define (cycle-list-down mdm)
            (append (rest mdm)
                    (list (first mdm))))]
    (cond
      [(number? (player-state mp)) mp]
      [(string? (player-state mp))
       (cond
         [(string=? ke "up") (make-player (player-state mp)
                                          (player-feedback mp)
                                          (player-history mp)
                                          (cycle-list-up (player-metadatamsg mp)))]
         [(string=? ke "down") (make-player (player-state mp)
                                            (player-feedback mp)
                                            (player-history mp)
                                            (cycle-list-down (player-metadatamsg mp)))]
         [(string=? ke "\r") (make-package mp (first (first (player-metadatamsg mp))))]
         [else mp])]
      [(song? (player-state mp))
       (cond
         [(string=? ke " ") (handle-space mp)]
         [else mp])])))

;handle-space: MusicPlayer -> MusicPlayer
;Determines which kind of worldstate to output when a song is played

(check-expect (handle-space MUSICPLAYER-0) MUSICPLAYER-0)
;handle-space cannot be check-expected because if the state is ready handle-space calls play-sound

(define (handle-space mp)
  (if (song? (player-state mp))
      (make-player "waiting" (play-sound (song-bytes (player-state mp)))
                   (append (player-history mp) (list (list (song-title (player-state mp))
                                                           (song-id (player-state mp)))))
                   (player-metadatamsg mp))
      mp))

;handle-message: MusicPlayer ServerMsg -> PlayerResult
;changes the song to the song returned from the server
(check-error (handle-message MUSICPLAYER-1 SERVERMSG-1) "failed") 
(check-error (handle-message MUSICPLAYER-1 SERVERMSG-2) "failed")
(check-expect (handle-message MUSICPLAYER-1 SERVERMSG-3)
              (make-player (make-song "bytes1" 1 "Title" "Artist") "" '() (second METADATAMSG-1)))
(check-expect (handle-message MUSICPLAYER-1 SERVERMSG-4)
              (make-player (make-song "bytes2" 2 "Title2" "Artist2") "" '() (second METADATAMSG-1)))

(define (handle-message mp srm)
  (cond
    [(string=? (first srm) "ERROR") (error "failed")] 
    [(string=? (first srm) "SONG") (songmsg->musicplayer mp srm)]
    [(string=? (first srm) "METADATA") (metadatamsg->musicplayer mp srm)]))


; metadatamsg->musicplayer : MusicPlayer ServerMsg -> MusicPlayer
; updates the metadatamsg in a MusicPlayer

(check-expect (metadatamsg->musicplayer MUSICPLAYER-0 METADATAMSG-1)
              (make-player "waiting" ""
                           (list (list "Hi" 123) (list "Bye" 233))
                           (second METADATAMSG-1)))
(check-expect (metadatamsg->musicplayer MUSICPLAYER-1 METADATAMSG-1) MUSICPLAYER-1)

(define (metadatamsg->musicplayer mp srm)
  (if (number? (player-state mp))
      (make-player "waiting" (player-feedback mp) (player-history mp) (second srm))
      mp))

;songmsg->musicplayer: MusicPlayer SongMsg -> MusicPlayer
;updates the song and metadata in a MusicPlayer
(check-expect(songmsg->musicplayer MUSICPLAYER-1 SONGMSG-1)
             (make-player (make-song "bytes1" 1 "Title" "Artist") "" '() (second METADATAMSG-1)))
(check-expect(songmsg->musicplayer MUSICPLAYER-2 SONGMSG-1) MUSICPLAYER-2)

(define (songmsg->musicplayer mp sm)
  (if (not (song? (player-state mp)))
      (make-player (make-song (fourth sm)
                              (second sm)
                              (first (third sm))
                              (second (third sm)))
                   (player-feedback mp)
                   (player-history mp)
                   (player-metadatamsg mp))
      mp))