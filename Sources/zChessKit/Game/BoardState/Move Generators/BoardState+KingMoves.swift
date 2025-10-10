//
//  BoardState+KingMoves.swift
//  zChessKit
//
//  Created by Ben Zobrist on 10/9/25.
//

import zBitboard

extension BoardState {
    
    /// Generates pseudo-legal moves for the white king
    internal func generateWhiteKingMoves() -> [(from: Bitboard,  to: Bitboard)] {
        // - Move one square in any direction
        // - Castling (if legal)
        guard let tmp = self.whiteKing.popLSB() else { return [] }
        guard let originSquare = Square(rawValue: tmp.0) else { return [] }
        
        let origin: Bitboard = Bitboard.squareMask(originSquare)
        
        // generate cardinal direction moves
        var total = (
            origin.nShift() | origin.neShift() |
            origin.eShift() | origin.seShift() |
            origin.sShift() | origin.swShift() |
            origin.wShift() | origin.nwShift()
        ) & ~self.whitePieces
        
        // add castling moves
        if self.castlingRights.contains(.K) && originSquare == .e1 && !self.isKingInCheck(.white) {
            if !self.allPieces.hasPiece(on: .f1) && !self.allPieces.hasPiece(on: .g1) && self.whiteRooks.hasPiece(on: .h1) {
                if !self.isKingInCheck(.white, kingLocation: Bitboard.squareMask(.f1)) {
                    total |= Bitboard.squareMask(.g1)
                }
            }
        }
        if self.castlingRights.contains(.Q) && originSquare == .e1 && !self.isKingInCheck(.white) {
            if !self.allPieces.hasPiece(on: .d1) && !self.allPieces.hasPiece(on: .c1) && !self.allPieces.hasPiece(on: .b1) && self.whiteRooks.hasPiece(on: .a1) {
                if !self.isKingInCheck(.white, kingLocation: Bitboard.squareMask(.d1)) {
                    total |= Bitboard.squareMask(.c1)
                }
            }
        }
        
        // return possible moves
        var output: [(from: Bitboard,  to: Bitboard)] = []
        while total != Bitboard.empty {
            guard let curr = total.popLSB() else { break }
            total = curr.1
            output.append((origin, Bitboard.squareMask(Square(rawValue: curr.0)!)))
        }
        
        return output
    }
    
    /// Generates pseudo-legal moves for the black king
    internal func generateBlackKingMoves() -> [(from: Bitboard,  to: Bitboard)] {
        // - Move one square in any direction
        // - Castling (if legal)
        guard let tmp = self.blackKing.popLSB() else { return [] }
        guard let originSquare = Square(rawValue: tmp.0) else { return [] }
        
        let origin: Bitboard = Bitboard.squareMask(originSquare)
        
        // generate cardinal direction moves
        var total = (
            origin.nShift() | origin.neShift() |
            origin.eShift() | origin.seShift() |
            origin.sShift() | origin.swShift() |
            origin.wShift() | origin.nwShift()
        ) & ~self.blackPieces
        
        // add castling moves
        if self.castlingRights.contains(.k) && originSquare == .e8 && !self.isKingInCheck(.black) {
            if !self.allPieces.hasPiece(on: .f8) && !self.allPieces.hasPiece(on: .g8) && self.blackRooks.hasPiece(on: .h8) {
                if !self.isKingInCheck(.black, kingLocation: Bitboard.squareMask(.f8)) {
                    total |= Bitboard.squareMask(.g8)
                }
            }
        }
        if self.castlingRights.contains(.q) && originSquare == .e8 && !self.isKingInCheck(.black) {
            if !self.allPieces.hasPiece(on: .d8) && !self.allPieces.hasPiece(on: .c8) && !self.allPieces.hasPiece(on: .b8) && self.blackRooks.hasPiece(on: .a8) {
                if !self.isKingInCheck(.black, kingLocation: Bitboard.squareMask(.d8)) {
                    total |= Bitboard.squareMask(.c8)
                }
            }
        }
        
        // return possible moves
        var output: [(from: Bitboard,  to: Bitboard)] = []
        while total != Bitboard.empty {
            guard let curr = total.popLSB() else { break }
            total = curr.1
            output.append((origin, Bitboard.squareMask(Square(rawValue: curr.0)!)))
        }
        
        return output
    }
}
