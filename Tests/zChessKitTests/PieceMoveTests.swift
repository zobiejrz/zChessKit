//
//  PieceMoveTests.swift
//  zChessKit
//
//  Created by Ben Zobrist on 9/20/25.
//

import Testing
@testable import zChessKit
import zBitboard

@Test func testKingMoves() async throws {
    var state = BoardState(
        whitePawns: .empty,
        whiteKnights: .empty,
        whiteBishops: .empty,
        whiteRooks: .empty,
        whiteQueens: .empty,
        whiteKing: Bitboard.squareMask(.e1),
        blackPawns: .empty,
        blackKnights: .empty,
        blackBishops: .empty,
        blackRooks: .empty,
        blackQueens: .empty,
        blackKing: .empty,
        plyNumber: 1,
        playerToMove: .white,
        enpassantTargetSqauare: .empty,
        castlingRights: [.K, .Q, .k, .q]
    )
    
    #expect(state.generateAllLegalMoves().count(where: { $0.piece == .king }) == 5, "a king on e1 has 5 valid moves")
    #expect(state.isKingInCheck() == false, "king is in check")
    
    state = BoardState(
        whitePawns: .empty,
        whiteKnights: .empty,
        whiteBishops: .empty,
        whiteRooks: .empty,
        whiteQueens: .empty,
        whiteKing: Bitboard.squareMask(.e4),
        blackPawns: .empty,
        blackKnights: .empty,
        blackBishops: .empty,
        blackRooks: .empty,
        blackQueens: .empty,
        blackKing: .empty,
        plyNumber: 1,
        playerToMove: .white,
        enpassantTargetSqauare: .empty,
        castlingRights: [.K, .Q, .k, .q]
    )
    
    #expect(state.generateAllLegalMoves().count(where: { $0.piece == .king }) == 8, "a king on e1 has 8 valid moves")
    #expect(state.isKingInCheck() == false, "king is in check")
    
    state = BoardState(
        whitePawns: .empty,
        whiteKnights: .empty,
        whiteBishops: .empty,
        whiteRooks: Bitboard.squareMask(.h1),
        whiteQueens: .empty,
        whiteKing: Bitboard.squareMask(.e1),
        blackPawns: .empty,
        blackKnights: .empty,
        blackBishops: .empty,
        blackRooks: .empty,
        blackQueens: .empty,
        blackKing: .empty,
        plyNumber: 1,
        playerToMove: .white,
        enpassantTargetSqauare: .empty,
        castlingRights: [.K, .Q, .k, .q]
    )
    
    #expect(state.generateAllLegalMoves().count(where: { $0.piece == .king }) == 6, "a king on e1 has 6 valid moves incl. O-O")
    #expect(state.isKingInCheck() == false, "king is not in check")
    
    state = BoardState(
        whitePawns: .empty,
        whiteKnights: .empty,
        whiteBishops: .empty,
        whiteRooks: Bitboard.squareMask(.a1),
        whiteQueens: .empty,
        whiteKing: Bitboard.squareMask(.e1),
        blackPawns: .empty,
        blackKnights: .empty,
        blackBishops: .empty,
        blackRooks: .empty,
        blackQueens: .empty,
        blackKing: .empty,
        plyNumber: 1,
        playerToMove: .white,
        enpassantTargetSqauare: .empty,
        castlingRights: [.K, .Q, .k, .q]
    )
    
    #expect(state.generateAllLegalMoves().count(where: { $0.piece == .king }) == 6, "a king on e1 has 6 valid moves incl. O-O-O")
    #expect(state.isKingInCheck() == false, "king is not in check")
    
    state = BoardState(
        whitePawns: .empty,
        whiteKnights: .empty,
        whiteBishops: .empty,
        whiteRooks: Bitboard.squareMask(.a1) | Bitboard.squareMask(.h1),
        whiteQueens: .empty,
        whiteKing: Bitboard.squareMask(.e1),
        blackPawns: .empty,
        blackKnights: .empty,
        blackBishops: .empty,
        blackRooks: .empty,
        blackQueens: .empty,
        blackKing: .empty,
        plyNumber: 1,
        playerToMove: .white,
        enpassantTargetSqauare: .empty,
        castlingRights: [.K, .Q, .k, .q]
    )
    
    #expect(state.generateAllLegalMoves().count(where: { $0.piece == .king }) == 7, "a king on e1 has 7 valid moves incl. O-O & O-O-O")
    #expect(state.isKingInCheck() == false, "king is not in check")
    
    state = BoardState(
        whitePawns: .empty,
        whiteKnights: .empty,
        whiteBishops: .empty,
        whiteRooks: Bitboard.squareMask(.a1) | Bitboard.squareMask(.h1),
        whiteQueens: .empty,
        whiteKing: Bitboard.squareMask(.e1),
        blackPawns: .empty,
        blackKnights: .empty,
        blackBishops: .empty,
        blackRooks: .empty,
        blackQueens: .empty,
        blackKing: .empty,
        plyNumber: 1,
        playerToMove: .white,
        enpassantTargetSqauare: .empty,
        castlingRights: []
    )
    
    #expect(state.generateAllLegalMoves().count(where: { $0.piece == .king }) == 5, "a king on e1 has 5 valid moves w/o castling rights")
    #expect(state.isKingInCheck() == false, "king is not in check")
    
    state = BoardState(
        whitePawns: .empty,
        whiteKnights: .empty,
        whiteBishops: .empty,
        whiteRooks: Bitboard.squareMask(.a1) | Bitboard.squareMask(.h1),
        whiteQueens: .empty,
        whiteKing: Bitboard.squareMask(.e1),
        blackPawns: .empty,
        blackKnights: Bitboard.squareMask(.c3) | Bitboard.squareMask(.g3),
        blackBishops: .empty,
        blackRooks: .empty,
        blackQueens: .empty,
        blackKing: .empty,
        plyNumber: 1,
        playerToMove: .white,
        enpassantTargetSqauare: .empty,
        castlingRights: [.K, .Q, .k, .q]
    )
    
    #expect(state.generateAllLegalMoves().count(where: { $0.piece == .king }) == 2, "knights are blocking castling, so 2 moves remain")
    #expect(state.isKingInCheck() == false, "king is not in check")
    
    state = BoardState(
        whitePawns: .empty,
        whiteKnights: .empty,
        whiteBishops: .empty,
        whiteRooks: Bitboard.squareMask(.a1) | Bitboard.squareMask(.h1),
        whiteQueens: .empty,
        whiteKing: Bitboard.squareMask(.e1),
        blackPawns: .empty,
        blackKnights: Bitboard.squareMask(.e3),
        blackBishops: .empty,
        blackRooks: .empty,
        blackQueens: .empty,
        blackKing: .empty,
        plyNumber: 1,
        playerToMove: .white,
        enpassantTargetSqauare: .empty,
        castlingRights: [.K, .Q, .k, .q]
    )
    
    #expect(state.generateAllLegalMoves().count(where: { $0.piece == .king }) == 3, "a knight is blocking castling, so 3 moves remain")
    #expect(state.isKingInCheck() == false, "king is not in check")
    
    state = BoardState(
        whitePawns: .empty,
        whiteKnights: .empty,
        whiteBishops: .empty,
        whiteRooks: Bitboard.squareMask(.a1) | Bitboard.squareMask(.h1),
        whiteQueens: .empty,
        whiteKing: Bitboard.squareMask(.e1),
        blackPawns: .empty,
        blackKnights: Bitboard.squareMask(.c2),
        blackBishops: .empty,
        blackRooks: .empty,
        blackQueens: .empty,
        blackKing: .empty,
        plyNumber: 1,
        playerToMove: .white,
        enpassantTargetSqauare: .empty,
        castlingRights: [.K, .Q, .k, .q]
    )
    
    #expect(state.generateAllLegalMoves().count(where: { $0.piece == .king }) == 5, "a knight is checking the king, so 5 moves remain")
    #expect(state.generateAllLegalMoves().count == 5, "a knight is checking the king, so 5 moves remain")
    #expect(state.isKingInCheck() == true, "king is in check")
    
    let shortState = BoardState(
        whitePawns: .empty,
        whiteKnights: .empty,
        whiteBishops: .empty,
        whiteRooks: Bitboard.squareMask(.a1) | Bitboard.squareMask(.h1),
        whiteQueens: .empty,
        whiteKing: Bitboard.squareMask(.e1),
        blackPawns: .empty,
        blackKnights: .empty,
        blackBishops: .empty,
        blackRooks: Bitboard.squareMask(.a8) | Bitboard.squareMask(.h8),
        blackQueens: .empty,
        blackKing: Bitboard.squareMask(.e8),
        plyNumber: 1,
        playerToMove: .white,
        enpassantTargetSqauare: .empty,
        castlingRights: [.K, .Q, .k, .q]
    )
    
    let castleShort = shortState.isValidMove(piece: .king, from: .e1, to: .g1)
    
    #expect(castleShort != nil, "castling is valid in this position")
    if let bsA = castleShort?.resultingBoardState {
        #expect(bsA.whiteKing.hasPiece(on: .g1), "king is on g1")
        #expect(bsA.whiteRooks.hasPiece(on: .a1), "one rook is on a1")
        #expect(bsA.whiteRooks.hasPiece(on: .f1), "one rook is on f1")
        #expect(!bsA.whiteRooks.hasPiece(on: .h1), "no rook is on h1")
//        print(bsA.boardString())
    }
    
    let longState = BoardState(
        whitePawns: .empty,
        whiteKnights: .empty,
        whiteBishops: .empty,
        whiteRooks: Bitboard.squareMask(.a1) | Bitboard.squareMask(.h1),
        whiteQueens: .empty,
        whiteKing: Bitboard.squareMask(.e1),
        blackPawns: .empty,
        blackKnights: .empty,
        blackBishops: .empty,
        blackRooks: Bitboard.squareMask(.a8) | Bitboard.squareMask(.h8),
        blackQueens: .empty,
        blackKing: Bitboard.squareMask(.e8),
        plyNumber: 1,
        playerToMove: .white,
        enpassantTargetSqauare: .empty,
        castlingRights: [.K, .Q, .k, .q]
    )
    
    let castleLong = longState.isValidMove(piece: .king, from: .e1, to: .c1)
    
    #expect(castleLong != nil, "castling is valid in this position")
    if let bsB = castleLong?.resultingBoardState {
        #expect(bsB.whiteKing.hasPiece(on: .c1), "king is on c1")
        #expect(bsB.whiteRooks.hasPiece(on: .h1), "one rook is on h1")
        #expect(bsB.whiteRooks.hasPiece(on: .d1), "one rook is on d1")
        #expect(!bsB.whiteRooks.hasPiece(on: .a1), "no rook is on a1")
        print(bsB.boardString())
    }
}

@Test func testKnightMoves() async throws {
    // 8  .  .  .  .  .  .  .  .
    // 7  .  .  .  .  .  .  .  .
    // 6  .  .  .  .  .  .  .  .
    // 5  .  .  .  .  .  .  .  .
    // 4  .  .  .  ♘  .  .  .  .
    // 3  .  .  .  .  .  .  .  .
    // 2  .  .  .  .  .  .  .  .
    // 1  .  .  .  .  .  .  .  .
    //    a  b  c  d  e  f  g  h
    var state = BoardState(
        whitePawns: .empty,
        whiteKnights: Bitboard.squareMask(.d4),
        whiteBishops: .empty,
        whiteRooks: .empty,
        whiteQueens: .empty,
        whiteKing: .empty,
        blackPawns: .empty,
        blackKnights: .empty,
        blackBishops: .empty,
        blackRooks: .empty,
        blackQueens: .empty,
        blackKing: .empty,
        plyNumber: 1,
        playerToMove: .white,
        enpassantTargetSqauare: .empty,
        castlingRights: [.K, .Q, .k, .q]
    )
    
    #expect(state.generateAllLegalMoves().count == 8, "a white knight on d4 has 8 valid moves")
    #expect(state.isValidMove(piece: .knight, from: .d4, to: .c6) != nil, "c6 is a target for a knight on d4")
    #expect(state.isValidMove(piece: .knight, from: .d4, to: .e6) != nil, "e6 is a target for a knight on d4")
    #expect(state.isValidMove(piece: .knight, from: .d4, to: .b5) != nil, "b5 is a target for a knight on d4")
    #expect(state.isValidMove(piece: .knight, from: .d4, to: .f5) != nil, "f5 is a target for a knight on d4")
    #expect(state.isValidMove(piece: .knight, from: .d4, to: .b3) != nil, "b3 is a target for a knight on d4")
    #expect(state.isValidMove(piece: .knight, from: .d4, to: .f3) != nil, "f3 is a target for a knight on d4")
    #expect(state.isValidMove(piece: .knight, from: .d4, to: .c2) != nil, "c2 is a target for a knight on d4")
    #expect(state.isValidMove(piece: .knight, from: .d4, to: .e2) != nil, "e2 is a target for a knight on d4")
    
    // 8  ♙  .  ♙  .  ♙  .  ♙  .
    // 7  .  ♙  .  ♙  .  ♙  .  ♙
    // 6  ♙  .  ♙  .  ♙  .  ♙  .
    // 5  .  ♙  .  ♙  .  ♙  .  ♙
    // 4  ♙  .  ♙  ♘  ♙  .  ♙  .
    // 3  .  ♙  .  ♙  .  ♙  .  ♙
    // 2  ♙  .  ♙  .  ♙  .  ♙  .
    // 1  .  ♙  .  ♙  .  ♙  .  ♙
    //    a  b  c  d  e  f  g  h
    state = BoardState(
        whitePawns: .light,
        whiteKnights: Bitboard.squareMask(.d4),
        whiteBishops: .empty,
        whiteRooks: .empty,
        whiteQueens: .empty,
        whiteKing: .empty,
        blackPawns: .empty,
        blackKnights: .empty,
        blackBishops: .empty,
        blackRooks: .empty,
        blackQueens: .empty,
        blackKing: .empty,
        plyNumber: 1,
        playerToMove: .white,
        enpassantTargetSqauare: .empty,
        castlingRights: [.K, .Q, .k, .q]
    )
        
    #expect(state.generateAllLegalMoves().count == 0, "there are pawns on all light squares, preventing movement")
    #expect(state.isValidMove(piece: .knight, from: .d4, to: .c6) == nil, "c6 is occupied")
    #expect(state.isValidMove(piece: .knight, from: .d4, to: .e6) == nil, "e6 is occupied")
    #expect(state.isValidMove(piece: .knight, from: .d4, to: .b5) == nil, "b5 is occupied")
    #expect(state.isValidMove(piece: .knight, from: .d4, to: .f5) == nil, "f5 is occupied")
    #expect(state.isValidMove(piece: .knight, from: .d4, to: .b3) == nil, "b3 is occupied")
    #expect(state.isValidMove(piece: .knight, from: .d4, to: .f3) == nil, "f3 is occupied")
    #expect(state.isValidMove(piece: .knight, from: .d4, to: .c2) == nil, "c2 is occupied")
    #expect(state.isValidMove(piece: .knight, from: .d4, to: .e2) == nil, "e2 is occupied")
    
    // 8  .  .  .  .  .  .  .  .
    // 7  .  .  .  .  .  .  .  .
    // 6  .  .  .  .  .  .  .  .
    // 5  .  .  .  .  .  .  .  .
    // 4  .  .  .  .  .  .  .  .
    // 3  .  .  .  .  .  .  .  .
    // 2  .  .  .  .  .  .  .  .
    // 1  ♘  .  .  .  .  .  .  .
    //    a  b  c  d  e  f  g  h
    state = BoardState(
        whitePawns: .empty,
        whiteKnights: Bitboard.squareMask(.a1),
        whiteBishops: .empty,
        whiteRooks: .empty,
        whiteQueens: .empty,
        whiteKing: .empty,
        blackPawns: .empty,
        blackKnights: .empty,
        blackBishops: .empty,
        blackRooks: .empty,
        blackQueens: .empty,
        blackKing: .empty,
        plyNumber: 1,
        playerToMove: .white,
        enpassantTargetSqauare: .empty,
        castlingRights: [.K, .Q, .k, .q]
    )
        
    #expect(state.generateAllLegalMoves().count == 2, "a knight on a1 has 2 legal moves")
    #expect(state.isValidMove(piece: .knight, from: .a1, to: .b3) != nil, "b3 is a target for a knight on a1")
    #expect(state.isValidMove(piece: .knight, from: .a1, to: .c2) != nil, "c2 is a target for a knight on a1")

    // 8  ♙  .  ♙  .  ♙  .  ♙  .
    // 7  .  ♙  .  ♙  .  ♙  .  ♙
    // 6  ♙  .  ♙  .  ♙  .  ♙  .
    // 5  .  ♙  .  ♙  .  ♙  .  ♙
    // 4  ♙  .  ♙  .  ♙  .  ♙  .
    // 3  .  ♙  .  ♙  .  ♙  .  ♙
    // 2  ♙  .  ♙  .  ♙  .  ♙  .
    // 1  ♘  ♙  .  ♙  .  ♙  .  ♙
    //    a  b  c  d  e  f  g  h
    state = BoardState(
        whitePawns: .light,
        whiteKnights: Bitboard.squareMask(.a1),
        whiteBishops: .empty,
        whiteRooks: .empty,
        whiteQueens: .empty,
        whiteKing: .empty,
        blackPawns: .empty,
        blackKnights: .empty,
        blackBishops: .empty,
        blackRooks: .empty,
        blackQueens: .empty,
        blackKing: .empty,
        plyNumber: 1,
        playerToMove: .white,
        enpassantTargetSqauare: .empty,
        castlingRights: [.K, .Q, .k, .q]
    )
    
    #expect(state.generateAllLegalMoves().count == 0, "there are pawns on all light squares, preventing movement")
    #expect(state.isValidMove(piece: .knight, from: .a1, to: .b3) == nil, "b3 is occupied")
    #expect(state.isValidMove(piece: .knight, from: .a1, to: .c2) == nil, "c2 is occupied")

    
    // 8  .  .  .  ♛  .  .  .  .
    // 7  .  .  .  .  .  .  .  .
    // 6  .  .  .  .  .  .  .  .
    // 5  .  .  .  .  .  .  .  .
    // 4  .  .  .  ♘  .  .  .  .
    // 3  .  .  .  .  .  .  .  .
    // 2  .  .  .  .  .  .  .  .
    // 1  .  .  .  ♔  .  .  .  .
    //    a  b  c  d  e  f  g  h
    state = BoardState(
        whitePawns: .empty,
        whiteKnights: Bitboard.squareMask(.d4),
        whiteBishops: .empty,
        whiteRooks: .empty,
        whiteQueens: .empty,
        whiteKing: Bitboard.squareMask(.d1),
        blackPawns: .empty,
        blackKnights: .empty,
        blackBishops: .empty,
        blackRooks: .empty,
        blackQueens: Bitboard.squareMask(.d8),
        blackKing: .empty,
        plyNumber: 1,
        playerToMove: .white,
        enpassantTargetSqauare: .empty,
        castlingRights: [.K, .Q, .k, .q]
    )
    
    #expect(state.generateAllLegalMoves(.black).count == 18, "the queen has 18 moves it can move to")
    #expect(state.generateAllLegalMoves().count == 5, "only the king can move in this position")
    #expect(state.isValidMove(piece: .knight, from: .d4, to: .c6) == nil, "knight is pinned and can't move")
    #expect(state.isValidMove(piece: .knight, from: .d4, to: .e6) == nil, "knight is pinned and can't move")
    #expect(state.isValidMove(piece: .knight, from: .d4, to: .b5) == nil, "knight is pinned and can't move")
    #expect(state.isValidMove(piece: .knight, from: .d4, to: .f5) == nil, "knight is pinned and can't move")
    #expect(state.isValidMove(piece: .knight, from: .d4, to: .b3) == nil, "knight is pinned and can't move")
    #expect(state.isValidMove(piece: .knight, from: .d4, to: .f3) == nil, "knight is pinned and can't move")
    #expect(state.isValidMove(piece: .knight, from: .d4, to: .c2) == nil, "knight is pinned and can't move")
    #expect(state.isValidMove(piece: .knight, from: .d4, to: .e2) == nil, "knight is pinned and can't move")
    
    #expect(state.isValidMove(piece: .king, from: .d1, to: .c1) != nil, "king moves one square away")
    #expect(state.isValidMove(piece: .king, from: .d1, to: .c2) != nil, "king moves one square away")
    #expect(state.isValidMove(piece: .king, from: .d1, to: .d2) != nil, "king moves one square away")
    #expect(state.isValidMove(piece: .king, from: .d1, to: .e2) != nil, "king moves one square away")
    #expect(state.isValidMove(piece: .king, from: .d1, to: .e1) != nil, "king moves one square away")
}

@Test func testBishopMoves() async throws {
    var state = BoardState(
        whitePawns: .empty,
        whiteKnights: .empty,
        whiteBishops: Bitboard.squareMask(.d4),
        whiteRooks: .empty,
        whiteQueens: .empty,
        whiteKing: .empty,
        blackPawns: .empty,
        blackKnights: .empty,
        blackBishops: .empty,
        blackRooks: .empty,
        blackQueens: .empty,
        blackKing: .empty,
        plyNumber: 1,
        playerToMove: .white,
        enpassantTargetSqauare: .empty,
        castlingRights: [.K, .Q, .k, .q]
    )
    
    #expect(state.generateAllLegalMoves().count == 13, "a white bishop on d4 has 13 valid moves")
    #expect(state.isValidMove(piece: .bishop, from: .d4, to: .a1) != nil, "bishop should be able to go here")
    #expect(state.isValidMove(piece: .bishop, from: .d4, to: .b2) != nil, "bishop should be able to go here")
    #expect(state.isValidMove(piece: .bishop, from: .d4, to: .c3) != nil, "bishop should be able to go here")
    #expect(state.isValidMove(piece: .bishop, from: .d4, to: .e5) != nil, "bishop should be able to go here")
    #expect(state.isValidMove(piece: .bishop, from: .d4, to: .f6) != nil, "bishop should be able to go here")
    #expect(state.isValidMove(piece: .bishop, from: .d4, to: .g7) != nil, "bishop should be able to go here")
    #expect(state.isValidMove(piece: .bishop, from: .d4, to: .h8) != nil, "bishop should be able to go here")
    #expect(state.isValidMove(piece: .bishop, from: .d4, to: .a7) != nil, "bishop should be able to go here")
    #expect(state.isValidMove(piece: .bishop, from: .d4, to: .b6) != nil, "bishop should be able to go here")
    #expect(state.isValidMove(piece: .bishop, from: .d4, to: .c5) != nil, "bishop should be able to go here")
    #expect(state.isValidMove(piece: .bishop, from: .d4, to: .e3) != nil, "bishop should be able to go here")
    #expect(state.isValidMove(piece: .bishop, from: .d4, to: .f2) != nil, "bishop should be able to go here")
    #expect(state.isValidMove(piece: .bishop, from: .d4, to: .g1) != nil, "bishop should be able to go here")
    
    state = BoardState(
        whitePawns: .empty,
        whiteKnights: .empty,
        whiteBishops: Bitboard.squareMask(.h8),
        whiteRooks: .empty,
        whiteQueens: .empty,
        whiteKing: .empty,
        blackPawns: .empty,
        blackKnights: .empty,
        blackBishops: .empty,
        blackRooks: .empty,
        blackQueens: .empty,
        blackKing: .empty,
        plyNumber: 1,
        playerToMove: .white,
        enpassantTargetSqauare: .empty,
        castlingRights: [.K, .Q, .k, .q]
    )
    
    #expect(state.generateAllLegalMoves().count == 7, "a white bishop on h8 has 7 valid moves")
    #expect(state.isValidMove(piece: .bishop, from: .h8, to: .g7) != nil, "bishop should be able to go here")
    #expect(state.isValidMove(piece: .bishop, from: .h8, to: .f6) != nil, "bishop should be able to go here")
    #expect(state.isValidMove(piece: .bishop, from: .h8, to: .e5) != nil, "bishop should be able to go here")
    #expect(state.isValidMove(piece: .bishop, from: .h8, to: .d4) != nil, "bishop should be able to go here")
    #expect(state.isValidMove(piece: .bishop, from: .h8, to: .c3) != nil, "bishop should be able to go here")
    #expect(state.isValidMove(piece: .bishop, from: .h8, to: .b2) != nil, "bishop should be able to go here")
    #expect(state.isValidMove(piece: .bishop, from: .h8, to: .a1) != nil, "bishop should be able to go here")
    
    state = BoardState(
        whitePawns: .empty,
        whiteKnights: .empty,
        whiteBishops: Bitboard.squareMask(.h8),
        whiteRooks: .empty,
        whiteQueens: .empty,
        whiteKing: Bitboard.squareMask(.g7),
        blackPawns: .empty,
        blackKnights: .empty,
        blackBishops: .empty,
        blackRooks: .empty,
        blackQueens: .empty,
        blackKing: .empty,
        plyNumber: 1,
        playerToMove: .white,
        enpassantTargetSqauare: .empty,
        castlingRights: [.K, .Q, .k, .q]
    )
    
    #expect(state.generateAllLegalMoves().count == 7, "the king g7 has 7 valid moves, but the bishop is trapped")
    #expect(state.isValidMove(piece: .king, from: .g7, to: .g8) != nil, "king should be able to go here")
    #expect(state.isValidMove(piece: .king, from: .g7, to: .f8) != nil, "king should be able to go here")
    #expect(state.isValidMove(piece: .king, from: .g7, to: .f7) != nil, "king should be able to go here")
    #expect(state.isValidMove(piece: .king, from: .g7, to: .f6) != nil, "king should be able to go here")
    #expect(state.isValidMove(piece: .king, from: .g7, to: .g6) != nil, "king should be able to go here")
    #expect(state.isValidMove(piece: .king, from: .g7, to: .h6) != nil, "king should be able to go here")
    #expect(state.isValidMove(piece: .king, from: .g7, to: .h7) != nil, "king should be able to go here")
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
}
