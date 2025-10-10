//
//  Parser+parsePGN.swift
//  zChessKit
//
//  Created by Ben Zobrist on 10/9/25.
//

extension Parser {
    
    public static func parsePGN(from tokens: [Token]) throws -> [Game] {
        var games: [Game] = []
        var stream = TokenStream(tokens: tokens)
        
        while !stream.isAtEnd {
            // Skip any stray whitespace or unexpected tokens between games
            if let t = stream.peek(), t.tokenType == .L_BRACKET || t.tokenType == .INTEGER || t.tokenType == .SYMBOL {
                let game = try matchGame(&stream)
                games.append(game)
            } else {
                // If we see junk (like comments outside a game), just consume and skip
                stream.consume()
            }
        }
        
        return games
    }
    
    private static func matchGame(_ stream: inout TokenStream) throws -> Game {
        var game = Game()
        
        // --- Header list ---
        game = try matchHeaderList(&stream, game)
        
        // --- Move list (includes result) ---
        game = try matchMoveList(&stream, game)
        
        // If no result was set in the movelist, default to "*"
        // TODO: Might not do this bit at all, TBD
        //        if game.result == nil {
        //            game.result = "*"
        //        }
        
        return game
    }
    
    private static func matchHeaderList(_ stream: inout TokenStream, _ game: Game) throws -> Game {
        let game = game
        
        while let token = stream.peek(), token.tokenType == .L_BRACKET {
            stream.consume() // consume '['
            
            guard let _ = stream.peek() else {
                throw ParserError.unexpectedEOF
            }
            
            // --- Tag name ---
            guard let tagToken = stream.consume(), tagToken.tokenType == .SYMBOL else {
                throw ParserError.unexpectedToken(stream.peek()!)
            }
            let tagName = tagToken.value
            
            // --- Tag value (quoted string) ---
            guard let valueToken = stream.consume(), valueToken.tokenType == .STRING else {
                throw ParserError.unexpectedToken(stream.peek()!)
            }
            let tagValue = String(valueToken.value.dropFirst().dropLast())
            
            // --- Closing bracket ---
            guard let rbr = stream.consume(), rbr.tokenType == .R_BRACKET else {
                throw ParserError.unexpectedToken(stream.peek()!)
            }
            
            // Save into game
            game.setGamedata(for: tagName, value: tagValue)
        }
        
        return game
    }
    
    private static func matchMoveList(_ stream: inout TokenStream, _ game: Game) throws -> Game {
        var game = game
        
        while let token = stream.peek() {
            switch token.tokenType {
                // --- Termination of move list ---
            case .ASTERISK,
                    .SYMBOL where ["1-0", "0-1", "1/2-1/2"].contains(token.value):
                // Consume and set result
                let _ = stream.consume()!
                // TODO: Is this something I even want to account for? I could just store in the tags or disregard
                //                game.result = resultToken.value
                return game
                
            case .L_BRACKET:
                // Start of a new PGN tags → stop parsing moves for this game
                return game
                
                // --- Otherwise, parse a move ---
            case .INTEGER, .SYMBOL:
                game = try matchMove(&stream, game)
                
                // --- Variations, comments, NAGs ---
                // You could either skip or support them here
            case .L_PARENTHESIS:
                // skip variation for now
                _ = stream.consume()
                var depth = 1
                while !stream.isAtEnd && depth > 0 {
                    if stream.peek()?.tokenType == .L_PARENTHESIS {
                        depth += 1
                    } else if stream.peek()?.tokenType == .R_PARENTHESIS {
                        depth -= 1
                    }
                    _ = stream.consume()
                }
                
            case .L_CURLY_BRACKET:
                // inline comment not attached to a move → skip
                _ = stream.consume()
                while let t = stream.peek(), t.tokenType != .R_CURLY_BRACKET {
                    _ = stream.consume()
                }
                if stream.peek()?.tokenType == .R_CURLY_BRACKET {
                    _ = stream.consume()
                }
                
            default:
                // We’ve hit something unexpected (e.g. start of next game)
                return game
            }
        }
        
        return game
    }
    
    private static func matchMove(_ stream: inout TokenStream, _ game: Game) throws -> Game {
        let game = game
        
        // 1. Skip move numbers like `1.` or `1...`
        if let t = stream.peek(), t.tokenType == .INTEGER {
            stream.consume()
            while stream.peek()?.tokenType == .PERIOD {
                stream.consume()
            }
        }
        
        // 2. Consume the SAN move
        guard let moveToken = stream.consume(), moveToken.tokenType == .SYMBOL else {
            throw ParserError.unexpectedToken(stream.peek() ?? Token(tokenType: .SYMBOL, value: "EOF"))
        }
        let moveString = moveToken.value
        
        // 3. Apply move
        if !game.makeSANMove(moveString) {
            throw ParserError.invalidMove(moveString)
        }
        
        // 4. Collect optional NAGs and comments
        let (annotations, nags) = matchAnnotations(&stream)
        
        // 5. Attach annotations/nags to the last move
        if let _ = game.moves.last {
            if !annotations.isEmpty {
                
                let tmp: String = game.moves.last?.annotation ?? ""
                if tmp == "" {
                    game.setMoveAnnotation(to: game.moves.count-1, value: annotations)
                } else {
                    game.setMoveAnnotation(to: game.moves.count-1, value: "\(tmp) \(annotations)")
                }
                
            }
            if !nags.isEmpty {
                for n in nags {
                    game.appendMoveNAG(to: game.moves.count-1, value: n)
                }
            }
        }
        
        return game
    }
    
    private static func matchAnnotations(_ stream: inout TokenStream) -> (String, [Int]) {
        var annotations: [String] = []
        var nags: [Int] = []
        
        while let t = stream.peek() {
            switch t.tokenType {
            case .NAG:
                _ = stream.consume()
                if let val = Int(t.value.dropFirst()) { // "$5" → 5
                    nags.append(val)
                }
            case .COMMENT:
                _ = stream.consume() // consume '{...}'
                var comment = t.value // '{...}' --> '...'
                comment.removeFirst()
                comment.removeLast()
                let cleaned = comment
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                    .replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
                
                annotations.append(cleaned)
            default:
                return (annotations.joined(separator: " "), nags) // stop when no more annotations
            }
        }
        
        return (annotations.joined(separator: " "), nags)
    }
    
}
