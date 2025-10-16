//
//  BoardState+isValidSANMove.swift
//  zChessKit
//
//  Created by Ben Zobrist on 10/9/25.
//

import zBitboard

extension BoardState {
    /// Parses and evaluates if a given SAN move is valid, returning the associated Move object if valid.
    func isValidSANMove(_ san: String) -> Move? {
        var san = san.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let piece: PieceType
        let from: Square?
        let to: Square
        let promotion: PieceType?
        let disambiguationBB: Bitboard
        
        // 1. Strip check / checkmate symbols
        san = san.replacingOccurrences(of: "+", with: "")
        san = san.replacingOccurrences(of: "#", with: "")
        
        // 2. Handle castling
        if san == "O-O" || san == "0-0" {
            piece = .king
            from = self.playerToMove == .white ? .e1 : .e8
            to = self.playerToMove == .white ? .g1 : .g8
            promotion = nil
            disambiguationBB = .empty
        } else if san == "O-O-O" || san == "0-0-0" {
            piece = .king
            from = self.playerToMove == .white ? .e1 : .e8
            to = self.playerToMove == .white ? .c1 : .c8
            promotion = nil
            disambiguationBB = .empty
        } else {
            
            // 3. Extract promotion piece if present (like e8=Q)
            if let eqIndex = san.firstIndex(of: "=") {
                let promoChar = String(san[san.index(after: eqIndex)])
                promotion = PieceType.fromString(promoChar)
                san = String(san[..<eqIndex])
            } else {
                promotion = nil
            }
            
            // 4. Separate piece letter (default = pawn) and rest
            var sanBody = san
            if let first = san.first, "NBRQK".contains(first) {
                piece = PieceType.fromString(String(first))!
                sanBody.removeFirst()
            } else {
                piece = .pawn
            }
            
            // 5. Destination square is always at the end (like "e4", "h1")
            guard sanBody.count >= 2 else { return nil }
            let destStr = String(sanBody.suffix(2))
            guard let dest = Square.stringToSquare(destStr) else { return nil }
            to = dest
            
            // 6. Disambiguation (anything left in sanBody before the dest, after removing 'x')
            var disambiguation = String(sanBody.dropLast(2))
            disambiguation = disambiguation.replacingOccurrences(of: "x", with: "")
            
            if disambiguation.count == 2 {
                guard let origin = Square.stringToSquare(disambiguation) else { return nil }
                from = origin
                disambiguationBB = .empty // have all the info already
            } else if disambiguation.count == 1 {
                if disambiguation.first!.isNumber {
                    guard let rank = Int(disambiguation), (1...8).contains(rank) else { return nil }
                    let bb = Bitboard.rank(rank)!
                    
                    disambiguationBB = bb
                    from = nil
                } else if disambiguation.first!.isLetter {
                    let all = "abcdefgh"
                    guard let indexInStr = all.firstIndex(of: disambiguation.first!) else { return nil }
                    let file = all.distance(from: all.startIndex, to: indexInStr) + 1
                    let bb = Bitboard.file(Int(file))!
                    
                    disambiguationBB = bb
                    from = nil
                } else {
                    return nil
                }
            } else if disambiguation.count == 0 {
                disambiguationBB = .empty
                from = nil
            } else {
                return nil
            }
        }
        
        // 7. Now filter legal moves
        let moves = self.generateAllLegalMoves()
        let candidates = moves.filter { move in
            if move.piece != piece {
                return false
            }
            
            if move.to != to {
                return false
            }
            
            if move.promotion != promotion {
                return false
            }
            
            if let sq = from {
                if move.from != sq {
                    return false
                }
            }
            
            if disambiguationBB != .empty {
                if Bitboard.squareMask(move.from) & disambiguationBB == 0 {
                    return false
                }
            }
            
            return true
        }
        
        // 8. Return unique match
        return candidates.count == 1 ? candidates.first : nil
    }
}
