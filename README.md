# Chess Game Engine

Chess game engine created using Haskell with the aim of exploring functional programming.

a) Location represents a cell on the chess board indexed by a column letter (from a to h) and a row number (from 1 to 8).

Example: initial board placement
a b c d e f g h
8 | RB | NB | BB | QB | KB | BB | NB | RB |
7 | PB | PB | PB | PB | PB | PB | PB | PB |
6 | | | | | | | | |
5 | | | | | | | | |
4 | | | | | | | | |
3 | | | | | | | | |
2 | PW | PW | PW | PW | PW | PW | PW | PW |
1 | RW | NW | BW | QW | KW | BW | NW | RW |
Turn: White

b) Player is one of the black or white players.
c) Piece is represented by one of the data constructors P, N, K, Q, R, and B which represent a pawn, a knight, a king, a queen, a rook, and a bishop respectively, followed by the piece’s location on the board.
d) Board is represented by a triple consisting of the player on which the current turn is, a list of the white player’s pieces, and a list of the black player’s pieces.

Available Functions:

- visualizeBoard:: Board->String : visualizes the board in the format displayed in the example above
- isLegal:: Piece -> Board -> Location -> Bool : returns true if the suggested move is legal according to the game's rules
- suggestMove:: Piece -> Board -> [Location] : suggests a set of legal moves a piece can move to
- move:: Piece -> Location -> Board -> Board : moves chess piece to location if it happens to be legal, gives an appropriate messsage otherwise
