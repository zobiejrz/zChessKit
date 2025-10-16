//
//  BoardState+BishopMoves.swift
//  zChessKit
//
//  Created by Ben Zobrist on 10/9/25.
//

import zBitboard

extension BoardState {
    
    /// Generates pseudo-legal moves for white bishops
    internal func generateWhiteBishopMoves() -> [(from: Bitboard,  to: Bitboard)] {
        // - Slide diagonally until obstruction
        // - Capture enemies
        // - Block at first obstruction
        var output: [(from: Bitboard,  to: Bitboard)] = []
        var tmp = self.whiteBishops
        while tmp != Bitboard.empty {
            guard let curr = tmp.popLSB() else { break }
            tmp = curr.1
            let sq = Square(rawValue: curr.0)!
            
            let moves = self.generateDiagonalMoves(for: sq, friendlyPieces: self.whitePieces)
            
            for target in moves {
                if target != Bitboard.empty {
                    output.append((from: Bitboard.squareMask(sq), to: target))
                }
            }
            
        }
        
        return output
    }
    
    /// Generates pseudo-legal moves for black bishops
    internal func generateBlackBishopMoves() -> [(from: Bitboard,  to: Bitboard)] {
        // - Slide diagonally until obstruction
        // - Capture enemies
        // - Block at first obstruction
        var output: [(from: Bitboard,  to: Bitboard)] = []
        var tmp = self.blackBishops
        while tmp != Bitboard.empty {
            guard let curr = tmp.popLSB() else { break }
            tmp = curr.1
            let sq = Square(rawValue: curr.0)!
            
            let moves = self.generateDiagonalMoves(for: sq, friendlyPieces: self.blackPieces)
            
            for target in moves {
                if target != Bitboard.empty {
                    output.append((from: Bitboard.squareMask(sq), to: target))
                }
            }
            
        }
        
        return output
    }
}
