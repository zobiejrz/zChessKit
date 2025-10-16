//
//  MoveTests.swift
//  zChessKit
//
//  Created by Ben Zobrist on 10/11/25.
//

import Testing
import zBitboard
@testable import zChessKit

@Test func testMoveEquatable() async throws {
    let firstMove = Move(
        from: .e2,
        to: .e4,
        piece: .pawn,
        resultingBoardState: BoardState(
            whitePawns: (Bitboard.rank(2)! & ~Bitboard.file(5)!) | Bitboard.squareMask(.e4),
            whiteKnights: Bitboard.squareMask(.b1) | Bitboard.squareMask(.g1),
            whiteBishops: Bitboard.squareMask(.c1) | Bitboard.squareMask(.f1),
            whiteRooks: Bitboard.squareMask(.a1) | Bitboard.squareMask(.h1),
            whiteQueens: Bitboard.squareMask(.d1),
            whiteKing: Bitboard.squareMask(.e1),
            blackPawns: Bitboard.rank(7)!,
            blackKnights: Bitboard.squareMask(.b8) | Bitboard.squareMask(.g8),
            blackBishops: Bitboard.squareMask(.c8) | Bitboard.squareMask(.f8),
            blackRooks: Bitboard.squareMask(.a8) | Bitboard.squareMask(.h8),
            blackQueens: Bitboard.squareMask(.d8),
            blackKing: Bitboard.squareMask(.e8),
            plyNumber: 1,
            playerToMove: .black,
            enpassantTargetSqauare: Bitboard.squareMask(.e3),
            castlingRights: [.K,.Q,.k,.q]),
        ply: 1,
        color: .black,
        san: "e4"
    )
    let secondMove = Move(
        from: .d2,
        to: .d4,
        piece: .pawn,
        resultingBoardState: BoardState(
            whitePawns: (Bitboard.rank(2)! & ~Bitboard.file(4)!) | Bitboard.squareMask(.d4),
            whiteKnights: Bitboard.squareMask(.b1) | Bitboard.squareMask(.g1),
            whiteBishops: Bitboard.squareMask(.c1) | Bitboard.squareMask(.f1),
            whiteRooks: Bitboard.squareMask(.a1) | Bitboard.squareMask(.h1),
            whiteQueens: Bitboard.squareMask(.d1),
            whiteKing: Bitboard.squareMask(.e1),
            blackPawns: Bitboard.rank(7)!,
            blackKnights: Bitboard.squareMask(.b8) | Bitboard.squareMask(.g8),
            blackBishops: Bitboard.squareMask(.c8) | Bitboard.squareMask(.f8),
            blackRooks: Bitboard.squareMask(.a8) | Bitboard.squareMask(.h8),
            blackQueens: Bitboard.squareMask(.d8),
            blackKing: Bitboard.squareMask(.e8),
            plyNumber: 1,
            playerToMove: .black,
            enpassantTargetSqauare: Bitboard.squareMask(.d3),
            castlingRights: [.K,.Q,.k,.q]),
        ply: 1,
        color: .black,
        san: "d4"
    )
    let initialState = BoardState.startingPosition()
    let moveA = initialState.isValidSANMove("e4")
    let moveB = initialState.isValidSANMove("d4")

    #expect(firstMove == firstMove, "These are same moves")
    #expect(secondMove == secondMove, "These are same moves")
    #expect(firstMove == moveA, "These are same moves")
    #expect(secondMove == moveB, "These are same moves")

    #expect(firstMove != secondMove, "These are different moves")
    #expect(moveA != moveB, "These are different moves")
}
