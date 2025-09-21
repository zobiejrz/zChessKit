//
//  StringAutomata.swift
//  zchess
//
//  Created by Ben Zobrist on 9/12/25.
//

class StringAutomaton: Automata {
    func run(input: String) -> UInt {
        guard input.first == "\"" else { return 0 }
        
        var index = input.index(after: input.startIndex)
        
        while index < input.endIndex {
            let char = input[index]
            if char == "\"" {
                let prevIndex = input.index(before: index)
                if input[prevIndex] != "\\" {
                    return UInt(input.distance(from: input.startIndex, to: input.index(after: index)))
                }
            }
            index = input.index(after: index)
        }
        return 0 // No closing quote
    }
    
    func getType() -> TokenType {
        return .STRING
    }
}
