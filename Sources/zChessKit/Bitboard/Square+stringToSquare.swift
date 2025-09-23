//
//  Square+thing.swift
//  zChessKit
//
//  Created by Ben Zobrist on 9/23/25.
//

import zBitboard

extension Square {
    static func stringToSquare(_ square: String) -> Square? {
        guard square.count == 2,
              let fileChar = square.first,
              let rankChar = square.last,
              let file = "abcdefgh".firstIndex(of: fileChar),
              let rank = Int(String(rankChar))
        else {
            return nil
        }
        
        let fileIndex = "abcdefgh".distance(from: "abcdefgh".startIndex, to: file)
        let rankIndex = rank - 1
        
        let value = rankIndex * 8 + fileIndex
        
        if value >= 0 && value < 64 {
            return Square(rawValue: value)!
        } else {
            return nil
        }
    }
}
