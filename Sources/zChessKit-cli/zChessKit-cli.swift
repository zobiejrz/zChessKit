//
//  zChessKit-cli.swift
//  zChessKit
//
//  Created by Ben Zobrist on 9/15/25.
//

import zChessKit

var game = Game()
while true {
    print(game.moves.last.resultingBoardState)
    let color = game.moves.last.color == .white ? .black : .white
    print("\(color) move:")
    let move = readLine()
    
    // TODO: Actually something to play a game here
    // ... support san, as well as 'draw' & 'resign'
    // game.makeMove()
}
