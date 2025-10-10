//
//  BoardState+isValidMove.swift
//  zChessKit
//
//  Created by Ben Zobrist on 10/9/25.
//

import zBitboard

extension BoardState {
    /// Evaluates if a move is valid, returning the associated Move object if valid.
    func isValidMove(piece: PieceType, from origin: Square, to dest: Square, promotion: PieceType? = nil) -> Move? {
        let moves = self.generateAllLegalMoves()
        
        if let foundIndex = moves.firstIndex(where: {
            $0.piece == piece &&
            $0.from == origin &&
            $0.to == dest &&
            $0.promotion == promotion
        }) {
            return moves[foundIndex]
        }
        
        return nil
    }
}
