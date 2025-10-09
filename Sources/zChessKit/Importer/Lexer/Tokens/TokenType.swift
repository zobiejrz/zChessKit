//
//  TokenType.swift
//  zchess
//
//  Created by Ben Zobrist on 9/12/25.
//

public enum TokenType: Sendable {
    
    // MARK: Tokens for both
    case SYMBOL, INTEGER

    // MARK: Tokens for FEN
    case FORWARD_SLASH
    
    // MARK: Tokens for PGN
    case STRING, PERIOD, ASTERISK, NAG,
         L_BRACKET, R_BRACKET,
         L_PARENTHESIS, R_PARENTHESIS,
         L_ANGLE_BRACKET, R_ANGLE_BRACKET,
         L_CURLY_BRACKET, R_CURLY_BRACKET,
         OPEN_COMMAND, SEMICOLON, COMMA, COMMENT
}
