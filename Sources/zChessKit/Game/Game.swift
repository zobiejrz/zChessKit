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
    
    @discardableResult
    public func makeSANMove(_ san: String) -> Bool {
        // validate the move against the current boardstate
        // add it to the move list if it is valid
        
        if let resultingMove = self.currentState.isValidSANMove(san) {
            self.moves.append(resultingMove)
            return true
        }
        
        return false
    }
    
    @discardableResult
    public func makeUCIMove(_ uci: String) -> Bool {
        // validate the move against the current boardstate
        // add it to the move list if it is valid
        
        if let resultingMove = self.currentState.isValidUCIMove(uci) {
            self.moves.append(resultingMove)
            return true
        }
        return false
    }
    
    public func setGamedata(for key: String, value: String?) {
        self.gamedata[key] = value
    }
    
    public func setMoveAnnotation(to idx: Int, value: String?) {
        guard idx >= 0 && idx < self.moves.count else { return }
        self.moves[idx].annotation = value
    }
    
    public func appendMoveNAG(to idx: Int, value: Int) {
        guard idx >= 0 && idx < self.moves.count else { return }
        guard value >= 0 && value < 140 else { return }
        
        if !self.moves[idx].nags.contains(value) {
            self.moves[idx].nags.append(value)
        }
    }
    
    public func removeMoveNAG(from idx: Int, indexInNAG: Int) {
        guard idx >= 0 && idx < self.moves.count else { return }
        guard indexInNAG >= 0 && indexInNAG < self.moves[idx].nags.count else { return }
        self.moves[idx].nags.remove(at: indexInNAG)
    }
    
    public func getGameResult() -> GameResult {
        if let res = self.gamedata["Result"] {
            switch res {
            case "1/2-1/2":
                return .draw
            case "1-0":
                return .whiteWon
            case "0-1":
                return .blackWon
            case "*":
                return .ongoing
            default:
                break
            }
        }
        
        if self.currentState.generateAllLegalMoves().isEmpty {
            if self.currentState.isKingInCheck() {
                return self.currentState.playerToMove == .white ? .blackWon : .whiteWon
            } else {
                return .draw
            }
        }

        return .ongoing
    }
}
