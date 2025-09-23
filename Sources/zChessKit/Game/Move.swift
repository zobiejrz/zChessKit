//
//  Move.swift
//  zChessKit
//
//  Created by Ben Zobrist on 9/15/25.
//

import Foundation
import zBitboard

public struct Move {
    // MARK: - Core Move Data
    public let from: Square
    public let to: Square
    public let piece: PieceType
    public let capturedPiece: PieceType?
    public let promotion: PieceType?
    
    // MARK: - Game State
    public let resultingBoardState: BoardState
    public let ply: Int
    public let color: PlayerColor
    public let isCastling: Bool
    
    // MARK: - Annotations
    public var annotation: String?      // e.g. "!!", "?", "good move", "dubious"
    public var nags: [Int]              // Numeric Annotation Glyphs (e.g. 1 = "!", 2 = "?")
    
    // MARK: - Tree Structure
    public var variations: [Move]       // Represents alternative lines from this position
    
    // MARK: - Computed Notation (Not stored)
    public var san: String {
        // Compute Standard Algebraic Notation (e.g. "e4", "Nxf6", "O-O")
        // Requires access to board state before this move
        return "" // TODO: Placeholder
    }
    
    public var uci: String {
        // Compute Universal Chess Interface format (e.g. "e2e4", "e7e8q")
        // Format: from square + to square + promotion (if any)
        return "" // TODO: Placeholder
    }
    
    // MARK: - Init
    public init(
        from: Square,
        to: Square,
        piece: PieceType,
        capturedPiece: PieceType? = nil,
        promotion: PieceType? = nil,
        resultingBoardState: BoardState,
        annotation: String? = nil,
        nags: [Int] = [],
        ply: Int,
        color: PlayerColor,
        isCastling: Bool = false,
        variations: [Move] = []
    ) {
        self.from = from
        self.to = to
        self.piece = piece
        self.capturedPiece = capturedPiece
        self.promotion = promotion
        self.resultingBoardState = resultingBoardState
        self.annotation = annotation
        self.nags = nags
        self.ply = ply
        self.color = color
        self.isCastling = isCastling
        self.variations = variations
    }
}

extension Move: Equatable {
    public static func == (lhs: Move, rhs: Move) -> Bool {
        return (
            lhs.from == rhs.from &&
            lhs.to == rhs.to &&
            lhs.piece == rhs.piece &&
            lhs.capturedPiece == rhs.capturedPiece &&
            lhs.promotion == rhs.promotion &&
//            lhs.resultingBoardState == rhs.resultingBoardState &&
            lhs.ply == rhs.ply &&
            lhs.color == rhs.color &&
            lhs.isCastling == rhs.isCastling &&
            lhs.variations == rhs.variations
        )
        
    }
}
