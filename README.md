# RacketMusicPlayer
This simple music player was created using the Racket functional programming language and had a the following objectives:
1. Allow users to choose from a list of songs sent from a server.
2. Pull byte strings for the seleted song from the server only after the song had been selected.
2. Allow users to leave feedback on the songs they heard.
3. Show users how many times they have listened to each song, which is stored in a text file.

The structure of the program depended on the tick of the clock and keyboard inputs from users as the program cycled through four different states. The states are represented by the diagram below:
