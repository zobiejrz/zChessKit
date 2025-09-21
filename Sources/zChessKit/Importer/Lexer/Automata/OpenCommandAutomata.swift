//
//  OpenCommandAutomata.swift
//  zchess
//
//  Created by Ben Zobrist on 9/12/25.
//

class OpenCommandAutomaton: Automata {
    
    func run(input: String) -> UInt {
        let first = String(input.prefix(2))
        return first == "[%" ? 2 : 0
    }
    
    func getType() -> TokenType {
        return .OPEN_COMMAND
    }
}
