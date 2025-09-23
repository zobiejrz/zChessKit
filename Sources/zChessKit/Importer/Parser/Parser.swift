////
////  Parser.swift
////  zchess
////
////  Created by Ben Zobrist on 9/12/25.
////
//
//class Parser {
//    
//    func parse(tokens: [Token]) -> [Game] {
//        var games: [Game] = []
//        
//        while game, remaining = parseGame(tokens) {
//            if let game = game {
//                games.append(game)
//            } else {
//                // Handle error or skip invalid game
//                break
//            }
//        }
//        
//        return games
//    }
//    
//    private func parseGame(_ tokens: [Token]) -> (Game?, [Token]) {
//        
//        var (game, tokens) = self.matchHeaderList(tokens, Game())
//        
//        guard game != nil else { return (nil, tokens) }
//        
//        (game, tokens) = self.matchMoveList(tokens, game!)
//        
//        return (game, tokens)
//    }
//    
//    private func matchHeaderList(_ tokens: [Token], _ game: Game) -> (Game?, [Token]) {
//        var game = game
//        var remainingTokens = tokens
//        while remainingTokens[0].tokenType == .L_BRACKET {
//            remainingTokens.removeFirst()
//            
//            guard remainingTokens[0].tokenType == .SYMBOL else { fatalError("expected symbol token first") }
//            guard remainingTokens[1].tokenType == .STRING else { fatalError("expected string token second") }
//
//            let symbol = remainingTokens.removeFirst()
//            let string = remainingTokens.removeFirst()
//            
//            game.setGamedata(for: symbol.value, value: string.value)
//            
//            guard remainingTokens[0].tokenType == .R_BRACKET else { fatalError("expected r_bracket token first") }
//            
//            remainingTokens.removeFirst()
//        }
//        
//        return (game, remainingTokens)
//    }
//    
//    private func matchMoveList(_ tokens: [Token], _ game: Game) -> (Game?, [Token]) {
//        var game = game
//        var remainingTokens = tokens
//        while remainingTokens[0].tokenType == .INTEGER {
//            remainingTokens.removeFirst()
//            
//            guard remainingTokens[0].tokenType == .SYMBOL else { fatalError("expected symbol token first") }
//            guard remainingTokens[1].tokenType == .STRING else { fatalError("expected string token second") }
//            
//            let symbol = remainingTokens.removeFirst()
//            let string = remainingTokens.removeFirst()
//            
//            game.setGamedata(for: symbol.value, value: string.value)
//            
//            guard remainingTokens[0].tokenType == .R_BRACKET else { fatalError("expected r_bracket token first") }
//            
//            remainingTokens.removeFirst()
//        }
//        
//        return (game, remainingTokens)
//    }
//    
//    private func matchMove(_ tokens: [Token], _ game: Game) -> (Game?, [Token]) {
//        var game = game
//        var remainingTokens = tokens
//        
//        
//        guard remainingTokens[0].tokenType == .INTEGER else { fatalError("expected integer token first") }
//        guard remainingTokens[1].tokenType == .PERIOD else { fatalError("expected period token second") }
//            
//        let moveNumberToken = remainingTokens.removeFirst()
//        remainingTokens.removeFirst()
//        
//        if remainingTokens[0].tokenType == .SYMBOL {
////            let whitePiece =
//            
//            game.makeMove(
//                piece: <#T##PieceType#>,
//                from: <#T##Square#>,
//                to: <#T##Square#>,
//                promotion: <#T##PieceType?#>
//            )
//        } else if remainingTokens[0].tokenType == .PERIOD && remainingTokens[1].tokenType == .PERIOD {
//            
//        } else {
//            fatalError("invalid token for matching move")
//        }
//        
//        return (game, remainingTokens)
//    }
//}
