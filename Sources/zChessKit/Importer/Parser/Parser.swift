//
//  Parser.swift
//  zchess
//
//  Created by Ben Zobrist on 9/12/25.
//

class Parser {
    
    enum ParserError: Error {
        // possible errors the parser can throw are here
        case unexpectedToken(Token)
        case invalidMove(String)
        case missingResult
        case unterminatedVariation
        case unexpectedEOF
    }
    
//    func parse(tokens: [Token]) -> [Game] {
//        var games: [Game] = []
//        
//        // match one or more games
//        // if an error occurs parsing a game, throw some error
//        //
//        
//        return games
//    }
//    
//    private func parseGame(_ tokens: [Token]) -> (Game?, [Token]) {
//        // match the header list
//        // match the move list
//        // match the result symbol
//        
////        var (game, tokens) = self.matchHeaderList(tokens, Game())
//        
//        return (game, tokens)
//    }
//    
//    private func matchHeaderList(_ tokens: [Token], _ game: Game) -> (Game?, [Token]) {
//        var game = game
//        var remainingTokens = tokens
//        
//        // Match 0 or more headers here
//        // use game.setGamedata(for: String, value: String) to save into a dictionary
//        
//        return (game, remainingTokens)
//    }
//    
//    private func matchMoveList(_ tokens: [Token], _ game: Game) -> (Game?, [Token]) {
//        var game = game
//        var remainingTokens = tokens
//        
//        // Match 0 or more moves here
//        
//        return (game, remainingTokens)
//    }
//    
//    private func matchMove(_ stream: inout TokenStream, _ game: Game) throws -> Game {
//        var game = game
//        
//        // 1. Skip move numbers like `1.` or `1...`
//        if let t = stream.peek(), t.tokenType == .INTEGER {
//            stream.consume()
//            while stream.peek()?.tokenType == .PERIOD {
//                stream.consume()
//            }
//        }
//        
//        // 2. Consume the SAN move
//        guard let moveToken = stream.consume(), moveToken.tokenType == .SYMBOL else {
//            throw ParserError.unexpectedToken(stream.peek() ?? Token(tokenType: .SYMBOL, value: "EOF"))
//        }
//        let moveString = moveToken.value
//        
//        // 3. Apply move
//        // Here you'd resolve SAN -> actual move.
//        // Pseudocode: use generateAllLegalMoves() or a SAN parser.
//        /*
//         if !game.makeMove(fromSAN: moveString) {
//         throw ParserError.invalidMove(moveString)
//         }
//         */
//        
//        // 4. Collect optional NAGs and comments
//        let (annotations, nags) = matchAnnotations(&stream)
//        
//        // 5. Attach annotations/nags to the last move
//        if let _ = game.moves.last {
//            if !annotations.isEmpty {
//
//                let tmp: String = game.moves.last?.annotation ?? ""
//                if tmp == "" {
//                    game.setMoveAnnotation(to: game.moves.count-1, value: annotations)
//                } else {
//                    game.setMoveAnnotation(to: game.moves.count-1, value: "\(tmp) \(annotations)")
//                }                
//                
//            }
//            if !nags.isEmpty {
//                for n in nags {
//                    game.appendMoveNAG(to: game.moves.count-1, value: n)
//                }
//            }
//        }
//        
//        return game
//    }
//    
//    private func matchAnnotations(_ stream: inout TokenStream) -> (String, [Int]) {
//        var annotations: [String] = []
//        var nags: [Int] = []
//        
//        while let t = stream.peek() {
//            switch t.tokenType {
//            case .NAG:
//                _ = stream.consume()
//                if let val = Int(t.value.dropFirst()) { // "$5" → 5
//                    nags.append(val)
//                }
//            case .L_CURLY_BRACKET:
//                _ = stream.consume() // consume '{'
//                var comment = ""
//                while let next = stream.peek(), next.tokenType != .R_CURLY_BRACKET {
//                    comment += (stream.consume()?.value ?? "") + " "
//                }
//                if stream.peek()?.tokenType == .R_CURLY_BRACKET {
//                    _ = stream.consume() // consume '}'
//                }
//                annotations.append(comment.trimmingCharacters(in: .whitespaces))
//            default:
//                return (annotations.joined(separator: " "), nags) // stop when no more annotations
//            }
//        }
//        
//        return (annotations.joined(separator: " "), nags)
//    }

}
