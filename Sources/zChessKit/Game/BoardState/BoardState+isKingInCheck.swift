//
//  BoardState+isKingInCheck.swift
//  zChessKit
//
//  Created by Ben Zobrist on 10/9/25.
//

import zBitboard

extension BoardState {
    /// Returns true if the specified color of king is in check.
    /// For the purposes of evaluating *legal* moves, specifying the color and location of the king is available.
    public func isKingInCheck(_ color: PlayerColor? = nil, kingLocation: Bitboard? = nil) -> Bool {
        let playerToCheck = color ?? self.playerToMove
        
        if playerToCheck == .white { // see if black pieces attack white king
            let kingLocation = kingLocation ?? self.whiteKing
            guard kingLocation.nonzeroBitCount > 0 else { return false }
            let idx = kingLocation.popLSB()!.0
            let kingsq = Square(rawValue: idx)!
            
            if (kingLocation.neShift() | kingLocation.nwShift()) & self.blackPawns > 0 {
                return true
            }
            
            if Square.generateKnightMoves(kingsq) & self.blackKnights > 0 {
                return true
            }
            
            if Square.slidingBishopAttacks(at: kingsq, blockers: self.allPieces) & (self.blackBishops | self.blackQueens) > 0 {
                return true
            }
            
            if Square.slidingRookAttacks(at: kingsq, blockers: self.allPieces) & (self.blackRooks | self.blackQueens) > 0 {
                return true
            }
            
            // It's weird but will be used to prevent this move from occurring
            let kingmoves: Bitboard = (
                kingLocation.nShift() | kingLocation.neShift() |
                kingLocation.eShift() | kingLocation.seShift() |
                kingLocation.sShift() | kingLocation.swShift() |
                kingLocation.wShift() | kingLocation.nwShift()
            )
            if kingmoves & self.blackKing > 0 {
                return true
            }
        } else if playerToCheck == .black { // see if white pieces attack black king
            let kingLocation = kingLocation ?? self.blackKing
            guard kingLocation.nonzeroBitCount > 0 else { return false }
            let idx = kingLocation.popLSB()!.0
            let kingsq = Square(rawValue: idx)!
            
            if (kingLocation.seShift() | kingLocation.swShift()) & self.whitePawns > 0 {
                return true
            }
            
            if Square.generateKnightMoves(kingsq) & self.whiteKnights > 0 {
                return true
            }
            
            if Square.slidingBishopAttacks(at: kingsq, blockers: self.allPieces) & (self.whiteBishops | self.whiteQueens) > 0 {
                return true
            }
            
            if Square.slidingRookAttacks(at: kingsq, blockers: self.allPieces) & (self.whiteRooks | self.whiteQueens) > 0 {
                return true
            }
            
            // It's weird but will be used to prevent this move from occurring
            let kingmoves: Bitboard = (
                kingLocation.nShift() | kingLocation.neShift() |
                kingLocation.eShift() | kingLocation.seShift() |
                kingLocation.sShift() | kingLocation.swShift() |
                kingLocation.wShift() | kingLocation.nwShift()
            )
            if kingmoves & self.whiteKing > 0 {
                return true
            }
        }
        
        return false
    }
}
