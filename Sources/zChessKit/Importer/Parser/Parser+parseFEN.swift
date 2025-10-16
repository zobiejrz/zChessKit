//
//  Parser+parseFEN.swift
//  zChessKit
//
//  Created by Ben Zobrist on 10/9/25.
//

import zBitboard

extension Parser {
    
    public static func parseFEN(from tokens: [Token]) throws -> [BoardState] {
        // Verify only correct tokens
        let validTokens = [TokenType.SYMBOL, .FORWARD_SLASH, .INTEGER]
        for token in tokens {
            guard validTokens.contains(token.tokenType) else {
                throw ParserError.unexpectedToken(token)
            }
        }
        
        // Parse 0 or more FEN
        var stream = TokenStream(tokens: tokens)
        var states: [BoardState] = []
        while !stream.isAtEnd {
            // Skip any stray whitespace or unexpected tokens between FEN
            if let t = stream.peek(), t.tokenType == .SYMBOL || t.tokenType == .INTEGER {
                let s = try self.matchState(&stream)
                states.append(s)
            } else {
                // If we see junk (like comments outside a game), just consume and skip
                stream.consume()
            }
        }
        
        return states
    }
    
    private static func matchState(_ stream: inout TokenStream) throws -> BoardState {
        var whitePawns: Bitboard = .empty
        var whiteKnights: Bitboard = .empty
        var whiteBishops: Bitboard = .empty
        var whiteRooks: Bitboard = .empty
        var whiteQueens: Bitboard = .empty
        var whiteKing: Bitboard = .empty
        var blackPawns: Bitboard = .empty
        var blackKnights: Bitboard = .empty
        var blackBishops: Bitboard = .empty
        var blackRooks: Bitboard = .empty
        var blackQueens: Bitboard = .empty
        var blackKing: Bitboard = .empty
        
        var rank = 7
        while rank >= 0 {
            var file = 0
            guard let current = stream.peek() else { throw ParserError.unexpectedEOF }
            stream.consume()
            
            if current.tokenType == .FORWARD_SLASH {
                continue
            }
            
            while file <= 7 {
                if current.tokenType == .SYMBOL {
                    for currPiece in current.value {
                        let sq = Square(rawValue: (rank*8) + file)!
                        if currPiece == "K" {
                            whiteKing |= Bitboard.squareMask(sq)
                        } else if currPiece == "Q" {
                            whiteQueens |= Bitboard.squareMask(sq)
                        } else if currPiece == "R" {
                            whiteRooks |= Bitboard.squareMask(sq)
                        } else if currPiece == "B" {
                            whiteBishops |= Bitboard.squareMask(sq)
                        } else if currPiece == "N" {
                            whiteKnights |= Bitboard.squareMask(sq)
                        } else if currPiece == "P" {
                            whitePawns |= Bitboard.squareMask(sq)
                        } else if currPiece == "k" {
                            blackKing |= Bitboard.squareMask(sq)
                        } else if currPiece == "q" {
                            blackQueens |= Bitboard.squareMask(sq)
                        } else if currPiece == "r" {
                            blackRooks |= Bitboard.squareMask(sq)
                        } else if currPiece == "b" {
                            blackBishops |= Bitboard.squareMask(sq)
                        } else if currPiece == "n" {
                            blackKnights |= Bitboard.squareMask(sq)
                        } else if currPiece == "p" {
                            blackPawns |= Bitboard.squareMask(sq)
                        } else if currPiece.isNumber,
                                  let intPiece = Int("\(currPiece)") {
                            let emptySquares = intPiece - 1
                            file += emptySquares
                            guard (0...7).contains(file) else { throw ParserError.invalidInteger(current.value) }
                        } else {
                            throw ParserError.invalidCharacter(current.value)
                        }
                        file += 1
                        guard (1...8).contains(file) else { throw ParserError.invalidCharacter(current.value) }
                    }
                } else if current.tokenType == .INTEGER {
                    guard let emptySquares = Int(current.value) else { throw ParserError.invalidInteger(current.value) }
                    guard (1...8).contains(emptySquares) else { throw ParserError.invalidInteger(current.value) }

                    file += (emptySquares)
                    guard (1...8).contains(file) else { throw ParserError.invalidInteger(current.value) }

                }
            }
            
            rank -= 1
        }
        
        let playerToMove = try self.matchPlayerToMove(&stream)
        let castlingRights = try self.matchCastlingRights(&stream)
        let enpassantTargetSquare = try self.matchEnPassantTargetSquare(&stream)

        
        // TODO: Halfmove Clock isn't something I do anything with at the moment
        let _ = try self.matchInteger(&stream) // halfMoveClock
        let fullMoveClock = try self.matchInteger(&stream)
        let plyNumber = ((fullMoveClock - 1) * 2) + (playerToMove == .black ? 1 : 0)
        
        return BoardState(
            whitePawns: whitePawns,
            whiteKnights: whiteKnights,
            whiteBishops: whiteBishops,
            whiteRooks: whiteRooks,
            whiteQueens: whiteQueens,
            whiteKing: whiteKing,
            blackPawns: blackPawns,
            blackKnights: blackKnights,
            blackBishops: blackBishops,
            blackRooks: blackRooks,
            blackQueens: blackQueens,
            blackKing: blackKing,
            plyNumber: plyNumber,
            playerToMove: playerToMove,
            enpassantTargetSqauare: enpassantTargetSquare,
            castlingRights: castlingRights
        )
    }
    
    private static func matchPlayerToMove(_ stream: inout TokenStream) throws -> PlayerColor {
        guard let token = stream.peek() else { throw ParserError.unexpectedEOF }
        guard token.tokenType == .SYMBOL else { throw ParserError.unexpectedToken(token)}
        stream.consume()
        
        return token.value == "w" ? PlayerColor.white : PlayerColor.black
    }

    private static func matchCastlingRights(_ stream: inout TokenStream) throws -> [CastlingRights] {
        guard let token = stream.peek() else { throw ParserError.unexpectedEOF }
        guard token.tokenType == .SYMBOL else { throw ParserError.unexpectedToken(token)}
        stream.consume()
        
        var castlingRights: [CastlingRights] = []
        if token.value.contains("K") {
            castlingRights.append(.K)
        }
        if token.value.contains("Q") {
            castlingRights.append(.Q)
        }
        if token.value.contains("k") {
            castlingRights.append(.k)
        }
        if token.value.contains("q") {
            castlingRights.append(.q)
        }
        
        guard token.value.count == castlingRights.count || token.value == "-" else {
            throw ParserError.invalidCastlingRights(token.value)
        }
        
        return castlingRights
    }
    
    private static func matchEnPassantTargetSquare(_ stream: inout TokenStream) throws -> Bitboard {
        guard let token = stream.peek() else { throw ParserError.unexpectedEOF }
        guard token.tokenType == .SYMBOL else { throw ParserError.unexpectedToken(token)}
        stream.consume()
        
        let bb: Bitboard
        if token.value == "-" {
            bb = .empty
        } else if let sq = Square.stringToSquare(token.value){
            bb = Bitboard.squareMask(sq)
        } else {
            throw ParserError.invalidEnPassantTargetSquare(token.value)
        }
        
        return bb
    }
    
    private static func matchInteger(_ stream: inout TokenStream) throws -> Int {
        guard let token = stream.peek() else { throw ParserError.unexpectedEOF }
        guard token.tokenType == .INTEGER else { throw ParserError.unexpectedToken(token)}
        stream.consume()
        
        guard let number = Int(token.value) else { throw ParserError.invalidInteger(token.value) }
        
        return number
    }
}
