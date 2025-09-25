//
//  TokenType.swift
//  zchess
//
//  Created by Ben Zobrist on 9/12/25.
//

public enum TokenType: Sendable {
    case STRING, INTEGER, PERIOD, ASTERISK, NAG, SYMBOL,
         L_BRACKET, R_BRACKET,
         L_PARENTHESIS, R_PARENTHESIS,
         L_ANGLE_BRACKET, R_ANGLE_BRACKET,
         L_CURLY_BRACKET, R_CURLY_BRACKET,
         OPEN_COMMAND, FORWARD_SLASH, SEMICOLON, COMMA
}
