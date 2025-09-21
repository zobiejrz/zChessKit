//
//  SingleCharacterAutomata.swift
//  zchess
//
//  Created by Ben Zobrist on 9/12/25.
//

class SingleCharacterAutomaton: Automata {
    private let char: Character
    private let type: TokenType
    
    init(char: Character, type: TokenType) {
        self.char = char
        self.type = type
    }
    
    func run(input: String) -> UInt {
        guard let first = input.first else { return 0 }
        return first == char ? 1 : 0
    }
    
    func getType() -> TokenType {
        return type
    }
}
