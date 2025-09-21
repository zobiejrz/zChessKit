//
//  PlayerColor.swift
//  zChessKit
//
//  Created by Ben Zobrist on 9/15/25.
//

enum PlayerColor: String, Codable {
    case white="white", black="black"
}


extension PlayerColor {
    func opposite() -> PlayerColor {
        return self == .white ? .black : .white
    }
}
