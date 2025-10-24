//
//  BoardStateTests.swift
//  zChessKit
//
//  Created by Ben Zobrist on 10/11/25.
//

import Testing
@testable import zChessKit

@Test func testBoardStateBoardString() async throws {
    let tokens = try! Lexer.getFENLexer().run(input: "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1 8/8/8/1P1p2qK/1P1P4/4kn2/8/8 w - - 3 61")
    let result = try! Parser.parseFEN(from: tokens)
    
    let boardString1 = """
        8  ♜  ♞  ♝  ♛  ♚  ♝  ♞  ♜ 
        7  ♟  ♟  ♟  ♟  ♟  ♟  ♟  ♟ 
        6  .  .  .  .  .  .  .  . 
        5  .  .  .  .  .  .  .  . 
        4  .  .  .  .  .  .  .  . 
        3  .  .  .  .  .  .  .  . 
        2  ♙  ♙  ♙  ♙  ♙  ♙  ♙  ♙ 
        1  ♖  ♘  ♗  ♕  ♔  ♗  ♘  ♖ 
           a  b  c  d  e  f  g  h
        
        """
    
    let boardString2 = """
        8  .  .  .  .  .  .  .  . 
        7  .  .  .  .  .  .  .  . 
        6  .  .  .  .  .  .  .  . 
        5  .  ♙  .  ♟  .  .  ♛  ♔ 
        4  .  ♙  .  ♙  .  .  .  . 
        3  .  .  .  .  ♚  ♞  .  . 
        2  .  .  .  .  .  .  .  . 
        1  .  .  .  .  .  .  .  . 
           a  b  c  d  e  f  g  h
        
        """
    
    #expect(result[0].boardString() == boardString1, "the output of boardString() should match the test boardString")
    #expect(result[1].boardString() == boardString2, "the output of boardString() should match the test boardString")
}

@Test func testBoardStateEquatable() async throws {
    let tokens = try! Lexer.getFENLexer().run(input: "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1 8/8/8/1P1p3K/1P1P4/4kn2/6q1/8 b - - 2 60 8/8/8/1P1p2qK/1P1P4/4kn2/8/8 w - - 3 61")
    let result = try! Parser.parseFEN(from: tokens)
    
    #expect(result[0] == result[0], "BoardState should be equal to itself")
    #expect(result[1] == result[1], "BoardState should be equal to itself")
    #expect(result[2] == result[2], "BoardState should be equal to itself")

    #expect(result[0] != result[1], "BoardState should NOT be equal to others")
    #expect(result[0] != result[2], "BoardState should NOT be equal to others")

    #expect(result[1] != result[0], "BoardState should NOT be equal to others")
    #expect(result[1] != result[2], "BoardState should NOT be equal to others")
    
    #expect(result[2] != result[0], "BoardState should NOT be equal to others")
    #expect(result[2] != result[1], "BoardState should NOT be equal to others")
    
    let transformedState = result[1].isValidSANMove("Qg5#")!.resultingBoardState
    #expect(transformedState == result[2], "resulting transformedState should be equal to the final state")
}

@Test func testBoardStateGenerateAllLegalMoves() async throws {
    // 00. can't O-O-O
    // 01. can't O-O-O
    // 02. can O-O-O
    // 03. only one legal move
    // 04. no legal moves
    // 05. black en passant en passant
    // 06. can't en passant due to pin
    // 07. can't O-O
    // 08. can't O-O
    // 09. can O-O
    // 10. starting position
    // 11. white promotion
    // 12. black promotion
    // 13. white en passant
    // 14. white capturing black rooks (check for castlingRights)
    // 15. black capturing white rooks (check for castlingRights)
    // 16. white capturing white rooks (check for castlingRights)
    // 17. black capturing black rooks (check for castlingRights)
    // 18. white capturing white rooks (check for castlingRights)
    // 19. black capturing black rooks (check for castlingRights)
    // 20. white capturing black rooks (check for castlingRights)
    // 21. white capturing black rooks (check for castlingRights)
    // 22. black capturing white rooks (check for castlingRights)
    // 23. black capturing white rooks (check for castlingRights)
    // 24. white capturing white rook (no change to castlingRights)
    // 25. black capturing white rook (no change to castlingRights)
    // 26. test SAN disambiguation generation
    let FENList = """
        3rk3/8/8/8/8/8/8/R3K3 w Q - 0 1
        2r1k3/8/8/8/8/8/8/R3K3 w Q - 1 1
        1r2k3/8/8/8/8/8/8/R3K3 w Q - 0 1
        r2qkbnr/ppp2Bpp/2np4/4N3/4P3/2N4P/PPPP1PP1/R1BbK2R b KQ - 1 8
        r2q1bnr/ppp1kBpp/2np4/3NN3/4P3/7P/PPPP1PP1/R1BbK2R b KQ - 2 8
        r3k2r/pbppqpb1/1pn3p1/7p/1N2pPn1/1PP4N/PB1P2PP/2QRKR2 b kq f3 0 1
        8/8/4k3/8/3Pp3/8/8/4R1K1 b - d3 0 1
        4k3/8/8/1b6/8/8/8/4K2R w K - 0 1
        4k3/8/1b6/8/8/8/8/4K2R w K - 0 1
        4k3/1b6/8/8/8/8/8/4K2R w K - 0 1
        rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1
        8/4KPk1/8/8/8/8/8/8 w - - 0 1
        8/8/8/8/8/8/4kpK1/8 b - - 0 1
        8/8/8/4Pp2/3K4/8/k7/8 w - f6 0 2
        r1b1k2r/5N2/1N6/3QB3/3b4/1n6/5nq1/R3KB1R w KQkq - 0 1
        r1b1k2r/5N2/1N6/3QB3/3b4/1n6/5nq1/R3KB1R b KQkq - 0 1
        r3k2r/6Q1/8/3B4/4b3/8/1q6/R3K2R w KQkq - 0 1
        r3k2r/6Q1/8/3B4/4b3/8/1q6/R3K2R b KQkq - 0 1
        r3k2r/1P4P1/8/8/8/8/1p4p1/R3K2R w KQkq - 0 1
        r3k2r/1P4P1/8/8/8/8/1p4p1/R3K2R b KQkq - 0 1
        r3k2r/6K1/8/8/8/8/8/8 w kq - 0 1
        r3k2r/1K6/8/8/8/8/8/8 w kq - 0 1
        8/8/8/8/8/8/6k1/R3K2R b KQ - 0 1
        8/8/8/8/8/8/1k6/R3K2R b KQ - 0 1
        8/3nprk1/5Rq1/6b1/1B6/1Qr5/1KRPN3/8 w - - 0 1
        8/3nprk1/5Rq1/6b1/1B6/1Qr5/1KRPN3/8 b - - 0 1
        1k6/8/8/8/6Q1/8/4Q1Q1/5K2 w - - 0 1
        """
    
    let tokens = try! Lexer.getFENLexer().run(input: FENList)
    let result = try! Parser.parseFEN(from: tokens)
    var allLegalMoves: [Move] = []
    
    allLegalMoves = result[0].generateAllLegalMoves()
    #expect(allLegalMoves.count == 13, "13 moves are available in this position")
    #expect(allLegalMoves.filter({ $0.piece == .king }).count == 3, "3 moves are available in this position to the king")
    #expect(allLegalMoves.filter({ $0.piece == .rook }).count == 10, "10 moves are available in this position to the rook")
    
    allLegalMoves = result[1].generateAllLegalMoves()
    #expect(allLegalMoves.count == 15, "15 moves are available in this position")
    #expect(allLegalMoves.filter({ $0.piece == .king }).count == 5, "5 moves are available in this position to the king")
    #expect(allLegalMoves.filter({ $0.piece == .rook }).count == 10, "10 moves are available in this position to the rook")
    
    allLegalMoves = result[2].generateAllLegalMoves()
    #expect(allLegalMoves.count == 16, "16 moves are available in this position")
    #expect(allLegalMoves.filter({ $0.piece == .king }).count == 6, "6 moves are available in this position to the king")
    #expect(allLegalMoves.filter({ $0.piece == .rook }).count == 10, "10 moves are available in this position to the rook")
    
    allLegalMoves = result[3].generateAllLegalMoves()
    #expect(allLegalMoves.count == 1, "1 move is available in this position")
    #expect(allLegalMoves.filter({ $0.piece == .king }).count == 1, "1 move is available in this position to the king")
    
    allLegalMoves = result[4].generateAllLegalMoves()
    #expect(allLegalMoves.count == 0, "no move is available in this position")
    #expect(result[4].isKingInCheck(), "the king should be in check")
    
    allLegalMoves = result[5].generateAllLegalMoves()
    #expect(allLegalMoves.count == 52, "52 moves are available in this position")
    #expect(allLegalMoves.filter({ $0.piece == .king }).count == 4, "4 moves are available in this position to the king")
    #expect(allLegalMoves.filter({ $0.piece == .queen }).count == 10, "10 moves are available in this position to the queen")
    #expect(allLegalMoves.filter({ $0.piece == .rook }).count == 7, "7 moves are available in this position to the rooks")
    #expect(allLegalMoves.filter({ $0.piece == .bishop }).count == 8, "8 moves are available in this position to the bishops")
    #expect(allLegalMoves.filter({ $0.piece == .knight }).count == 12, "12 moves are available in this position to the knights")
    #expect(allLegalMoves.filter({ $0.piece == .pawn }).count == 11, "11 moves are available in this position to the pawns")
    #expect(result[5].isValidSANMove("exf3#")!.resultingBoardState.generateAllLegalMoves().count == 0, "0 moves are available in this position after capturing en passant")
    
    allLegalMoves = result[6].generateAllLegalMoves()
    #expect(allLegalMoves.count == 8, "8 moves are available in this position")
    #expect(allLegalMoves.filter({ $0.piece == .king }).count == 7, "7 moves are available in this position to the king")
    #expect(allLegalMoves.filter({ $0.piece == .pawn }).count == 1, "1 moves are available in this position to the pawns")
    #expect(result[5].isValidSANMove("exd3") == nil, "capturing en passant isn't available in this position due to a pin")
    
    allLegalMoves = result[7].generateAllLegalMoves()
    #expect(allLegalMoves.count == 12, "12 moves are available in this position")
    #expect(allLegalMoves.filter({ $0.piece == .king }).count == 3, "3 moves are available in this position to the king")
    #expect(allLegalMoves.filter({ $0.piece == .rook }).count == 9, "9 moves are available in this position to the rook")
    
    allLegalMoves = result[8].generateAllLegalMoves()
    #expect(allLegalMoves.count == 13, "13 moves are available in this position")
    #expect(allLegalMoves.filter({ $0.piece == .king }).count == 4, "4 moves are available in this position to the king")
    #expect(allLegalMoves.filter({ $0.piece == .rook }).count == 9, "9 moves are available in this position to the rook")
    
    allLegalMoves = result[9].generateAllLegalMoves()
    #expect(allLegalMoves.count == 15, "15 moves are available in this position")
    #expect(allLegalMoves.filter({ $0.piece == .king }).count == 6, "6 moves are available in this position to the king")
    #expect(allLegalMoves.filter({ $0.piece == .rook }).count == 9, "9 moves are available in this position to the rook")
    
    allLegalMoves = result[10].generateAllLegalMoves()
    #expect(allLegalMoves.count == 20, "20 moves are available in this position")
    #expect(allLegalMoves.filter({ $0.piece == .king }).count == 0, "0 moves are available in this position to the king")
    #expect(allLegalMoves.filter({ $0.piece == .queen }).count == 0, "0 moves are available in this position to the queen")
    #expect(allLegalMoves.filter({ $0.piece == .rook }).count == 0, "0 moves are available in this position to the rooks")
    #expect(allLegalMoves.filter({ $0.piece == .bishop }).count == 0, "0 moves are available in this position to the bishops")
    #expect(allLegalMoves.filter({ $0.piece == .knight }).count == 4, "4 moves are available in this position to the knights")
    #expect(allLegalMoves.filter({ $0.piece == .pawn }).count == 16, "16 moves are available in this position to the pawns")
    #expect(result[5].isValidSANMove("exf3#")!.resultingBoardState.generateAllLegalMoves().count == 0, "0 moves are available in this position after capturing en passant")
    
    allLegalMoves = result[11].generateAllLegalMoves()
    #expect(allLegalMoves.count == 9, "9 moves are available in this position")
    #expect(allLegalMoves.filter({ $0.piece == .king }).count == 5, "5 moves are available in this position to the king")
    #expect(allLegalMoves.filter({ $0.piece == .pawn }).count == 4, "4 moves are available in this position to the pawn")
    #expect(result[11].isValidSANMove("f8=N")!.resultingBoardState.generateAllLegalMoves().count == 3, "3 moves are available in this position after promoting")
    #expect(result[11].isValidSANMove("f8=B")!.resultingBoardState.generateAllLegalMoves().count == 4, "4 moves are available in this position after promoting")
    #expect(result[11].isValidSANMove("f8=R")!.resultingBoardState.generateAllLegalMoves().count == 3, "3 moves are available in this position after promoting")
    #expect(result[11].isValidSANMove("f8=Q")!.resultingBoardState.generateAllLegalMoves().count == 2, "2 moves are available in this position after promoting")
    
    allLegalMoves = result[12].generateAllLegalMoves()
    #expect(allLegalMoves.count == 9, "9 moves are available in this position")
    #expect(allLegalMoves.filter({ $0.piece == .king }).count == 5, "5 moves are available in this position to the king")
    #expect(allLegalMoves.filter({ $0.piece == .pawn }).count == 4, "4 moves are available in this position to the pawn")
    #expect(result[11].isValidSANMove("f8=N")!.resultingBoardState.generateAllLegalMoves().count == 3, "3 moves are available in this position after promoting")
    #expect(result[11].isValidSANMove("f8=B")!.resultingBoardState.generateAllLegalMoves().count == 4, "4 moves are available in this position after promoting")
    #expect(result[11].isValidSANMove("f8=R")!.resultingBoardState.generateAllLegalMoves().count == 3, "3 moves are available in this position after promoting")
    #expect(result[11].isValidSANMove("f8=Q")!.resultingBoardState.generateAllLegalMoves().count == 2, "2 moves are available in this position after promoting")
    
    allLegalMoves = result[13].generateAllLegalMoves()
    #expect(allLegalMoves.count == 8, "8 moves are available in this position")
    #expect(allLegalMoves.filter({ $0.piece == .king }).count == 6, "6 moves are available in this position to the king")
    #expect(allLegalMoves.filter({ $0.piece == .pawn }).count == 2, "2 moves are available in this position to the pawns")
    #expect(result[13].isValidSANMove("exf6")!.resultingBoardState.generateAllLegalMoves().count == 5, "5 moves are available in this position after capturing en passant")
    
    allLegalMoves = result[14].generateAllLegalMoves()
    #expect(result[14].isValidSANMove("Bxh8")!.resultingBoardState.castlingRights.count == 3, "3 castling rights remain")
    #expect(result[14].isValidSANMove("Qxa8")!.resultingBoardState.castlingRights.count == 3, "3 castling rights remain")
    #expect(result[14].isValidSANMove("Rxh8")!.resultingBoardState.castlingRights.count == 2, "2 castling rights remain")
    #expect(result[14].isValidSANMove("Rxa8")!.resultingBoardState.castlingRights.count == 2, "2 castling rights remain")
    #expect(result[14].isValidSANMove("Nxa8")!.resultingBoardState.castlingRights.count == 3, "3 castling rights remain")
    #expect(result[14].isValidSANMove("Nxh8")!.resultingBoardState.castlingRights.count == 3, "3 castling rights remain")
    
    allLegalMoves = result[15].generateAllLegalMoves()
    #expect(result[15].isValidSANMove("Bxa1")!.resultingBoardState.castlingRights.count == 3, "3 castling rights remain")
    #expect(result[15].isValidSANMove("Qxh1")!.resultingBoardState.castlingRights.count == 3, "3 castling rights remain")
    #expect(result[15].isValidSANMove("Rxh1")!.resultingBoardState.castlingRights.count == 2, "2 castling rights remain")
    #expect(result[15].isValidSANMove("Rxa1")!.resultingBoardState.castlingRights.count == 2, "2 castling rights remain")
    #expect(result[15].isValidSANMove("Nxa1")!.resultingBoardState.castlingRights.count == 3, "3 castling rights remain")
    #expect(result[15].isValidSANMove("Nxh1")!.resultingBoardState.castlingRights.count == 3, "3 castling rights remain")
    
    allLegalMoves = result[16].generateAllLegalMoves()
    #expect(result[16].isValidSANMove("Bxa8")!.resultingBoardState.castlingRights.count == 3, "3 castling rights remain")
    #expect(result[16].isValidSANMove("Qxh8")!.resultingBoardState.castlingRights.count == 3, "3 castling rights remain")

    allLegalMoves = result[17].generateAllLegalMoves()
    #expect(result[17].isValidSANMove("Bxh1")!.resultingBoardState.castlingRights.count == 3, "3 castling rights remain")
    #expect(result[17].isValidSANMove("Qxa1")!.resultingBoardState.castlingRights.count == 3, "3 castling rights remain")

    allLegalMoves = result[18].generateAllLegalMoves()
    #expect(result[18].isValidSANMove("bxa8=B")!.resultingBoardState.castlingRights.count == 3, "3 castling rights remain")
    #expect(result[18].isValidSANMove("gxh8=B")!.resultingBoardState.castlingRights.count == 3, "3 castling rights remain")

    allLegalMoves = result[19].generateAllLegalMoves()
    #expect(result[19].isValidSANMove("bxa1=B")!.resultingBoardState.castlingRights.count == 3, "3 castling rights remain")
    #expect(result[19].isValidSANMove("gxh1=B")!.resultingBoardState.castlingRights.count == 3, "3 castling rights remain")
    
    allLegalMoves = result[20].generateAllLegalMoves()
    #expect(result[20].isValidSANMove("Kxh8")!.resultingBoardState.castlingRights.count == 1, "1 castling rights remain")
    
    allLegalMoves = result[21].generateAllLegalMoves()
    #expect(result[21].isValidSANMove("Kxa8")!.resultingBoardState.castlingRights.count == 1, "1 castling rights remain")
    
    allLegalMoves = result[22].generateAllLegalMoves()
    #expect(result[22].isValidSANMove("Kxh1")!.resultingBoardState.castlingRights.count == 1, "1 castling rights remain")
    
    allLegalMoves = result[23].generateAllLegalMoves()
    #expect(result[23].isValidSANMove("Kxa1")!.resultingBoardState.castlingRights.count == 1, "1 castling rights remain")
    
    allLegalMoves = result[24].generateAllLegalMoves()
    #expect(result[24].isValidSANMove("dxc3")!.resultingBoardState.castlingRights == result[24].castlingRights, "No change to castling rights")
    #expect(result[24].isValidSANMove("Nxc3")!.resultingBoardState.castlingRights == result[24].castlingRights, "No change to castling rights")
    #expect(result[24].isValidSANMove("Bxc3")!.resultingBoardState.castlingRights == result[24].castlingRights, "No change to castling rights")
    #expect(result[24].isValidSANMove("Rxc3")!.resultingBoardState.castlingRights == result[24].castlingRights, "No change to castling rights")
    #expect(result[24].isValidSANMove("Qxc3")!.resultingBoardState.castlingRights == result[24].castlingRights, "No change to castling rights")
    #expect(result[24].isValidSANMove("Kxc3")!.resultingBoardState.castlingRights == result[24].castlingRights, "No change to castling rights")

    allLegalMoves = result[25].generateAllLegalMoves()
    #expect(result[25].isValidSANMove("exf6")!.resultingBoardState.castlingRights == result[25].castlingRights, "No change to castling rights")
    #expect(result[25].isValidSANMove("Nxf6")!.resultingBoardState.castlingRights == result[25].castlingRights, "No change to castling rights")
    #expect(result[25].isValidSANMove("Bxf6")!.resultingBoardState.castlingRights == result[25].castlingRights, "No change to castling rights")
    #expect(result[25].isValidSANMove("Rxf6")!.resultingBoardState.castlingRights == result[25].castlingRights, "No change to castling rights")
    #expect(result[25].isValidSANMove("Qxf6")!.resultingBoardState.castlingRights == result[25].castlingRights, "No change to castling rights")
    #expect(result[25].isValidSANMove("Kxf6")!.resultingBoardState.castlingRights == result[25].castlingRights, "No change to castling rights")

    allLegalMoves = result[26].generateAllLegalMoves()
    #expect(result[26].isValidSANMove("Qg3+") == nil, "Disambiguation is needed")
    #expect(result[26].isValidSANMove("Q2g3+") != nil, "Disambiguation is NOT needed")
    #expect(result[26].isValidSANMove("Q4g3+") != nil, "Disambiguation is NOT needed")
    #expect(result[26].isValidSANMove("Qf2") == nil, "Disambiguation is needed")
    #expect(result[26].isValidSANMove("Qef2") != nil, "Disambiguation is NOT needed")
    #expect(result[26].isValidSANMove("Qgf2") != nil, "Disambiguation is NOT needed")
    #expect(result[26].isValidSANMove("Qe4") == nil, "Disambiguation is needed")
    #expect(result[26].isValidSANMove("Qee4") != nil, "Disambiguation is NOT needed")
    #expect(result[26].isValidSANMove("Qg2e4") != nil, "Disambiguation is NOT needed")
    #expect(result[26].isValidSANMove("Qg4e4") != nil, "Disambiguation is NOT needed")
}

@Test func testBoardStateWhatPieceIsOn() async throws {
    let tokens = try! Lexer.getFENLexer().run(input: "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1")
    let result = try! Parser.parseFEN(from: tokens)
    
    #expect(result[0].whatPieceIsOn(.e1) == .king, "There is a king on this square")
    #expect(result[0].whatPieceIsOn(.e8) == .king, "There is a king on this square")
    
    #expect(result[0].whatPieceIsOn(.d1) == .queen, "There is a queen on this square")
    #expect(result[0].whatPieceIsOn(.d8) == .queen, "There is a queen on this square")

    #expect(result[0].whatPieceIsOn(.a1) == .rook, "There is a rook on this square")
    #expect(result[0].whatPieceIsOn(.h1) == .rook, "There is a rook on this square")
    #expect(result[0].whatPieceIsOn(.a8) == .rook, "There is a rook on this square")
    #expect(result[0].whatPieceIsOn(.h8) == .rook, "There is a rook on this square")

    #expect(result[0].whatPieceIsOn(.b1) == .knight, "There is a knight on this square")
    #expect(result[0].whatPieceIsOn(.g1) == .knight, "There is a knight on this square")
    #expect(result[0].whatPieceIsOn(.b8) == .knight, "There is a knight on this square")
    #expect(result[0].whatPieceIsOn(.g8) == .knight, "There is a knight on this square")
    
    #expect(result[0].whatPieceIsOn(.c1) == .bishop, "There is a bishop on this square")
    #expect(result[0].whatPieceIsOn(.f1) == .bishop, "There is a bishop on this square")
    #expect(result[0].whatPieceIsOn(.c8) == .bishop, "There is a bishop on this square")
    #expect(result[0].whatPieceIsOn(.f8) == .bishop, "There is a bishop on this square")
    
    #expect(result[0].whatPieceIsOn(.a2) == .pawn, "There is a pawn on this square")
    #expect(result[0].whatPieceIsOn(.b2) == .pawn, "There is a pawn on this square")
    #expect(result[0].whatPieceIsOn(.c2) == .pawn, "There is a pawn on this square")
    #expect(result[0].whatPieceIsOn(.d2) == .pawn, "There is a pawn on this square")
    #expect(result[0].whatPieceIsOn(.e2) == .pawn, "There is a pawn on this square")
    #expect(result[0].whatPieceIsOn(.f2) == .pawn, "There is a pawn on this square")
    #expect(result[0].whatPieceIsOn(.g2) == .pawn, "There is a pawn on this square")
    #expect(result[0].whatPieceIsOn(.h2) == .pawn, "There is a pawn on this square")
    #expect(result[0].whatPieceIsOn(.a7) == .pawn, "There is a pawn on this square")
    #expect(result[0].whatPieceIsOn(.b7) == .pawn, "There is a pawn on this square")
    #expect(result[0].whatPieceIsOn(.c7) == .pawn, "There is a pawn on this square")
    #expect(result[0].whatPieceIsOn(.d7) == .pawn, "There is a pawn on this square")
    #expect(result[0].whatPieceIsOn(.e7) == .pawn, "There is a pawn on this square")
    #expect(result[0].whatPieceIsOn(.f7) == .pawn, "There is a pawn on this square")
    #expect(result[0].whatPieceIsOn(.g7) == .pawn, "There is a pawn on this square")
    #expect(result[0].whatPieceIsOn(.h7) == .pawn, "There is a pawn on this square")

}

@Test func testBoardStateIsValidSANMove() async throws {
    let whiteState = BoardState.startingPosition()
    
    #expect(whiteState.isValidSANMove("e4") != nil, "This is a valid SAN move")
    #expect(whiteState.isValidSANMove("e2e4") != nil, "This is a valid SAN move")
    #expect(whiteState.isValidSANMove("ee4") != nil, "This is a valid SAN move")
    #expect(whiteState.isValidSANMove("2e4") != nil, "This is a valid SAN move")

    #expect(whiteState.isValidSANMove("Nc3") != nil, "This is a valid SAN move")
    #expect(whiteState.isValidSANMove("Nb1c3") != nil, "This is a valid SAN move")
    #expect(whiteState.isValidSANMove("Nbc3") != nil, "This is a valid SAN move")
    #expect(whiteState.isValidSANMove("N1c3") != nil, "This is a valid SAN move")
    
    #expect(whiteState.isValidSANMove("3e4") == nil, "This is an invalid SAN move")
    #expect(whiteState.isValidSANMove("O-O") == nil, "This is an invalid SAN move")
    #expect(whiteState.isValidSANMove("O-O-O") == nil, "This is an invalid SAN move")
    #expect(whiteState.isValidSANMove("x") == nil, "This is an invalid SAN move")
    #expect(whiteState.isValidSANMove("h9") == nil, "This is an invalid SAN move")
    #expect(whiteState.isValidSANMove("Nh9c3") == nil, "This is an invalid SAN move")
    #expect(whiteState.isValidSANMove("N9c3") == nil, "This is an invalid SAN move")
    #expect(whiteState.isValidSANMove("N*c3") == nil, "This is an invalid SAN move")
    #expect(whiteState.isValidSANMove("Nabcc3") == nil, "This is an invalid SAN move")
    #expect(whiteState.isValidSANMove("Njc3") == nil, "This is an invalid SAN move")
    #expect(whiteState.isValidSANMove("e8=Q") == nil, "This is an invalid SAN move")
    #expect(whiteState.isValidSANMove("e8=P") == nil, "This is an invalid SAN move")

    let tokens = try! Lexer.getFENLexer().run(input: "7r/8/5k2/8/8/8/6pr/1K6 b - - 0 1")
    let result = try! Parser.parseFEN(from: tokens)
    let blackState = result.first!
    
    #expect(blackState.isValidSANMove("g1=N") != nil, "This is a valid SAN move")
    #expect(blackState.isValidSANMove("g1=B") != nil, "This is a valid SAN move")
    #expect(blackState.isValidSANMove("g1=R#") != nil, "This is a valid SAN move")
    #expect(blackState.isValidSANMove("g1=Q#") != nil, "This is a valid SAN move")

    #expect(blackState.isValidSANMove("Rh1+") != nil, "This is a valid SAN move")
    #expect(blackState.isValidSANMove("Ra8") != nil, "This is a valid SAN move")
    #expect(blackState.isValidSANMove("Rb8+") != nil, "This is a valid SAN move")
    #expect(blackState.isValidSANMove("Rc8") != nil, "This is a valid SAN move")
    #expect(blackState.isValidSANMove("Rd8") != nil, "This is a valid SAN move")
    #expect(blackState.isValidSANMove("Re8") != nil, "This is a valid SAN move")
    #expect(blackState.isValidSANMove("Rf8") != nil, "This is a valid SAN move")
    #expect(blackState.isValidSANMove("Rg8") != nil, "This is a valid SAN move")

    #expect(blackState.isValidSANMove("Rh7") == nil, "This is an invalid SAN move")
    #expect(blackState.isValidSANMove("Rh6") == nil, "This is an invalid SAN move")
    #expect(blackState.isValidSANMove("Rh5") == nil, "This is an invalid SAN move")
    #expect(blackState.isValidSANMove("Rh4") == nil, "This is an invalid SAN move")
    #expect(blackState.isValidSANMove("Rh3") == nil, "This is an invalid SAN move")
    #expect(blackState.isValidSANMove("Rhh7") == nil, "This is an invalid SAN move")
    #expect(blackState.isValidSANMove("Rhh6") == nil, "This is an invalid SAN move")
    #expect(blackState.isValidSANMove("Rhh5") == nil, "This is an invalid SAN move")
    #expect(blackState.isValidSANMove("Rhh4") == nil, "This is an invalid SAN move")
    #expect(blackState.isValidSANMove("Rhh3") == nil, "This is an invalid SAN move")

    #expect(blackState.isValidSANMove("Rh8h7") != nil, "This is a valid SAN move")
    #expect(blackState.isValidSANMove("R8h7") != nil, "This is a valid SAN move")
    #expect(blackState.isValidSANMove("R8h6") != nil, "This is a valid SAN move")
    #expect(blackState.isValidSANMove("R8h5") != nil, "This is a valid SAN move")
    #expect(blackState.isValidSANMove("R8h4") != nil, "This is a valid SAN move")
    #expect(blackState.isValidSANMove("R8h3") != nil, "This is a valid SAN move")
    #expect(blackState.isValidSANMove("R2h7") != nil, "This is a valid SAN move")
    #expect(blackState.isValidSANMove("R2h6") != nil, "This is a valid SAN move")
    #expect(blackState.isValidSANMove("R2h5") != nil, "This is a valid SAN move")
    #expect(blackState.isValidSANMove("R2h4") != nil, "This is a valid SAN move")
    #expect(blackState.isValidSANMove("R2h3") != nil, "This is a valid SAN move")

    #expect(blackState.isValidSANMove("0-0") == nil, "This is an invalid SAN move")
    #expect(blackState.isValidSANMove("0-0-0") == nil, "This is an invalid SAN move")
}


@Test func testBoardStateIsValidMove() async throws {
    let state = BoardState.fromFEN("rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1")!
    
    #expect(state.isValidMove(piece: .pawn, from: .e2, to: .e4, promotion: nil) != nil, "This is an valid move")
    #expect(state.isValidMove(piece: .pawn, from: .e3, to: .e4, promotion: nil) == nil, "This is an invalid move")

}

@Test func testInvalidBoardState() async throws {
    
    let invalidStates = [
        "rnbqkbnr/pppppppp/8/9/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1",
        "rnbqkbnr/ppppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1",
        "rnbqkbnr/pppppppp/8/8/8/8/ZZZZZZZZ/RNBQKBNR w KQkq - 0 1",
        "THIS IS INVALID FEN",
        "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1 2",
        "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 1",
        "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq 0 1",
        "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w - 0 1",
        "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR KQkq - 0 1",
        "w KQkq - 0 1",
        "rnbqkbnr/pppppppp//PPPPPPPP/RNBQKBNR w KQkq - 0 1",
        "rn%qkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1",
        "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR ; KQkq - 0 1",
        "rnbqkbnr/pppp3ppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1",
        "rnbqkbnr/3ppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"
    ]
    
    for (i, str) in invalidStates.enumerated() {
        let state = BoardState.fromFEN(str)
        #expect(state == nil, "This is an invalid FEN")
//        print("string \(i) = \(state == nil ? "passed": "failed")")
    }
}

@Test func testDisambiguation() async throws {
    let PGN = """
        [Event "?"]
        [Site "?"]
        [Date "????.??.??"]
        [Round "?"]
        [White "?"]
        [Black "?"]
        [Result "*"]
        
        1. h3 $6 h6 $6 2. b3 $6 c6 3. e3 g6 $6 4. a4 $6 Nf6 $6 5. Ke2 $2 d6 6. Ra2 $2 h5 $9 7. a5 $9
        h4 $9 8. Ra3 $9 g5 $6 9. b4 $2 a6 $9 10. Rc3 $9 Ne4 $9 11. Rd3 $9 e5 12. Ra3 $6 d5 $6 13.
        f3 $2 Ng3+ $1 14. Kf2 c5 15. Bb2 cxb4 16. Rd3 b3 $6 17. c4 b5 18. Qe1 $6 bxc4 19. Nc3
        cxd3 20. Nxd5 $2 Nxf1 $9 21. Ne2 dxe2 22. Nb4 g4 23. Bc3 gxf3 24. Kg1 fxg2 25.
        Qxf1 $2 e1=N $9 26. Nxa6 $6 gxf1=N 27. d4 b2 28. d5 b1=Q 29. Nc5 $6 f6 $9 30. Bd2 Nc2
        31. Bb4 Nfxe3+ 32. Be1 Nxe1 $9 33. Nd3 Nxd3+ 34. Kh2 Ne1 35. a6 $6 Nc4 $9 36. Rxe1
        Nd2 37. Re2 Nf3+ 38. Kg2 e4 39. Rxe4+ Qxe4 40. a7 Nd2+ 41. Kf2 Nc4 $9 42. axb8=B
        Nd2 43. Bh2 $6 Nb1 $9 44. Bc7 Nd2 45. Bb8 $6 Nb1 $9 46. Bd6 Nd2 47. Be7 Nb3 48. Bxd8
        f5 49. Kf1 Nd2+ 50. Kg1 Nf3+ *
        """
    
    let tokens = try! Lexer.getPGNLexer().run(input: PGN)
    let result = try! Parser.parsePGN(from: tokens)
    let game = result.first!
    
    print(game.getPGN())
}
