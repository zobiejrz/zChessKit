//
//  BoardState+Equatable.swift
//  zChessKit
//
//  Created by Ben Zobrist on 9/22/25.
//

extension BoardState: Equatable {
    static func == (lhs: BoardState, rhs: BoardState) -> Bool {
        return (
            lhs.whitePawns == rhs.whitePawns &&
            lhs.whiteKnights == rhs.whiteKnights &&
            lhs.whiteBishops == rhs.whiteBishops &&
            lhs.whiteRooks == rhs.whiteRooks &&
            lhs.whiteQueens == rhs.whiteQueens &&
            lhs.whiteKing == rhs.whiteKing &&
            lhs.blackPawns == rhs.blackPawns &&
            lhs.blackKnights == rhs.blackKnights &&
            lhs.blackBishops == rhs.blackBishops &&
            lhs.blackRooks == rhs.blackRooks &&
            lhs.blackQueens == rhs.blackQueens &&
            lhs.blackKing == rhs.blackKing &&
            lhs.plyNumber == rhs.plyNumber &&
            lhs.playerToMove == rhs.playerToMove &&
            lhs.enpassantTargetSqauare == rhs.enpassantTargetSqauare &&
            lhs.castlingRights == rhs.castlingRights
        )
    }
}
