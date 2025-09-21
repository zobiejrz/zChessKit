//
//  MagicBitboard.swift
//  zChessKit
//
//  Created by Ben Zobrist on 9/16/25.
//

import zBitboard

struct MagicBitboard {
    let mask: Bitboard
    let magic: UInt64
    let shift: Int
    let relevantBits: Int
    let attacks: [Bitboard]
    
    /// Create a magic object for a given square and sliding piece type.
    /// - Parameters:
    ///   - square: 0..63 (a1=0)
    ///   - magicNumber: optional multiplier (nil = fallback pack-based indexer)
    ///   - maskForSquare: function returning occupancy mask for square
    ///   - slidingAttacks: function returning attack set given blockers
    init(
        square: Square,
        magicNumber: UInt64,
        maskForSquare: Bitboard,
        slidingAttacks: (Square, Bitboard) -> Bitboard
    ) {
        self.mask = maskForSquare
        self.relevantBits = self.mask.nonzeroBitCount
        self.shift = 64 - self.mask.nonzeroBitCount
        self.magic = magicNumber
        
        let tableSize = 1 << self.mask.nonzeroBitCount
        var table = Array<Bitboard>(repeating: 0, count: tableSize)
        
        // Enumerate all subsets of mask
        var subset = self.mask
        while true {
            let idx: Int
            
            let hashed = (subset &* self.magic) >> UInt64(self.shift)
            idx = Int(hashed)
            
            table[idx] = slidingAttacks(square, subset)
            
            if subset == 0 { break }
            subset = (subset - 1) & self.mask
        }
        
        self.attacks = table
    }
    
    /// Lookup attack bitboard given a full-board occupancy (we only care about `mask` bits).
    @inline(__always)
    private func attacksGivenOccupancy(_ occupancy: Bitboard) -> Bitboard {
        let blockers = occupancy & self.mask
        let index = Int(((blockers &* self.magic) >> UInt64(self.shift)))
        return self.attacks[index]
    }
}
