//
//  Bitboard+rank+file.swift
//  zChessKit
//
//  Created by Ben Zobrist on 9/23/25.
//

import zBitboard

extension Bitboard {
    static func rank(_ rank: Int) -> Bitboard? {
        precondition((1...8).contains(rank), "Rank must be between 1 and 8")
        let mask: Bitboard = 0xFF
        return mask << ((rank - 1) * 8)
    }
    
    static func file(_ file: Int) -> Bitboard? {
        precondition((1...8).contains(file), "Rank must be between 1 and 8")
        let mask: Bitboard = 0x0101010101010101
        return mask << (file - 1)
    }
}
