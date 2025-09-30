//
//  Lexer.swift
//  zchess
//
//  Created by Ben Zobrist on 9/12/25.
//

public class Lexer {
    private let automata: [Automata] = [
        StringAutomaton(),
        IntegerAutomaton(),
        SingleCharacterAutomaton(char: ",", type: .COMMA),
        SingleCharacterAutomaton(char: ";", type: .SEMICOLON),
        SingleCharacterAutomaton(char: ".", type: .PERIOD),
        SingleCharacterAutomaton(char: "*", type: .ASTERISK),
        SingleCharacterAutomaton(char: "[", type: .L_BRACKET),
        SingleCharacterAutomaton(char: "]", type: .R_BRACKET),
        SingleCharacterAutomaton(char: "(", type: .L_PARENTHESIS),
        SingleCharacterAutomaton(char: ")", type: .R_PARENTHESIS),
        SingleCharacterAutomaton(char: "<", type: .L_ANGLE_BRACKET),
        SingleCharacterAutomaton(char: ">", type: .R_ANGLE_BRACKET),
        SingleCharacterAutomaton(char: "{", type: .L_CURLY_BRACKET),
        SingleCharacterAutomaton(char: "}", type: .R_CURLY_BRACKET),
        SingleCharacterAutomaton(char: "/", type: .FORWARD_SLASH),
        NAGAutomaton(),
        SymbolAutomaton(),
        CommentAutomata(),
        OpenCommandAutomaton()
        ]
    private(set) var tokens: [Token] = []
    
    public init() {
        self.tokens = []
    }
    
    @discardableResult public func run(input: String) -> [Token] {
        
        // While we are processing the PGN
        //      loop through each automata
        //      Keep track of a MaxAutomata and maxLength which matches the most characters
        //
        //      After identifying the MaxAutomata, create the associated token
        //      Remove the first maxLength characters and put them in the token
        //      Append token to the end of self.tokens
        //      If ever there is no valid token for the current string, throw an error indicating this
        self.tokens = []
        var remaining = input
        
        while remaining.count > 0 {
            
            // Skip leading whitespace
            if let first = remaining.first, first.isWhitespace {
                remaining = String(remaining.dropFirst())
                continue
            }
            
            var maxLength: UInt = 0
            var maxAutomaton: Automata? = nil
            
            // Find valid token (if any)
            for automaton in self.automata {
                let length = automaton.run(input: String(remaining))
                if length > maxLength {
                    maxLength = length
                    maxAutomaton = automaton
                }
            }
            
            if let automaton = maxAutomaton, maxLength > 0 {
                // Produce maxAutomata's token
                let tokenValue = String(remaining.prefix(Int(maxLength)))
                let token = Token(tokenType: automaton.getType(), value: tokenValue)
                self.tokens.append(token)
                
                remaining = String(remaining.dropFirst(Int(maxLength)))
            } else {
                // No valid token found
                let context = String(remaining.prefix(10))
                fatalError("Lexer error: unrecognized token starting at: '\(context)'")
            }
        }
        return self.tokens
    }
}
