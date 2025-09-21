//
//  IntegerAutomata.swift
//  zchess
//
//  Created by Ben Zobrist on 9/12/25.
//

class IntegerAutomaton: Automata {
    func run(input: String) -> UInt {
        var count = 0
        for char in input {
            if char.isNumber {
                count += 1
            } else {
                break
            }
        }
        return count > 0 ? UInt(count) : 0
    }
    
    func getType() -> TokenType {
        return .INTEGER
    }
}
