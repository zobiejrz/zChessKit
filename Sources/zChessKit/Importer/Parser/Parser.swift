//
//  Parser.swift
//  zchess
//
//  Created by Ben Zobrist on 9/12/25.
//

public class Parser {
    
    enum ParserError: Error {
        // possible errors the parser can throw are here
        case unexpectedToken(Token)
        case invalidMove(String)
        case missingResult
        case unterminatedVariation
        case unexpectedEOF
        case invalidCastlingRights(String)
        case invalidEnPassantTargetSquare(String)
        case invalidInteger(String)
        case invalidCharacter(String)
    }
    
    private init () { }
    
}
