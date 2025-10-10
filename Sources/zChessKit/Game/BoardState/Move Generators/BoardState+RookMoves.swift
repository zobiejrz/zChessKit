//
//  BoardState+RookMoves.swift
//  zChessKit
//
//  Created by Ben Zobrist on 10/9/25.
//

import zBitboard

extension BoardState {
    
    /// Generates pseudo-legal moves for white rooks
    internal func generateWhiteRookMoves() -> [(from: Bitboard,  to: Bitboard)] {
        // - Slide vertically and horizontally
        // - Stop at obstructions or captures
        var output: [(from: Bitboard,  to: Bitboard)] = []
        var tmp = self.whiteRooks
        while tmp != Bitboard.empty {
            guard let curr = tmp.popLSB() else { break }
            tmp = curr.1
            let sq = Square(rawValue: curr.0)!
            
            let moves = self.generateOrthogonalMoves(for: sq, friendlyPieces: self.whitePieces)
            
            for target in moves {
                if target != Bitboard.empty {
                    output.append((from: Bitboard.squareMask(sq), to: target))
                }
            }
            
        }
        
        return output
    }
    
    /// Generates pseudo-legal moves for black rooks
    internal func generateBlackRookMoves() -> [(from: Bitboard,  to: Bitboard)] {
        // - Slide vertically and horizontally
        // - Stop at obstructions or captures
        var output: [(from: Bitboard,  to: Bitboard)] = []
        var tmp = self.blackRooks
        while tmp != Bitboard.empty {
            guard let curr = tmp.popLSB() else { break }
            tmp = curr.1
            let sq = Square(rawValue: curr.0)!
            
            let moves = self.generateOrthogonalMoves(for: sq, friendlyPieces: self.blackPieces)
            
            for target in moves {
                if target != Bitboard.empty {
                    output.append((from: Bitboard.squareMask(sq), to: target))
                }
            }
            
        }
        
        return output
    }
}
