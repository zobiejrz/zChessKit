//
//  BoardState+GenerateSlidingMoves.swift
//  zChessKit
//
//  Created by Ben Zobrist on 10/9/25.
//

import zBitboard

extension BoardState {
    
    /// Generates sliding diagonal moves from a given square with specified 'friendlyPieces'
    internal func generateDiagonalMoves(for sq: Square, friendlyPieces: Bitboard) -> [Bitboard] {
        var output: [Bitboard] = []
        
        let relevantOccupancy = bishopMask(forSquare: sq)           // squares that can block this bishop
        let blockers = self.allPieces & relevantOccupancy           // actual blockers from the board
        let magicEntry = MagicTables.bishop[sq.rawValue]            // struct Magic for this square
        let idx = Int((blockers &* magicEntry.magic) >> UInt64(magicEntry.shift))
        let attacksBB = magicEntry.attacks[idx]                     // <-- one bitboard, not an array
        
        // Now filter out friendly pieces
        var combined = attacksBB & ~friendlyPieces
        
        while combined != 0 {
            let tmp = combined.popLSB()!
            combined = tmp.newBitboard
            output.append(Bitboard.squareMask(Square(rawValue: tmp.index)!))
        }
        
        return output
    }
    
    /// Generates sliding orthogonal moves from a given square with specified 'friendlyPieces'
    internal func generateOrthogonalMoves(for sq: Square, friendlyPieces: Bitboard) -> [Bitboard] {
        var output: [Bitboard] = []
        
        let relevantOccupancy = rookMask(forSquare: sq)             // squares that can block this bishop
        let blockers = self.allPieces & relevantOccupancy           // actual blockers from the board
        let magicEntry = MagicTables.rook[sq.rawValue]              // struct Magic for this square
        let idx = Int((blockers &* magicEntry.magic) >> UInt64(magicEntry.shift))
        let attacksBB = magicEntry.attacks[idx]                     // <-- one bitboard, not an array
        
        // Now filter out friendly pieces
        var combined = attacksBB & ~friendlyPieces
        
        while combined != 0 {
            let tmp = combined.popLSB()!
            combined = tmp.newBitboard
            output.append(Bitboard.squareMask(Square(rawValue: tmp.index)!))
        }
        
        return output
    }
}
