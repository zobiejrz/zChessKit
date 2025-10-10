//
//  Game+getPGN.swift
//  zChessKit
//
//  Created by Ben Zobrist on 10/10/25.
//

extension Game {
    public func getPGN() -> String {
        var pgn = ""
        
        // --- Format Game Data ---
        
        // get the seven tag roster
        let sevenTagRoster = [
            "Event",
            "Site",
            "Date",
            "Round",
            "White",
            "Black",
            "Result"
        ]
        let sevenTagValue = [
            "?",
            "?",
            "????.??.??",
            "?",
            "?",
            "?",
            "*"
        ]
        
        for (i, key) in sevenTagRoster.enumerated() {
            
            let value: String
            if let savedValue = self.gamedata[key] {
                value = savedValue
            } else {
                value = sevenTagValue[i]
            }
            
                
            let row = "[\(key) \"\(value)\"]\n"
            pgn.append(row)
        }
        
        // get any other tags
        for key in self.gamedata.keys {
            if let value = self.gamedata[key],
               !sevenTagRoster.contains(key) {
                let row = "[\(key) \"\(value)\"]\n"
                pgn.append(row)
            }
        }
        pgn.append("\n")
        
        // --- Format Move Text ---
        var moveNumber = 1
        for move in self.moves {
            let moveText: String
            if move.color == .black {
                moveText = "\(moveNumber != 1 ? " " : "")\(moveNumber). \(move.san)"
            } else {
                moveText = " \(move.san)"
                moveNumber += 1
            }
            pgn.append(moveText)
            
            if move == self.moves.last {
                pgn.append(" \(self.gamedata["Result"] ?? "*")")
            }
        }

        return pgn
    }
}
