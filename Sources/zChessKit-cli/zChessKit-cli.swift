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
    
    static func stringToSquare(_ square: String) -> Square? {
        guard square.count == 2,
              let fileChar = square.first,
              let rankChar = square.last,
              let file = "abcdefgh".firstIndex(of: fileChar),
              let rank = Int(String(rankChar))
        else {
            return nil
        }
        
        let fileIndex = "abcdefgh".distance(from: "abcdefgh".startIndex, to: file)
        let rankIndex = rank - 1
        
        let value = rankIndex * 8 + fileIndex
        
        if value >= 0 && value < 64 {
            return Square(rawValue: value)!
        } else {
            return nil
        }
    }
    
    static func main() {
        var game = Game()
        while game.getGameResult() == .ongoing {
            print(game.currentState.boardString())
            let color: PlayerColor = game.currentState.playerToMove == PlayerColor.white ? .white : .black
            print("\(color) move:", terminator: " ")
            
            // piece square square [promotion piece]
            let move = readLine()
            
            let moveArr = move!.components(separatedBy: " ")
            guard moveArr.count >= 3 else {
                print("\tformat is '<piece> <square> <square> [promotion piece]'")
                continue
            }
            
            guard let piece = PieceType.fromString(moveArr[0]) else {
                print("\tpieces should be the single letter or the full name of the piece (i.e. 'n' for 'knight')")
                continue
            }
            
            guard let originSquare = stringToSquare(moveArr[1]) else {
                print("\tsquares should be the two character algebraic notation for a chess square (i.e. 'e4' or 'a1')")
                continue
            }
            
            guard let destSquare = stringToSquare(moveArr[2]) else {
                print("\tsquares should be the two character algebraic notation for a chess square (i.e. 'e4' or 'a1')")
                continue
            }
            
            let promotionPiece: PieceType?
            if moveArr.count > 3 {
                promotionPiece = PieceType.fromString(moveArr[3])
                guard promotionPiece != nil else {
                    print("\tpieces should be the single letter or the full name of the piece (i.e. 'n' for 'knight')")
                    continue
                }
                
                guard [.queen, .rook, .bishop, .knight].contains(promotionPiece) else {
                    print("\tpromotion pieces should be one of 'queen', 'rook', 'bishop', or 'knight'")
                    continue
                }
            } else {
                promotionPiece = nil
            }
            
            if game.makeMove(piece: piece, from: originSquare, to: destSquare, promotion: promotionPiece) {
                if promotionPiece != nil {
                    print("\tmoved \(piece) from \(originSquare) to \(destSquare) = \(promotionPiece!)")
                } else {
                    print("\tmoved \(piece) from \(originSquare) to \(destSquare)")
                }
            } else {
                print("\tmove invalid")
            }
        }
        
        print("\nGame finished - \(game.getGameResult())")
        return
    }
}
