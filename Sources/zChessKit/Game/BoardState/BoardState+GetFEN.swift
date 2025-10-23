//
//  BoardState.swift
//  zChessKit
//
//  Created by Grayson Adams on 10/16/25.
//

import zBitboard

extension BoardState {
    public func getFEN() -> String {
        var piecePlacement = ""

        for i in Rank.allCases.reversed() { 
            var emptyCount = 0
            
            // Iterate through the files (columns) from 'a' to 'h'
            for j in File.allCases { 
                let square = Square(rawValue: (i.rawValue*8)+j.rawValue)!
                let piece = self.whatPieceIsOn(square)

                if piece == nil {
                    // If the square is empty, increment the counter
                    emptyCount += 1
                } else {
                    // If there were empty squares before this piece,
                    // append the count to the string and reset the counter
                    if emptyCount > 0 {
                        piecePlacement.append("\(emptyCount)")
                        emptyCount = 0
                    }
                    // Append the piece character
                    let char = self.whitePieces.hasPiece(on: square) ? piece!.toLetter().uppercased() : piece!.toLetter().lowercased()
                    piecePlacement.append(char)
                }
            }
            
            // After iterating through all files in a rank, 
            // if there are any trailing empty squares, append the count
            if emptyCount > 0 {
                piecePlacement.append("\(emptyCount)")
            }

            // Add the rank separator '/' if it's not the last rank
            if i.rawValue > 1 {
                piecePlacement.append("/")
            }
        }
        
        let turn: String
        if self.playerToMove == .white {
            turn = "w"
        } else {
            turn = "b"
        }

        var castling: String  = ""
        if self.castlingRights.contains(.K) {
            castling.append("K")
        } 
        if self.castlingRights.contains(.Q) {
            castling.append("Q")
        } 
        if self.castlingRights.contains(.k) {
            castling.append("k")
        } 
        if self.castlingRights.contains(.q) {
            castling.append("q")
        } 
        if self.castlingRights.count == 0 {
            castling.append("-")
        } 

        let enpassantSquare: String
        if let (idx, _) = self.enpassantTargetSquare.popLSB() {
            let square = Square(rawValue: idx)! 
            enpassantSquare = "\(square)"
        } else {
            enpassantSquare = "-"
        }

        let halfmoveClock: Int = self.halfmoveClock
        let fullmoveClock: Int = (self.plyNumber + 1) / 2 

        return "\(piecePlacement) \(turn) \(castling) \(enpassantSquare) \(halfmoveClock) \(fullmoveClock)"
    }
}
