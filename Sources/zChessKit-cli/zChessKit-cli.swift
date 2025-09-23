//
//  zChessKit-cli.swift
//  zChessKit
//
//  Created by Ben Zobrist on 9/15/25.
//

import zChessKit
import zBitboard

@main
struct zChessKitCLI {
    
    static func main() {
        var game = Game()
        while game.getGameResult() == .ongoing {
            print(game.currentState.boardString())
            let color: PlayerColor = game.currentState.playerToMove == PlayerColor.white ? .white : .black
            print("\(color) move:", terminator: " ")
            
            // piece square square [promotion piece]
            let input = readLine()
            
            if input == "moves" {
                let moves = game.currentState.generateAllLegalMoves()
                print("There are \(moves.count) moves available")
                for move in moves {
                    if move.promotion != nil {
                        print("\t\(move.piece) from \(move.from) to \(move.to) = \(move.promotion!)")
                    } else {
                        print("\t\(move.piece) from \(move.from) to \(move.to)")
                    }
                }
                
            } else {
                guard let san = input else {
                    print("invalid move")
                    continue
                }
                if game.makeSANMove(san) {
                    let last = game.moves[game.moves.count - 1]
                    if last.promotion != nil {
                        print("\tmoved \(last.piece) from \(last.from) to \(last.to) = \(last.promotion!)")
                    } else {
                        print("\tmoved \(last.piece) from \(last.from) to \(last.to)")
                    }
                } else {
                    print("\tmove invalid")
                }
            }
        }
        
        print("\nGame finished - \(game.getGameResult())")
        print(game.currentState.boardString())
        return
    }
}
