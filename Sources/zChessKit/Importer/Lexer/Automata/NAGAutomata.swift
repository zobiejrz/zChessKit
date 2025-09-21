//
//  NAGAutomata.swift
//  zchess
//
//  Created by Ben Zobrist on 9/12/25.
//

class NAGAutomaton: Automata {
    func run(input: String) -> UInt {
        guard input.first == "$" else { return 0 }
        var count = 1
        for char in input.dropFirst() {
            if char.isNumber {
                count += 1
            } else {
                break
            }
        }
        return count > 1 ? UInt(count) : 0
    }
    
    func getType() -> TokenType {
        return .NAG
    }
}
