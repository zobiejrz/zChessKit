//
//  GameTests.swift
//  zChessKit
//
//  Created by Ben Zobrist on 10/11/25.
//

import Testing
@testable import zChessKit

@Test func testGameMakeMove() async throws {
    let game = Game()
    
    #expect(game.makeMove(piece: .pawn, from: .e2, to: .e4), "Move was successfully made")
    #expect(game.makeMove(piece: .pawn, from: .e7, to: .e5), "Move was successfully made")

    #expect(!game.makeMove(piece: .pawn, from: .e2, to: .e4), "Invalid move was not made")
    #expect(!game.makeMove(piece: .pawn, from: .e7, to: .e5), "Invalid move was not made")
}

@Test func testGameMakeSANMove() async throws {
    let game = Game()
    
    #expect(game.makeSANMove("e4"), "Move was successfully made")
    #expect(game.makeSANMove("e5"), "Move was successfully made")
    
    #expect(!game.makeSANMove("e4"), "Invalid move was not made")
    #expect(!game.makeSANMove("e5"), "Invalid move was not made")
}

@Test func testGameCurrentState() async throws {
    let game = Game()
    
    #expect(game.currentState == game.initialBoardState, "The current board state is the initial board state")
    #expect(game.makeSANMove("e4"), "Move was successfully made")
    #expect(game.currentState != game.initialBoardState, "The current board state is no longer the initial board state")
    #expect(game.moves.last?.resultingBoardState == game.currentState, "The current board state is the resulting board state of the last move")
    #expect(game.makeSANMove("e5"), "Move was successfully made")
    #expect(game.moves.last?.resultingBoardState == game.currentState, "The current board state is the resulting board state of the last move")

}

@Test func testGameGamedata() async throws {
    let game = Game()
    
    #expect(game.gamedata["Event"] == nil, "Tag hasn't been set yet")
    game.setGamedata(for: "Event", value: "Live Event")
    #expect(game.gamedata["Event"] == "Live Event", "Values should match")
}

@Test func testGameAnnotation() async throws {
    let game = Game()
    
    #expect(game.makeSANMove("e4"), "Move was successfully made")
    
    // Shouldn't do anything
    game.setMoveAnnotation(to: -1, value: "The most common first move")
    game.setMoveAnnotation(to: 3, value: "The most common first move")

    // Should do something
    game.setMoveAnnotation(to: 0, value: "The most common first move")
    #expect(game.moves.first?.annotation == "The most common first move", "Strings should match")
    
}

@Test func testGameNAG() async throws {
    let game = Game()
    
    #expect(game.makeSANMove("e4"), "Move was successfully made")

    // Shouldn't do anything
    game.appendMoveNAG(to: 0, value: 140)
    game.appendMoveNAG(to: 0, value: -1)
    
    // Should do something
    game.appendMoveNAG(to: 0, value: 1)
    #expect(game.moves.first?.nags.count == 1, "One valid nag has been added")

    game.appendMoveNAG(to: 0, value: 1)
    #expect(game.moves.first?.nags.count == 1, "No duplicate nags have been added")
    game.appendMoveNAG(to: 0, value: 139)
    #expect(game.moves.first?.nags.count == 2, "A second valid nag has been added")

    // Shouldn't do anything
    game.removeMoveNAG(from: -1, indexInNAG: 0)
    game.removeMoveNAG(from: 0, indexInNAG: 4)
    #expect(game.moves.first?.nags.count == 2, "No nags removed")

    // Should do something
    game.removeMoveNAG(from: 0, indexInNAG: 0)
    game.removeMoveNAG(from: 0, indexInNAG: 0)
    #expect(game.moves.first?.nags.count == 0, "All nags removed")

}

@Test func testGameGetGameResult() async throws {
    let game = Game()
    
    game.setGamedata(for: "Result", value: "1/2-1/2")
    #expect(game.getGameResult() == .draw, "Result is set in the tags")
    
    game.setGamedata(for: "Result", value: "1-0")
    #expect(game.getGameResult() == .whiteWon, "Result is set in the tags")
    
    game.setGamedata(for: "Result", value: "0-1")
    #expect(game.getGameResult() == .blackWon, "Result is set in the tags")
    
    game.setGamedata(for: "Result", value: "*")
    #expect(game.getGameResult() == .ongoing, "Result is set in the tags")
    
    game.setGamedata(for: "Result", value: "weird text")
    #expect(game.getGameResult() == .ongoing, "Result is unexpected value, so pull from currentState")
    
    game.setGamedata(for: "Result", value: nil)
    #expect(game.getGameResult() == .ongoing, "Result is unset, pull from currentState")
    
    game.makeSANMove("f3")
    game.makeSANMove("e5")
    game.makeSANMove("g4")
    game.makeSANMove("Qh4#")
    
    game.setGamedata(for: "Result", value: nil)
    #expect(game.getGameResult() == .blackWon, "Game is ended in checkmate")
    
    let drawGame = Game(initialBoardState: BoardState.fromFEN("K7/1r6/2k5/8/8/8/8/8 w - - 0 1")!)
    #expect(drawGame.getGameResult() == .draw, "Game is ended in draw")    
}


@Test func testGameGetPGN() async throws {
    let game = Game()
    print(game.getPGN())
    
    game.makeSANMove("f3")
    game.makeSANMove("e5")
    game.makeSANMove("g4")
    game.makeSANMove("Qh4#")
    
    print(game.getPGN())
    
    // TODO: Not strictly following export format yet
}
