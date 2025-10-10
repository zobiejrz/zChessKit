//
//  BoardState+whatPieceIsOn.swift
//  zChessKit
//
//  Created by Ben Zobrist on 10/9/25.
//

import zBitboard

extension BoardState {

    /// Gives information about what PieceType is on a given square
    public func whatPieceIsOn(_ square: Square) -> PieceType? {
        if (self.blackPawns | self.whitePawns).hasPiece(on: square) {
            return .pawn
        }
        if (self.blackKnights | self.whiteKnights).hasPiece(on: square) {
            return .knight
        }
        if (self.blackBishops | self.whiteBishops).hasPiece(on: square) {
            return .bishop
        }
        if (self.blackRooks | self.whiteRooks).hasPiece(on: square) {
            return .rook
        }
        if (self.blackQueens | self.whiteQueens).hasPiece(on: square) {
            return .queen
        }
        if (self.blackKing | self.whiteKing).hasPiece(on: square) {
            return .king
        }
        
        return nil
    }
}
