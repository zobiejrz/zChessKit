//
//  Game.swift
//  zChessKit
//
//  Created by Ben Zobrist on 9/15/25.
//

import zBitboard

public class Game {
    public private(set) var gamedata: [ String : String ]
    public private(set) var moves: [Move]
    public let initialBoardState: BoardState
    
    public var currentState: BoardState {
        return moves.last?.resultingBoardState ?? initialBoardState
    }
    
    public init(
        gamedata: [String: String] = [:],
        moves: [Move] = [],
        initialBoardState: BoardState = BoardState.startingPosition(),
    ) {
        self.gamedata = gamedata
        self.moves = moves
        self.initialBoardState = initialBoardState
    }
    
    @discardableResult
    public func makeMove(piece: PieceType, from origin: Square, to dest: Square, promotion: PieceType? = nil) -> Bool {
        
        // validate the move against the current boardstate
        // add it to the move list if it is valid
        if let resultingMove = self.currentState.isValidMove(piece: piece, from: origin, to: dest, promotion: promotion) {
            self.moves.append(resultingMove)
            return true
        }
        return false
    }
    
    public func setGamedata(for key: String, value: String) {
        self.gamedata[key] = value
    }
    
    public func getPGN() -> String {
        // TODO: Placeholder
        // Format game data
        // Format move text
        // return string
        return ""
    }
    
    public func getGameResult() -> GameResult {
        if self.currentState.generateAllLegalMoves().isEmpty {
            if self.currentState.isKingInCheck() {
                return .checkmate
            } else {
                return .draw
            }
        }

        return .ongoing
    }
}
