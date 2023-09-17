import Data.Char (ord)
import Data.List (delete)
type Location = (Char, Int)
data Player = White | Black deriving (Show, Eq)
data Piece = P Location | N Location | K Location | Q Location | R Location | B Location deriving (Show, Eq)
type Board = (Player, [Piece], [Piece])

setBoard :: Board
setBoard = (White, [ R ('h', 1), N ('g', 1), B ('f', 1), K ('e', 1)
                   , Q ('d', 1), B ('c', 1), N ('b', 1), R ('a', 1)
                   , P ('h', 2), P ('g', 2), P ('f', 2), P ('e', 2)
                   , P ('d', 2), P ('c', 2), P ('b', 2), P ('a', 2)
                   ]
                   , [ R ('h', 8), N ('g', 8), B ('f', 8), K ('e', 8)
                   , Q ('d', 8), B ('c', 8), N ('b', 8), R ('a', 8)
                   , P ('h', 7), P ('g', 7), P ('f', 7), P ('e', 7)
                   , P ('d', 7), P ('c', 7), P ('b', 7), P ('a', 7)
                   ]
           )

-- for visualise board to work properly, you should call visualiseBoard instead of visualizeBoard with your desired board 
-- we created the visualiseBoard because we couldnt adjust the signature of the assigned visualizeBoard (course requirements)

visualizeBoard :: Board -> String
visualizeBoard (player, white, black) = columnLabels ++ 
  "8"  ++ "|" ++ doRow 'a' 8 white black  ++ "\n" ++
  "7"  ++ "|" ++ doRow 'a' 7 white black  ++ "\n" ++
  "6"  ++ "|" ++ doRow 'a' 6 white black  ++ "\n" ++
  "5"  ++ "|" ++ doRow 'a' 5 white black  ++ "\n" ++
  "4"  ++ "|" ++ doRow 'a' 4 white black  ++ "\n" ++
  "3"  ++ "|" ++ doRow 'a' 3 white black  ++ "\n" ++
  "2"  ++ "|" ++ doRow 'a' 2 white black  ++ "\n" ++
  "1"  ++ "|" ++ doRow 'a' 1 white black  ++ "\n" ++

 "Turn: " ++ getPlayer(player)
    

visualiseBoard  :: Board ->IO ()
visualiseBoard board = putStrLn $  visualizeBoard  board   

--fixing up each cell
findIndex :: Char -> Int -> [Piece] -> [Piece] -> String
findIndex letter number [] []  = "     |"
findIndex letter number (whitehead : whitetail) [] | letter == getc whitehead && number == getIndex whitehead = pieceToString whitehead ++ "W" ++ " | "
                                                   | otherwise = findIndex letter number whitetail []
findIndex letter number [] (blackhead : blacktail) | letter == getc blackhead && number == getIndex blackhead = pieceToString blackhead ++ "B" ++ " | "
                                                   | otherwise = findIndex letter number [] blacktail
findIndex letter number ( whitehead  : whitetail) ( blackhead: blacktail) |  letter == getc whitehead && number == getIndex whitehead = pieceToString whitehead ++ "W"  ++ " | "
                                                                          | letter == getc blackhead && number == getIndex blackhead = pieceToString blackhead ++ "B" ++ " | "
                                                                          | otherwise = findIndex letter number whitetail blacktail

--fixing up each row
doRow 'h' row white black = findIndex 'h' row white black
doRow letter row white black | letter < 'i' = findIndex letter row white black ++  doRow (succ letter) row white black
                                                                                
      
columnLabels = "    a     b     c     d     e     f     g     h\n"
--this turns the pieces to strings 
pieceToString (P _ ) = " P"
pieceToString (N _ ) = " N"
pieceToString (K  _ ) = " K"
pieceToString (Q  _ ) = " Q"
pieceToString (R  _ ) = " R"
pieceToString (B  _ ) = " B"

-- getting characters 
getc (P (c, _)) = c
getc (N (c, _)) = c
getc (K (c, _)) = c
getc (Q (c, _)) = c
getc (R (c, _)) = c
getc (B (c, _)) = c

--getting numbers 
getIndex (P (_, i)) = i
getIndex (N (_, i)) = i
getIndex (K (_, i)) = i
getIndex (Q (_, i)) = i
getIndex (R (_, i)) = i
getIndex (B (_, i)) = i

--getting player
getPlayer x | x == White = "White"
            | x == Black = "Black"

isLegal  (P location)  (board) (destination) =  isLegalPawnMove   (P location)  board destination 
isLegal  (N location)  (board) (destination) =  isLegalKnightMove   (N location)  board destination 
isLegal (R location)  (board) (destination) =  isLegalRookMove   (R location)  board destination 
isLegal (K location)  (board) (destination) =  isLegalKingMove   (K location)  board destination 
isLegal (Q location)  (board) (destination) =  isLegalQueenMove   (Q location)  board destination 
isLegal (B location)  (board) (destination) =  isLegalBishopMove   (B location)  board destination 


isLegalPawnMove (P (char1, int1)) (_, wb, bb) (char2, int2)
    | differentPiece  (P (char1, int1)) (char2, int2) wb bb == False = False
    | elem (P (char1, int1)) wb && char1 == char2 && int2 == int1 + 1 && int2 <= 8 && not (isPieceAtLocation (char2, int2) wb bb) = True -- if white and moving forward
    | elem (P (char1, int1)) bb && char1 == char2 && int2 == int1 - 1 && int2 >= 1 && not (isPieceAtLocation (char2, int2) wb bb) = True -- if black and moving forward 
    | elem (P (char1, int1)) wb && char1 == char2 && int1 == 2 && int2 == 4 && not (isPieceAtLocation (char2, int2) wb bb) && not (isPieceAtLocation (char2, int2 - 1) wb bb) = True -- if white and moving forward twice
    | elem (P (char1, int1)) bb && char1 == char2 && int1 == 7 && int2 == 5 && not (isPieceAtLocation (char2, int2) wb bb) && not (isPieceAtLocation (char2, int2 + 1) wb bb) = True -- if black and moving forward twice 
    | elem (P (char1, int1)) wb && isPieceAtLocation (char2, int2) wb bb && (pred char1 == char2 || succ char1 == char2) && int2 == int1 + 1 = True --if white and attacking 
    | elem (P (char1, int1)) bb && isPieceAtLocation (char2, int2) wb bb && (pred char1 == char2 || succ char1 == char2) && int2 == int1 - 1 = True -- if black and attacking
    | otherwise = False

isLegalKnightMove (N (char1, int1)) (_, wb, bb) (char2, int2)
    | differentPiece  (N (char1, int1)) (char2, int2) wb bb && (elem (N (char1, int1)) wb || elem (N (char1, int1)) bb) = (abs (ord char2 - ord char1) == 2 && abs (int2 - int1) == 1) || (abs (ord char2 - ord char1) == 1 && abs (int2 - int1) == 2)  
    | otherwise = False


isLegalRookMove (R (char1, int1)) (x, wb, bb) (char2, int2)
    | differentPiece  (R (char1, int1)) (char2, int2) wb bb  == False = False --if it's not a different piece, false
    | char1 /= char2 && int1/= int2 = False --if it's not in the same col and row, false
    | isPathEmpty (char1, int1) (char2, int2) wb bb ==False = False -- if my path isn't empty, false 
    | otherwise =  True -- 

isLegalKingMove  (K (char1, int1)) (x, wb, bb) (char2, int2) | differentPiece  (K (char1, int1)) (char2, int2) wb bb == False = False 
                                                             | pred char1 == char2 && (int1 == int2 || int1 == int2 +1 || int1 ==int2 -1) = True
                                                             | succ char1 == char2 &&(int1 == int2 || int1 == int2 +1 || int1 ==int2 -1) = True
                                                             | int1 +1 == int2 && (char1 == char2 || pred char1 == char2 || succ char1 == char2) = True
                                                             | int1 -1 == int2 && (char1 == char2 || pred char1 == char2 || succ char1 == char2) = True
                                                             | otherwise = False

isLegalQueenMove (Q (char1, int1)) (x, wb, bb) (char2, int2) | differentPiece  (Q (char1, int1)) (char2, int2) wb bb == False = False 
                                                             | isPathEmpty (char1, int1) (char2, int2) wb bb == True || diagonalCheck (char1, int1) (char2, int2) (wb++bb) ==True = True  
                                                             | otherwise = False

isLegalBishopMove (B (char1, int1)) (_, wb, bb) (char2, int2) | differentPiece  (B (char1, int1)) (char2, int2) wb bb == False = False 
                                                              | diagonalCheck (char1, int1) (char2, int2) (wb++bb) ==True = True  
                                                              | otherwise = False


diagonalCheck (char1, int1) (char2, int2) list | (int1 +1 == int2 && char1 == succ char2 ) || (int1 +1 == int2 && char1 == pred char2) || (int1 -1 == int2 && char1 == pred char2) || (int1 -1 == int2 && char1 == succ char2) || (char1== char2 && int1 == int2)= True
                                               | int2 > int1 && char2 < char1 && (isLocationEmpty(pred char1, int1 +1) list) == False = False -- upper left 
                                               | int2 > int1 && char2 < char1 && isLocationEmpty(pred char1, int1 +1) list == True = diagonalCheck (pred char1, int1 + 1) (char2, int2) list -- upper left
                                               | int2 > int1 && char2 > char1 && isLocationEmpty(succ char1, int1 +1) list ==False = False -- upper right
                                               | int2 > int1 && char2 > char1 && isLocationEmpty(succ char1, int1 +1) list ==True =  diagonalCheck (succ char1, int1 + 1) (char2, int2) list -- upper right
                                               | int2 < int1 && char2 < char1 && isLocationEmpty(pred char1, int1 -1) list == False = False -- lower left 
                                               | int2 < int1 && char2 < char1 && isLocationEmpty(pred char1, int1 -1) list == True = diagonalCheck (pred char1, int1 - 1) (char2, int2) list -- lower left 
                                               | int2 < int1 && char2 > char1 && isLocationEmpty(succ char1, int1 -1) list ==False = False -- lower right
                                               | int2 < int1 && char2 > char1 && isLocationEmpty(succ char1, int1 -1) list ==True = diagonalCheck (succ char1, int1 - 1) (char2, int2) list -- lower left 
                                               | otherwise = False

isPieceAtLocation loc wb bb = elem loc (map getLocation wb) || elem loc (map getLocation bb)

isPathEmpty (char1, int1) (char2, int2) wb bb | char2 == char1 && checkEmptyVerticalLine (char1,int1) int2 (wb ++ bb)==True  = True
                                              | int2 == int1 && checkEmptyHorizontalLine (char1,int1)char2 ( wb++ bb) ==True = True 
                                              | otherwise = False


checkEmptyVerticalLine (char1,int1) int2 list | int1 +1 == int2 || int1 -1 == int2 || int1  == int2  = True 
                                      | int1 < int2 && isLocationEmpty (char1,int1 +1) list ==False = False 
                                      | int1 < int2 && isLocationEmpty (char1 ,int1 +1) list ==True = checkEmptyVerticalLine (char1 ,int1+1) int2 list 
                                      | int1 > int2 && isLocationEmpty (char1,int1 -1) list == False = False 
                                      | int1 > int2 && isLocationEmpty (char1,int1 -1) list ==True = checkEmptyVerticalLine (char1 ,int1-1) int2 list 
                                      

differentPiece loc1 loc2 wb bb | elem loc1 wb && elem loc2 (map getLocation bb)  = True 
                               | elem loc1 bb && elem loc2 (map getLocation wb) = True 
                               |  elem loc1 bb && elem loc2 (map getLocation bb) = False
                               |  elem loc1 wb && elem loc2 (map getLocation wb) = False
                               | otherwise = True  


checkEmptyHorizontalLine (char1,int1) char2 list | pred char1 == char2 || succ char1 == char2 || char1 == char2 = True
                                          | char1 < char2 && isLocationEmpty (succ char1, int1) list ==False = False 
                                          | char1 < char2 && isLocationEmpty (succ char1, int1) list ==True = checkEmptyHorizontalLine (succ char1,int1) char2 list 
                                          | char1 > char2 && isLocationEmpty (pred char1, int1) list == False = False 
                                          | char1 > char2 && isLocationEmpty (pred char1, int1) list == True = checkEmptyHorizontalLine (pred char1, int1) char2 list 

isLocationEmpty loc list |  elem loc (map getLocation list) == True = False 
                         |  otherwise = True

getLocation (P loc) = loc
getLocation (N loc) = loc
getLocation (K loc) = loc
getLocation (Q loc) = loc
getLocation (R loc) = loc
getLocation (B loc) = loc

suggestMove piece board = filter (\loc -> isLegal piece board loc) locations

locations = [('a',8), ('b',8), ('c', 8), ('d',8), ('e',8),('f',8), ('g', 8),('h', 8),
            ('a',7), ('b',7), ('c', 7), ('d',7), ('e',7),('f',7), ('g', 7),('h', 7),
            ('a',6), ('b',6), ('c', 6), ('d',6), ('e',6),('f',6), ('g', 6), ('h', 6),
            ('a',5), ('b',5), ('c', 5), ('d',5), ('e',5),('f',5), ('g', 5), ('h', 5),
            ('a',4), ('b',4), ('c', 4), ('d',4), ('e',4),('f',4), ('g', 4), ('h', 4),
            ('a',3), ('b',3), ('c', 3), ('d',3), ('e',3),('f',3), ('g', 3), ('h', 3),
            ('a',2), ('b',2), ('c', 2), ('d',2), ('e',2),('f',2), ('g', 2), ('h', 2),
            ('a',1), ('b',1), ('c', 1), ('d',1), ('e',1),('f',1), ('g', 1), ('h', 1)]

getPiece :: Location -> [Piece] -> Piece
getPiece location board | elem (P location) board = P location
                        | elem (Q location) board = Q location
                        | elem (K location) board = K location
                        | elem (N location) board = N location
                        | elem (B location) board = B location
                        | elem (R location) board = R location


move:: Piece -> Location -> Board -> Board 
move (P location) (destination) (player, wb, bb) | player == White && elem (P location) bb = error "This is White player's turn, Black can't move"
                                                 | player == Black && elem (P location) wb = error "This is Black player's turn, White can't move"
                                                 | not (isLegal (P location) (player, wb, bb) destination) = error ("Illegal move for piece "  ++ show (P location))
                                                 | not (isLocationEmpty destination bb) =  (Black , [P destination] ++ delete (P location) wb, delete (getPiece destination bb) bb) 
                                                 | not (isLocationEmpty destination wb) =  (White , delete (getPiece destination wb) wb, [P destination] ++ delete (P location) bb) 
                                                 | player == White =  (Black , [P destination] ++ delete (P location) wb, bb) 
                                                 | player == Black =  (White , wb, [P destination] ++ delete (P location) bb)

move (Q location) (destination) (player, wb, bb) | player == White && elem (Q location) bb = error "This is White player's turn, Black can't move"
                                                 | player == Black && elem (Q location) wb = error "This is Black player's turn, White can't move"
                                                 | not (isLegal (Q location) (player, wb, bb) destination) = error ("Illegal move for piece "  ++ show (Q location))
                                                 | not (isLocationEmpty destination bb) =  (Black , [Q destination] ++ delete (Q location) wb, delete (getPiece destination bb) bb) 
                                                 | not (isLocationEmpty destination wb) =  (White , delete (getPiece destination wb) wb, [Q destination] ++ delete (Q location) bb) 
                                                 | player == White =  (Black , [Q destination] ++ delete (Q location) wb, bb)
                                                 | player == Black =  (White , wb, [Q destination] ++ delete (Q location) bb)


move (K location) (destination) (player, wb, bb) | player == White && elem (K location) bb = error "This is White player's turn, Black can't move"
                                                 | player == Black && elem (K location) wb = error "This is Black player's turn, White can't move"
                                                 | not (isLegal (K location) (player, wb, bb) destination) = error ("Illegal move for piece "  ++ show (K location))
                                                 | not (isLocationEmpty destination bb) =  (Black , [K destination] ++ delete (K location) wb, delete (getPiece destination bb) bb) 
                                                 | not (isLocationEmpty destination wb) =  (White , delete (getPiece destination wb) wb, [K destination] ++ delete (K location) bb) 
                                                 | player == White =  (Black , [K destination] ++ delete (K location) wb, bb)
                                                 | player == Black =  (White , wb, [K destination] ++ delete (K location) bb)


move (N location) (destination) (player, wb, bb) | player == White && elem (N location) bb = error "This is White player's turn, Black can't move"
                                                 | player == Black && elem (N location) wb = error "This is Black player's turn, White can't move"
                                                 | not (isLegal (N location) (player, wb, bb) destination) = error ("Illegal move for piece "  ++ show (N location))
                                                 | not (isLocationEmpty destination bb) =  (Black , [N destination] ++ delete (N location) wb, delete (getPiece destination bb) bb) 
                                                 | not (isLocationEmpty destination wb) =  (White , delete (getPiece destination wb) wb, [N destination] ++ delete (N location) bb) 
                                                 | player == White =  (Black , [N destination] ++ delete (N location) wb, bb) 
                                                 | player == Black =  (White , wb, [N destination] ++ delete (N location) bb)

move (B location) (destination) (player, wb, bb) | player == White && elem (B location) bb = error "This is White player's turn, Black can't move"
                                                 | player == Black && elem (B location) wb = error "This is Black player's turn, White can't move"
                                                 | not (isLegal (B location) (player, wb, bb) destination) = error ("Illegal move for piece "  ++ show (B location))
                                                 | not (isLocationEmpty destination bb) =  (Black , [B destination] ++ delete (B location) wb, delete (getPiece destination bb) bb) 
                                                 | not (isLocationEmpty destination wb) =  (White , delete (getPiece destination wb) wb, [B destination] ++ delete (B location) bb) 
                                                 | player == White =  (Black , [B destination] ++ delete (B location) wb, bb) 
                                                 | player == Black =  (White , wb, [B destination] ++ delete (B location) bb)

move (R location) (destination) (player, wb, bb) | player == White && elem (R location) bb = error "This is White player's turn, Black can't move"
                                                 | player == Black && elem (R location) wb = error "This is Black player's turn, White can't move"
                                                 | not (isLegal (R location) (player, wb, bb) destination) = error ("Illegal move for piece "  ++ show (R location))
                                                 | not (isLocationEmpty destination bb) =  (Black , [R destination] ++ delete (R location) wb, delete (getPiece destination bb) bb) 
                                                 | not (isLocationEmpty destination wb) =  (White , delete (getPiece destination wb) wb, [R destination] ++ delete (R location) bb) 
                                                 | player == White =  (Black , [R destination] ++ delete (R location) wb, bb) 
                                                 | player == Black =  (White , wb, [R destination] ++ delete (R location) bb)






