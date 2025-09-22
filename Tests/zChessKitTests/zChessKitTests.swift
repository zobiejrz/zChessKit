import Testing
@testable import zChessKit
import zBitboard

@Test func example() async throws {
    // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    let state = BoardState.startingPosition()
    
    
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

@Test func testBoardStateInitializer() async throws {
    
    let firstPos = BoardState.startingPosition()
    let firstFEN = BoardState(FEN: "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1")
    
    #expect(firstPos == firstFEN, "These positions are the same")
    
    let secondPos = BoardState(
        whitePawns: Bitboard.squareMask(.a2) | Bitboard.squareMask(.b2) | Bitboard.squareMask(.c2) | Bitboard.squareMask(.e4) | Bitboard.squareMask(.e6) | Bitboard.squareMask(.g2) | Bitboard.squareMask(.h2),
        whiteKnights: Bitboard.squareMask(.c3),
        whiteBishops: .empty,
        whiteRooks: Bitboard.squareMask(.a1) | Bitboard.squareMask(.h1),
        whiteQueens: Bitboard.squareMask(.g7),
        whiteKing: Bitboard.squareMask(.e1),
        blackPawns: Bitboard.squareMask(.a7) | Bitboard.squareMask(.b7) | Bitboard.squareMask(.c7) | Bitboard.squareMask(.d6) | Bitboard.squareMask(.h7),
        blackKnights: Bitboard.squareMask(.e7),
        blackBishops: .empty,
        blackRooks: Bitboard.squareMask(.a8) | Bitboard.squareMask(.f8),
        blackQueens: .empty,
        blackKing: Bitboard.squareMask(.c6),
        plyNumber: 37,
        playerToMove: .black,
        enpassantTargetSqauare: .empty,
        castlingRights: [.K, .Q]
    )
    let secondFEN = BoardState(FEN: "r4r2/ppp1n1Qp/2kpP3/8/4P3/2N5/PPP3PP/R3K2R b KQ - 0 19")
    
    #expect(secondPos == secondFEN, "These positions are the same")
}
