//
//  BoardSate+isValidUCIMove.swift
//  zChessKit
//
//  Created by Ben Zobrist on 10/16/25.
//

import zBitboard

extension BoardState {
    /// Parses and evaluates if a given SAN move is valid, returning the associated Move object if valid.
    func isValidUCIMove(_ uci: String) -> Move? {
        guard uci.count == 4 || uci.count == 5 else { return nil }
        
        let chars = Array(uci)
        let originStr = String(chars[0...1])
        let destStr = String(chars[2...3])
                
        guard let origin = Square.stringToSquare(originStr),
              let dest = Square.stringToSquare(destStr),
              let piece = self.whatPieceIsOn(origin) else {
            return nil
        }
        
        var promotion: PieceType? = nil
        if uci.count == 5 {
            promotion = PieceType.fromString(String(chars[4]))
        }
        
        return self.isValidMove(piece: piece, from: origin, to: dest, promotion: promotion)
    }
}
