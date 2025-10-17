# zChessKit

A Swift package that provides fast, lightweight, and expressive chess logic for your apps and tools.  

It includes move generation, position validation, FEN/PGN parsing, and convenient data structures for building chess-related functionality in Swift.

## Features

- Full chess move generation and legality checks
- FEN parsing and serialization
- PGN parsing with support for annotations and variations
- Board, Square, Piece, and Move abstractions
- Works on iOS, macOS, watchOS, and tvOS via Swift Package Manager

## Installation

You can add **zChessKit** directly to your project using Swift Package Manager.

```swift
// In Xcode:
File → Add Packages → Search for
https://github.com/zobiejrz/zChessKit.git
```

Or update your `Package.swift`:

``` swift
dependencies: [
    .package(url: "https://github.com/zobiejrz/zChessKit.git", from: "1.0.0")
]
```

## Example Usage

### Create and Inspect a `BoardState`

```swift
import zChessKit

let state = BoardState.startingPosition()

print(state.boardString()) // ASCII represenation of the board
print("white has \(state.generateAllLegalMoves().count) valid moves")
```

### Parse an FEN String

```swift
let fen = "2r4k/5prp/2b1P3/4Qp2/1PpR1P2/2q5/P4K1P/4R3 w - - 2 33"


// This way can support parsing multiple FENs at once
let tokens = try Lexer.getFENLexer().run(input: fen)
let result = try Parser.parseFEN(from: tokens) // results in [FEN]

// This way also works
if let state = BoardState.fromFEN(fen) {
    //...
}
```

### Generate Moves

```swift
if let state = BoardState.fromFEN(fen) {
    state.generateAllLegalMoves()
}
```

```swift
// Independent of whose turn it actually is to play, the player to move can be overriden.
// This gives 'legal' moves for that player (if it were their turn).
// It is used to distinguish 'legal' from 'pseudo-legal' moves.
state.generateAllLegalMoves(PlayerColor.black)
```

### Parse PGN Game(s)

```swift
let pgn = """
[Event "Paris"]
[Site "Paris FRA"]
[Date "1858.??.??"]
[Round "?"]
[White "Paul Morphy"]
[Black "Duke Karl / Count Isouard"]
[Result "1-0"]

1. e4 e5 2. Nf3 d6 3. d4 Bg4 4. dxe5 Bxf3 5. Qxf3 dxe5 6. Bc4 Nf6 7. Qb3 Qe7
8. Nc3 c6 9. Bg5 b5 10. Nxb5 cxb5 11. Bxb5+ Nbd7 12. O-O-O Rd8 13. Rxd7 Rxd7
14. Rd1 Qe6 15. Bxd7+ Nxd7 16. Qb8+ $3 Nxb8 17. Rd8# 1-0
"""
    
if let tokens = try? Lexer.getPGNLexer().run(input: pgn),
   let games = try? Parser.parsePGN(from: tokens),
   let game = games.first {
    
    print("Parsed \(game.moves.count) moves")
}
```

## Contributing

Contributions are welcome!

Open an issue, submit a PR, or suggest new features and improvements.
