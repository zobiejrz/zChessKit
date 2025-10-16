//
//  BoardState+boardString.swift
//  zChessKit
//
//  Created by Ben Zobrist on 10/9/25.
//

extension BoardState {
    
    public func boardString() -> String {
        // mapping from square -> piece symbol
        var board = Array(repeating: ".", count: 64)
        
        func placePieces(_ bitboard: UInt64, symbol: String) {
            var bb = bitboard
            while bb != 0 {
                let sq = bb.trailingZeroBitCount
                board[sq] = symbol
                bb &= bb - 1 // clear lowest set bit
            }
        }
        
        // Place white pieces
        placePieces(self.whitePawns, symbol: "♙")
        placePieces(self.whiteKnights, symbol: "♘")
        placePieces(self.whiteBishops, symbol: "♗")
        placePieces(self.whiteRooks, symbol: "♖")
        placePieces(self.whiteQueens, symbol: "♕")
        placePieces(self.whiteKing, symbol: "♔")
        
        // Place black pieces
        placePieces(self.blackPawns, symbol: "♟")
        placePieces(self.blackKnights, symbol: "♞")
        placePieces(self.blackBishops, symbol: "♝")
        placePieces(self.blackRooks, symbol: "♜")
        placePieces(self.blackQueens, symbol: "♛")
        placePieces(self.blackKing, symbol: "♚")
        
        // Build string
        var result = ""
        for rank in (0..<8).reversed() {
            result += "\(rank + 1) "
            for file in 0..<8 {
                let sq = rank * 8 + file
                result += " \(board[sq]) "
            }
            result += "\n"
        }
        result += "   a  b  c  d  e  f  g  h\n"
        
        return result
    }
}
