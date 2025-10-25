//
//  Square+PieceMoves.swift
//  zChessKit
//
//  Created by Ben Zobrist on 9/15/25.
//

import zBitboard

extension Square {
    
    public static func generateKnightMoves(_ sq: Square, blockers: Bitboard = Bitboard.empty) -> Bitboard {
        // - All L-shaped jumps (8 directions)
        // - Avoid friendly fire
        
        let origin: Bitboard = Bitboard.squareMask(sq)
        
        let total = (
            origin.nShift().neShift() | origin.nShift().nwShift() |
            origin.eShift().neShift() | origin.eShift().seShift() |
            origin.sShift().seShift() | origin.sShift().swShift() |
            origin.wShift().nwShift() | origin.wShift().swShift()
        ) & ~blockers
        return total
    }
    
    public static func slidingBishopAttacks(at sq: Square, blockers: Bitboard = Bitboard.empty) -> Bitboard {
        let file0 = sq.rawValue & 7
        let rank0 = sq.rawValue >> 3
        
        var attacks = Bitboard.empty
        
        let dirs = [(1, 1), (-1, 1), (1, -1), (-1, -1)]
        for (dx, dy) in dirs {
            var f = file0 + dx
            var r = rank0 + dy
            while f >= 0 && f <= 7 && r >= 0 && r <= 7 {
                let s = Square(rawValue: (r*8) + f)!
                attacks |= Bitboard.squareMask(s)
                if (blockers & Bitboard.squareMask(s)) != 0 {
                    break // include blocker and stop
                }
                f += dx
                r += dy
            }
        }
        
        return attacks
    }

    public static func slidingRookAttacks(at sq: Square, blockers: Bitboard = Bitboard.empty) -> Bitboard {
        let file0 = sq.rawValue & 7
        let rank0 = sq.rawValue >> 3
        
        var attacks = Bitboard.empty
        
        let dirs = [(1, 0), (-1, 0), (0, 1), (0, -1)]
        for (dx, dy) in dirs {
            var f = file0 + dx
            var r = rank0 + dy
            while f >= 0 && f <= 7 && r >= 0 && r <= 7 {
                let s = Square(rawValue: (r*8) + f)!
                attacks |= Bitboard.squareMask(s)
                if (blockers & Bitboard.squareMask(s)) != 0 {
                    // hit a blocker — include it and stop this ray
                    break
                }
                f += dx
                r += dy
            }
        }
        
        return attacks
    }
    
    public static func slidingQueenAttacks(at sq: Square, blockers: Bitboard = Bitboard.empty) -> Bitboard {
        return Square.slidingBishopAttacks(at: sq, blockers: blockers) | Square.slidingRookAttacks(at: sq, blockers: blockers)
    }
}
