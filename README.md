# Chess Game Engine

## Overview

This project is a chess game engine built using **Haskell**, designed to explore functional programming concepts. The engine represents a chess board, players, and pieces programmatically and provides functions to visualize the board, determine legal moves, suggest moves, and perform moves according to the rules of chess.

---

## Data Representations

### 1. **Location**
- Represents a cell on the chess board.
- Indexed by:
  - **Column**: Letter (a to h)
  - **Row**: Number (1 to 8)
- Example: `Location a8` refers to the top-left corner of the board.

### 2. **Player**
- Represents one of the two players: **White** or **Black**.

### 3. **Piece**
- Represents chess pieces:
  - **P**: Pawn
  - **N**: Knight
  - **K**: King
  - **Q**: Queen
  - **R**: Rook
  - **B**: Bishop
- Each piece is associated with a **location** on the board.
  - Example: `P a2` represents a white pawn on cell `a2`.

### 4. **Board**
- Represents the state of the game, modeled as a triple:
  1. **Current Player**: Player whose turn it is.
  2. **White Pieces**: List of all white pieces and their locations.
  3. **Black Pieces**: List of all black pieces and their locations.

---

## Example: Initial Board State

The starting position of a chess board is visualized as follows:

```
     a    b    c    d    e    f    g    h
8 | RB | NB | BB | QB | KB | BB | NB | RB |
7 | PB | PB | PB | PB | PB | PB | PB | PB |
6 |    |    |    |    |    |    |    |    |
5 |    |    |    |    |    |    |    |    |
4 |    |    |    |    |    |    |    |    |
3 |    |    |    |    |    |    |    |    |
2 | PW | PW | PW | PW | PW | PW | PW | PW |
1 | RW | NW | BW | QW | KW | BW | NW | RW |

Turn: White
```

---

## Available Functions

### 1. **`visualizeBoard :: Board -> String`**
- **Description**: Visualizes the current state of the board in text format (e.g., as shown above).

### 2. **`isLegal :: Piece -> Board -> Location -> Bool`**
- **Description**: Checks if a suggested move for a piece is legal based on the rules of chess.
- **Example**: `isLegal (P a2) board a3` returns `True` if moving the pawn from `a2` to `a3` is legal.

### 3. **`suggestMove :: Piece -> Board -> [Location]`**
- **Description**: Suggests a list of legal moves that a piece can make.
- **Example**: `suggestMove (N b1) board` might return `[a3, c3]`.

### 4. **`move :: Piece -> Location -> Board -> Board`**
- **Description**: Moves a piece to the specified location if the move is legal. Otherwise, it provides an appropriate error message.
- **Example**: `move (P a2) a3 board` moves the pawn at `a2` to `a3` if the move is valid.
  
---

## Future Enhancements

- Implement check and checkmate detection.
- Add support for castling, en passant, and pawn promotion.
- Develop a basic AI to play against.
