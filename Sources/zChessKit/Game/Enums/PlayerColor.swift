//
//  PlayerColor.swift
//  zChessKit
//
//  Created by Ben Zobrist on 9/15/25.
//

public enum PlayerColor: String, Codable {
    case white="white", black="black"

    func opposite() -> PlayerColor {
        return self == .white ? .black : .white
    }
}
