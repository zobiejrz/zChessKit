//
//  BoardState+PawnMoves.swift
//  zChessKit
//
//  Created by Ben Zobrist on 10/9/25.
//

import zBitboard

extension BoardState {
    
    /// Generates psuedo-legal moves for white pawns
    internal func generateWhitePawnMoves() -> [(from: Bitboard,  to: Bitboard)] {
        // - Forward 1
        // - Forward 2 (from rank 2)
        // - Captures (left/right)
        // - En passant
        var output: [(from: Bitboard,  to: Bitboard)] = []
        var remainingPawns = self.whitePawns
        
        while remainingPawns.nonzeroBitCount > 0 {
            guard let tmp = remainingPawns.popLSB() else { break }
            guard let originSquare = Square(rawValue: tmp.0) else { break }
            remainingPawns = tmp.1
            let origin: Bitboard = Bitboard.squareMask(originSquare)
            
            var total = Bitboard.empty
            
            // Forward 1
            if origin.nShift() & self.allPieces == .empty {
                total |= origin.nShift()
            }
            
            // Forward 2
            if origin & Bitboard.rank2 > 0 {
                if origin.nShift() & self.allPieces == .empty && origin.nShift().nShift() & self.allPieces == .empty {
                    total |= origin.nShift().nShift()
                }
            }
            
            // Captures
            total |= (origin.neShift() & self.blackPieces)
            total |= (origin.nwShift() & self.blackPieces)
            
            // En passant
            total |= (origin.neShift() & self.enpassantTargetSquare)
            total |= (origin.nwShift() & self.enpassantTargetSquare)
            
            while total != Bitboard.empty {
                guard let curr = total.popLSB() else { break }
                total = curr.1
                output.append((origin, Bitboard.squareMask(Square(rawValue: curr.0)!)))
            }
        }
        
        return output
    }
    
    /// Generates psuedo-legal moves for black pawns
    internal func generateBlackPawnMoves() -> [(from: Bitboard,  to: Bitboard)] {
        // - Forward 1
        // - Forward 2 (from rank 7)
        // - Captures (left/right)
        // - En passant
        var output: [(from: Bitboard,  to: Bitboard)] = []
        var remainingPawns = self.blackPawns
        
        while remainingPawns.nonzeroBitCount > 0 {
            guard let tmp = remainingPawns.popLSB() else { break }
            guard let originSquare = Square(rawValue: tmp.0) else { break }
            remainingPawns = tmp.1
            let origin: Bitboard = Bitboard.squareMask(originSquare)
            
            var total = Bitboard.empty
            
            // Forward 1
            if origin.sShift() & self.allPieces == .empty {
                total |= origin.sShift()
            }
            
            // Forward 2
            if origin & Bitboard.rank7 > 0 {
                if origin.sShift() & self.allPieces == .empty && origin.sShift().sShift() & self.allPieces == .empty {
                    total |= origin.sShift().sShift()
                }
            }
            
            // Captures
            total |= (origin.seShift() & self.whitePieces)
            total |= (origin.swShift() & self.whitePieces)
            
            // En passant
            total |= (origin.seShift() & self.enpassantTargetSquare)
            total |= (origin.swShift() & self.enpassantTargetSquare)
            
            while total != Bitboard.empty {
                guard let curr = total.popLSB() else { break }
                total = curr.1
                output.append((origin, Bitboard.squareMask(Square(rawValue: curr.0)!)))
            }
        }
        
        return output
    }
}
