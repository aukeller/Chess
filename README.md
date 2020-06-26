# Chess 
This is classic chess that can be played between two players on the command line.

## Background
I would consider this to be the most complex project I have completed thus far in my coding career. I have created other games in Ruby such as Hangman, Tic-Tac-Toe, and Mastermind, but Chess is a much larger project as it is an inherently more complex game. Credit goes to The Odin Project curriculum for providing the prior training in Ruby–this project is definitely a feather in my cap!

## Road Map
I started this project by reducing the game of Chess into smaller components, while also adding additional features:
- [x] Creating pieces that follow their specific behaviors and obey to edge cases (En passant and promotion for pawns, castling for Rooks.)
- [x] Modeling a board which stores the locations of each piece in a grid and allows for the player to move pieces, as well as a display of the board
- [x] Providing a game loop, which requests users for their move and checks for games states such as Check, Checkmate, or Stalemate
- [] Allowing users to save a game at any point, and to load a particular game at startup

## Goals
This project was a great way to practice OOPS and clean coding–since this was a large project, it was crucial to stay organized and to keep classes modular. It also taught me some critical thinking, because Checkmate, Check, and Stalemate conditions can complicate the behavior of certain pieces and limit the moves the user is allowed to make.
