//
//  BoardState+QueenMoves.swift
//  zChessKit
//
//  Created by Ben Zobrist on 10/9/25.
//

import zBitboard

extension BoardState {
    
    /// Generates pseudo-legal moves for white queens
    internal func generateWhiteQueenMoves() -> [(from: Bitboard,  to: Bitboard)] {
        // - Combine rook + bishop movement
        var output: [(from: Bitboard,  to: Bitboard)] = []
        var tmp = self.whiteQueens
        while tmp != Bitboard.empty {
            guard let curr = tmp.popLSB() else { break }
            tmp = curr.1
            let sq = Square(rawValue: curr.0)!
            
            let dMoves = self.generateDiagonalMoves(for: sq, friendlyPieces: self.whitePieces)
            let oMoves = self.generateOrthogonalMoves(for: sq, friendlyPieces: self.whitePieces)
            for target in dMoves {
                if target != Bitboard.empty {
                    output.append((from: Bitboard.squareMask(sq), to: target))
                }
            }
            for target in oMoves {
                if target != Bitboard.empty {
                    output.append((from: Bitboard.squareMask(sq), to: target))
                }
            }
        }
        
        return output
    }
    
    /// Generates pseudo-legal moves for black queens
    internal func generateBlackQueenMoves() -> [(from: Bitboard,  to: Bitboard)] {
        // - Combine rook + bishop movement
        var output: [(from: Bitboard,  to: Bitboard)] = []
        var tmp = self.blackQueens
        while tmp != Bitboard.empty {
            guard let curr = tmp.popLSB() else { break }
            tmp = curr.1
            let sq = Square(rawValue: curr.0)!
            
            let dMoves = self.generateDiagonalMoves(for: sq, friendlyPieces: self.blackPieces)
            let oMoves = self.generateOrthogonalMoves(for: sq, friendlyPieces: self.blackPieces)
            for target in dMoves {
                if target != Bitboard.empty {
                    output.append((from: Bitboard.squareMask(sq), to: target))
                }
            }
            for target in oMoves {
                if target != Bitboard.empty {
                    output.append((from: Bitboard.squareMask(sq), to: target))
                }
            }
        }
        
        return output
    }
}
