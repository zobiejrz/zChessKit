//
//  TokenStream.swift
//  zChessKit
//
//  Created by Ben Zobrist on 9/23/25.
//

struct TokenStream {
    private var tokens: [Token]
    private(set) var index: Int = 0
    
    init(tokens: [Token]) {
        self.tokens = tokens
    }
    
    var isAtEnd: Bool {
        return index >= tokens.count
    }
    
    func peek() -> Token? {
        guard !isAtEnd else { return nil }
        return tokens[index]
    }
    
    @discardableResult
    mutating func consume() -> Token? {
        guard !isAtEnd else { return nil }
        defer { index += 1 }
        return tokens[index]
    }
    
    @discardableResult
    mutating func expect(_ type: TokenType) throws -> Token {
        // first ensure there's a token at all
        guard let t = peek() else {
            throw Parser.ParserError.unexpectedEOF
        }
        
        // then ensure it is the expected type
        guard t.tokenType == type else {
            throw Parser.ParserError.unexpectedToken(t) // pass the non-optional token
        }
        
        // finally consume and return it
        _ = consume()
        return t
    }
}

