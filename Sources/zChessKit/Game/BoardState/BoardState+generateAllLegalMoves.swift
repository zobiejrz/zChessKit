//
//  BoardState+generateAllLegalMoves.swift
//  zChessKit
//
//  Created by Ben Zobrist on 10/9/25.
//

import zBitboard

extension BoardState {
    // MARK: - generateAllLegalMoves
    public func generateAllLegalMoves(_ player: PlayerColor? = nil) -> [Move] {
        
        return self.generateAllPseudoMoves(player ?? self.playerToMove).filter {
            !$0.resultingBoardState.isKingInCheck(self.playerToMove)
        }
    }
}
