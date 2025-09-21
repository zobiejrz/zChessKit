//
//  SymbolAutomata.swift
//  zchess
//
//  Created by Ben Zobrist on 9/12/25.
//

class SymbolAutomaton: Automata {
    
    private let additionalCharacters = "_-+#=:"
    
    func run(input: String) -> UInt {
        var count = 0
        for char in input {
            if char.isLetter || char.isNumber || additionalCharacters.contains(char) {
                count += 1
            } else {
                break
            }
        }
        return count > 0 ? UInt(count) : 0
    }
    
    func getType() -> TokenType {
        return .SYMBOL
    }
}
