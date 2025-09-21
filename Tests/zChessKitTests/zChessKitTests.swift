import Testing
@testable import zChessKit
import zBitboard

@Test func example() async throws {
    // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    var state = BoardState.testingPosition()
    
    
    print(state.boardString())
    print("white has \(state.generateAllLegalMoves().count) valid moves")
    for move in state.generateAllLegalMoves() {
        print("\t\(move.piece) \(move.from) to \(move.to)")
    }
    
//    print("black has \(state.generateAllLegalMoves(.black).count) valid moves")
//    for move in state.generateAllLegalMoves(.black) {
//        print("\t\(move.piece) \(move.from) to \(move.to)")
//    }

}

@Test func testQueenMoves() async throws {
    let state = BoardState(
        whitePawns: .empty,
        whiteKnights: .empty,
        whiteBishops: .empty,
        whiteRooks: .empty,
        whiteQueens: Bitboard.squareMask(.d4),
        whiteKing: .empty,
        blackPawns: .empty,
        blackKnights: .empty,
        blackBishops: .empty,
        blackRooks: .empty,
        blackQueens: .empty,
        blackKing: .empty,
        plyNumber: 0,
        playerToMove: .white,
        enpassantTargetSqauare: .empty,
        castlingRights: []
    )
    let validMoves = state.generateAllLegalMoves()
    #expect(validMoves.count == 27, "a queen has 27 moves on a blank board from d4")
    print(state.boardString())

    for move in state.generateAllLegalMoves() {
        print("\t\(move.piece) \(move.from) to \(move.to)")
    }
}

@Test func testRookMoves() async throws {
    let state = BoardState(
        whitePawns: .empty,
        whiteKnights: .empty,
        whiteBishops: .empty,
        whiteRooks: Bitboard.squareMask(.d4),
        whiteQueens: .empty,
        whiteKing: .empty,
        blackPawns: .empty,
        blackKnights: .empty,
        blackBishops: .empty,
        blackRooks: .empty,
        blackQueens: .empty,
        blackKing: .empty,
        plyNumber: 0,
        playerToMove: .white,
        enpassantTargetSqauare: .empty,
        castlingRights: []
    )
    let validMoves = state.generateAllLegalMoves()
    #expect(validMoves.count == 14, "a rook has 14 moves on a blank board from d4")
    print(state.boardString())
    
    for move in state.generateAllLegalMoves() {
        print("\t\(move.piece) \(move.from) to \(move.to)")
    }
}

@Test func testMagicBitboard() async throws {

//    let rooksBb: Bitboard = Bitboard.squareMask(.d4)
//    
//    // Blockers: knights on f4 and g4
//    let blockers = Bitboard.squareMask(.f4) | Bitboard.squareMask(.g4)
//    
//    // occupancy (blockers + maybe other pieces)
//    let occupancy = blockers // simple example: only those two are on the board
//    
//    // assume both knights are enemy pieces (ownPieces = 0)
//    let ownPieces: UInt64 = 0
//    
//    let moves = rookPseudoLegalMoves(fromSquare: rookSq, occupancy: occupancy, ownPieces: ownPieces, magicTable: rookTables[rookSq])
//    
//    print("Board occupancy (1 = occupied):\n\(prettyBitboard(occupancy))")
//    print("Rook attacks / pseudo-legal moves for rook on d4:\n\(prettyBitboard(moves))")
//    
//    // List moves as algebraic-like squares
//    var dests: [String] = []
//    forEachSetBit(moves) { to in
//        let file = to & 7
//        let rank = to >> 3
//        let fileChar = Character(UnicodeScalar(97 + file)!) // 'a' + file
//        dests.append("\(fileChar)\(rank + 1)")
//    }
//    print("Dest squares:", dests.sorted())
}
