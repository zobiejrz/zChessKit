//
//  BoardState+KnightMoves.swift
//  zChessKit
//
//  Created by Ben Zobrist on 10/9/25.
//

import zBitboard

extension BoardState {
    
    /// Generates pseudo-legal moves for white knights
    internal func generateWhiteKnightMoves() -> [(from: Bitboard,  to: Bitboard)] {
        // - All L-shaped jumps (8 directions)
        // - Avoid friendly fire
        
        var output: [(from: Bitboard,  to: Bitboard)] = []
        
        var remainingKnights = self.whiteKnights
        while remainingKnights.nonzeroBitCount > 0 {
            guard let tmp = remainingKnights.popLSB() else { break }
            guard let originSquare = Square(rawValue: tmp.0) else { break }
            remainingKnights = tmp.1
            let origin: Bitboard = Bitboard.squareMask(originSquare)
            
            var total = Square.generateKnightMoves(originSquare, blockers: self.whitePieces)
            
            while total != Bitboard.empty {
                guard let curr = total.popLSB() else { break }
                total = curr.1
                output.append((origin, Bitboard.squareMask(Square(rawValue: curr.0)!)))
            }
        }
        
        return output
    }
    
    /// Generates pseudo-legal moves for black knights
    internal func generateBlackKnightMoves() -> [(from: Bitboard,  to: Bitboard)] {
        // - All L-shaped jumps (8 directions)
        // - Avoid friendly fire
        
        var output: [(from: Bitboard,  to: Bitboard)] = []
        
        var remainingKnights = self.blackKnights
        while remainingKnights.nonzeroBitCount > 0 {
            guard let tmp = remainingKnights.popLSB() else { break }
            guard let originSquare = Square(rawValue: tmp.0) else { break }
            remainingKnights = tmp.1
            let origin: Bitboard = Bitboard.squareMask(originSquare)
            
            var total = Square.generateKnightMoves(originSquare, blockers: self.blackPieces)
            
            while total != Bitboard.empty {
                guard let curr = total.popLSB() else { break }
                total = curr.1
                output.append((origin, Bitboard.squareMask(Square(rawValue: curr.0)!)))
            }
            
        }
        
        return output
    }
}
