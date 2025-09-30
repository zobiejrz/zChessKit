//
//  CommentAutomata.swift
//  zChessKit
//
//  Created by Ben Zobrist on 9/30/25.
//

class CommentAutomata: Automata {
    func run(input: String) -> UInt {
        guard input.first == "{" else { return 0 }
        
        var index = input.index(after: input.startIndex)
        
        while index < input.endIndex {
            let char = input[index]
            if char == "}" {
                return UInt(input.distance(from: input.startIndex, to: input.index(after: index)))
            }
            index = input.index(after: index)
        }
        return 0 // No closing comment
    }
    
    func getType() -> TokenType {
        return .COMMENT
    }
}
