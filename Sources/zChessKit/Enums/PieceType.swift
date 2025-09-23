//
//  PieceType.swift
//  zChessKit
//
//  Created by Ben Zobrist on 9/15/25.
//

public enum PieceType: Codable {
    case pawn, knight, bishop, rook, queen, king
    
    public static func fromString(_ str: String) -> PieceType? {
        let str = str.lowercased()
        if str == "p" || str == "pawn" {
            return .pawn
        } else if str == "n" || str == "knight" {
            return .knight
        } else if str == "b" || str == "bishop" {
            return .bishop
        } else if str == "r" || str == "rook" {
            return .rook
        } else if str == "q" || str == "queen" {
            return .queen
        } else if str == "k" || str == "king" {
            return .king
        } else {
            return nil
        }
    }
}
