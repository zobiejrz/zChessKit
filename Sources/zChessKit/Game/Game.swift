//
//  Game.swift
//  zChessKit
//
//  Created by Ben Zobrist on 9/15/25.
//

import zBitboard

class Game {
    private(set) var gamedata: [ String : String ]
    private(set) var moves: [Move]
    let initialBoardState: BoardState
    
    var currentState: BoardState {
        return moves.last?.resultingBoardState ?? initialBoardState
    }
    
    init(
        gamedata: [String: String] = [:],
        moves: [Move] = [],
        initialBoardState: BoardState = BoardState.startingPosition(),
    ) {
        self.gamedata = gamedata
        self.moves = moves
        self.initialBoardState = initialBoardState
    }
    
    @discardableResult
    func makeMove(piece: PieceType, from origin: Square, to dest: Square, promotion: PieceType? = nil) -> Bool {
        
        // validate the move against the current boardstate
        // add it to the move list if it is valid
        if let resultingMove = self.currentState.isValidMove(piece: piece, from: origin, to: dest, promotion: promotion) {
            self.moves.append(resultingMove)
            return true
        }
        return false
    }
    
    func setGamedata(for key: String, value: String) {
        self.gamedata[key] = value
    }
    
    func getPGN() -> String {
        // TODO: Placeholder
        // Format game data
        // Format move text
        // return string
        return ""
    }
}
