//
//  BoardState+generateSAN.swift
//  zChessKit
//
//  Created by Ben Zobrist on 11/2/25.
//

import zBitboard

extension BoardState {
    public func generateSAN(for move: Move) -> String {
        
        var output: String = ""
        
        // --- Handle Castling ---
        if move.isCastling && move.piece == .king {
            let tmp = Bitboard.file(7)! & (move.resultingBoardState.blackKing | move.resultingBoardState.whiteKing) & Bitboard.squareMask(move.to)
            
            output = tmp.hasPiece(on: move.to) ? "O-O" : "O-O-O"
        } else { // Get the piece, disambiguation, capturing, destination, and promotion together
            
            // --- only file for pawns ---
            if move.piece != .pawn {
                output += "\(move.piece.toLetter().uppercased())"
            }
            
            // --- disambiguation (if applicable) ---
            let destbb = Bitboard.squareMask(move.to)
            
            let mask: Bitboard
            switch move.piece {
            case .pawn:
                if move.capturedPiece != nil {
                    let others = playerToMove == .white ? self.whitePawns : self.blackPawns
                    mask = (playerToMove == .white ? destbb.seShift() | destbb.swShift() : destbb.neShift() | destbb.nwShift()) & others
                } else {
                    mask = .empty
                }
            case .knight:
                let others = playerToMove == .white ? self.whiteKnights : self.blackKnights
                mask = Square.generateKnightMoves(move.to) & others
            case .bishop:
                let others = playerToMove == .white ? self.whiteBishops : self.blackBishops
                mask = Square.slidingBishopAttacks(at: move.to, blockers: self.allPieces) & others
            case .rook:
                let others = playerToMove == .white ? self.whiteRooks : self.blackRooks
                mask = Square.slidingRookAttacks(at: move.to, blockers: self.allPieces) & others
            case .queen:
                let others = playerToMove == .white ? self.whiteQueens : self.blackQueens
                mask = Square.slidingQueenAttacks(at: move.to, blockers: self.allPieces) & others
            case .king:
                mask = .empty // this makes no sense but like needs to be exhaustive ig
            }
            
            if mask.nonzeroBitCount == 2 { // one disambiguation needed
                let fileChar = ("\(move.from)".first!)
                let rankChar = ("\(move.from)".last!)
                
                let fileIndex = "abcdefgh".firstIndex(of: fileChar)!
                let file = Int("abcdefgh".distance(from: "abcdefgh".startIndex, to: fileIndex)) + 1 // 1...8
                
                // Check if both pieces are on the same file
                let piecesOnFile = Bitboard.file(file)! & mask
                if piecesOnFile.nonzeroBitCount == 2 && move.piece != .pawn {
                    // Both pieces on same file, need rank to disambiguate
                    output += String(rankChar)
                } else if move.piece != .pawn {
                    // Pieces on different files, file alone disambiguates
                    output += String(fileChar)
                }
            } else if mask.nonzeroBitCount >= 3 { // two disambiguation needed
                output += "\(move.from)"
            } else { // disambiguation not needed
            }
            
            // --- whether we are capturing ---
            if move.capturedPiece != nil {
                if move.piece == .pawn {
                    output += String("\(move.from)".first!)
                }
                output += "x"
            }
            // --- destination square ---
            output += "\(move.to)"
            
            // --- e.p. (if applicable) ---
            if move.piece == .pawn && destbb == self.enpassantTargetSquare {
                output += " e.p."
            }
            
            // --- promotion (if applicable) ---
            if let p = move.promotion {
                output += "=\(p.toLetter().uppercased())"
            }
        }
        
        // --- handle whether check/checkmate ---
        
        if move.resultingBoardState.isKingInCheck() {
            if move.resultingBoardState.generateAllLegalMoves().count == 0 {
                output += "#"
            } else {
                output += "+"
            }
        }
        
        return output
    }

}
