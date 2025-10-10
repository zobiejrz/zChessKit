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
        
        let playerToGenerate = player ?? self.playerToMove
        var output: [Move] = []
        
        // 1. Call all piece-specific generators based on playerToMove
        let pawnMoves = playerToGenerate == .white ? self.generateWhitePawnMoves() : self.generateBlackPawnMoves()
        let knightMoves = playerToGenerate == .white ? self.generateWhiteKnightMoves() : self.generateBlackKnightMoves()
        let bishopMoves = playerToGenerate == .white ? self.generateWhiteBishopMoves() : self.generateBlackBishopMoves()
        let rookMoves = playerToGenerate == .white ? self.generateWhiteRookMoves() : self.generateBlackRookMoves()
        let queenMoves = playerToGenerate == .white ? self.generateWhiteQueenMoves() : self.generateBlackQueenMoves()
        let kingMoves = playerToGenerate == .white ? self.generateWhiteKingMoves() : self.generateBlackKingMoves()
        
        // 2. Combine all possible pseudo-legal moves into Move Objects
        // MARK: Pawn Moves
        for move in pawnMoves {
            let originSquare = Square(rawValue: move.from.popLSB()!.0)!
            let originbb = Bitboard.squareMask(originSquare)
            let destSquare = Square(rawValue: move.to.popLSB()!.0)!
            let destbb = Bitboard.squareMask(destSquare)
            
            var whitePawns = self.whitePawns
            var blackPawns = self.blackPawns
            
            let possiblePromotions: [PieceType?] = (
                destbb & (Bitboard.rank1 | Bitboard.rank8) > 0 ?
                [.knight, .bishop, .rook, .queen] : [nil]
            )
            
            let capturedPiece: PieceType?
            if self.playerToMove == .white {
                if destbb == self.enpassantTargetSquare {
                    blackPawns &= ~(destbb.sShift())
                    capturedPiece = .pawn
                } else {
                    blackPawns &= ~destbb
                    capturedPiece = self.whatPieceIsOn(destSquare)
                }
                whitePawns = (whitePawns & ~originbb) | destbb
            } else { // self.playerToMove == .black
                if destbb == self.enpassantTargetSquare {
                    whitePawns &= ~(destbb.nShift())
                    capturedPiece = .pawn
                } else {
                    whitePawns &= ~destbb
                    capturedPiece = self.whatPieceIsOn(destSquare)
                }
                blackPawns = (blackPawns & ~originbb) | destbb
            }
            
            let newEPTargetSquare: Bitboard
            if self.playerToMove == .white && originbb.nShift().nShift() == destbb {
                newEPTargetSquare = originbb.nShift()
            } else if self.playerToMove == .black && originbb.sShift().sShift() == destbb {
                newEPTargetSquare = originbb.sShift()
            } else {
                newEPTargetSquare = .empty
            }
            
            let newCastlingRights: [CastlingRights]
            if capturedPiece == .rook {
                if playerToGenerate == .white { // remove black's ability to castle the direction we took their rook
                    if destSquare == .a8 {
                        newCastlingRights = self.castlingRights.filter { $0 != .q }
                    } else if destSquare == .h8 {
                        newCastlingRights = self.castlingRights.filter { $0 != .k }
                    } else {
                        newCastlingRights = self.castlingRights
                    }
                } else { // remove white's ability to castle the direction we took their rook
                    if destSquare == .a1 {
                        newCastlingRights = self.castlingRights.filter { $0 != .Q }
                    } else if destSquare == .h1 {
                        newCastlingRights = self.castlingRights.filter { $0 != .K }
                    } else {
                        newCastlingRights = self.castlingRights
                    }
                }
            } else {
                newCastlingRights = self.castlingRights
            }
            
            for promotion in possiblePromotions {
                let resultingBoardState: BoardState
                if self.playerToMove == .white {
                    resultingBoardState = BoardState(
                        whitePawns: whitePawns & ~Bitboard.rank8,
                        whiteKnights: promotion == .knight ? self.whiteKnights | (destbb & Bitboard.rank8) : self.whiteKnights,
                        whiteBishops: promotion == .bishop ? self.whiteBishops | (destbb & Bitboard.rank8) : self.whiteBishops,
                        whiteRooks: promotion == .rook ? self.whiteRooks | (destbb & Bitboard.rank8) : self.whiteRooks,
                        whiteQueens: promotion == .queen ? self.whiteQueens | (destbb & Bitboard.rank8) : self.whiteQueens,
                        whiteKing: self.whiteKing,
                        blackPawns: blackPawns,
                        blackKnights: self.blackKnights & ~destbb,
                        blackBishops: self.blackBishops & ~destbb,
                        blackRooks: self.blackRooks & ~destbb,
                        blackQueens: self.blackQueens & ~destbb,
                        blackKing: self.blackKing & ~destbb,
                        plyNumber: self.plyNumber+1,
                        playerToMove: self.playerToMove.opposite(),
                        enpassantTargetSqauare: newEPTargetSquare,
                        castlingRights: newCastlingRights
                    )
                } else {
                    resultingBoardState = BoardState(
                        whitePawns: whitePawns,
                        whiteKnights: self.whiteKnights & ~destbb,
                        whiteBishops: self.whiteBishops & ~destbb,
                        whiteRooks: self.whiteRooks & ~destbb,
                        whiteQueens: self.whiteQueens & ~destbb,
                        whiteKing: self.whiteKing & ~destbb,
                        blackPawns: blackPawns & ~Bitboard.rank1,
                        blackKnights: promotion == .knight ? self.blackKnights | (destbb & Bitboard.rank1) : self.blackKnights,
                        blackBishops: promotion == .bishop ? self.blackBishops | (destbb & Bitboard.rank1) : self.blackBishops,
                        blackRooks: promotion == .rook ? self.blackRooks | (destbb & Bitboard.rank1) : self.blackRooks,
                        blackQueens: promotion == .queen ? self.blackQueens | (destbb & Bitboard.rank1) : self.blackQueens,
                        blackKing: self.blackKing,
                        plyNumber: self.plyNumber+1,
                        playerToMove: self.playerToMove.opposite(),
                        enpassantTargetSqauare: newEPTargetSquare,
                        castlingRights: newCastlingRights
                    )
                }
                
                // 3. Filter out illegal moves (e.g., moves that get/leave king in check)
                guard !resultingBoardState.isKingInCheck(self.playerToMove) else {
                    continue
                }
                
                let sanMove = self.generateSAN(
                    from: originSquare,
                    to: destSquare,
                    piece: .pawn,
                    capturedPiece: capturedPiece,
                    promotion: promotion,
                    isCastling: false,
                    resultingBoardState: resultingBoardState
                )
                
                let move = Move(
                    from: originSquare,
                    to: destSquare,
                    piece: .pawn,
                    capturedPiece: capturedPiece,
                    promotion: promotion,
                    resultingBoardState: resultingBoardState,
                    ply: self.plyNumber+1,
                    color: self.playerToMove.opposite(),
                    san: sanMove
                )
                output.append(move)
            }
        }
        
        // MARK: Knight Moves
        for move in knightMoves {
            let originSquare = Square(rawValue: move.from.popLSB()!.0)!
            let originbb = Bitboard.squareMask(originSquare)
            let destSquare = Square(rawValue: move.to.popLSB()!.0)!
            let destbb = Bitboard.squareMask(destSquare)
            
            let capturedPiece: PieceType? = self.whatPieceIsOn(destSquare)
            
            let newCastlingRights: [CastlingRights]
            if capturedPiece == .rook {
                if playerToGenerate == .white { // remove black's ability to castle the direction we took their rook
                    if destSquare == .a8 {
                        newCastlingRights = self.castlingRights.filter { $0 != .q }
                    } else if destSquare == .h8 {
                        newCastlingRights = self.castlingRights.filter { $0 != .k }
                    } else {
                        newCastlingRights = self.castlingRights
                    }
                } else { // remove white's ability to castle the direction we took their rook
                    if destSquare == .a1 {
                        newCastlingRights = self.castlingRights.filter { $0 != .Q }
                    } else if destSquare == .h1 {
                        newCastlingRights = self.castlingRights.filter { $0 != .K }
                    } else {
                        newCastlingRights = self.castlingRights
                    }
                }
            } else {
                newCastlingRights = self.castlingRights
            }
            
            let resultingBoardState: BoardState
            if self.playerToMove == .white {
                resultingBoardState = BoardState(
                    whitePawns: self.whitePawns,
                    whiteKnights: (self.whiteKnights & ~originbb) | destbb,
                    whiteBishops: self.whiteBishops,
                    whiteRooks: self.whiteRooks,
                    whiteQueens: self.whiteQueens,
                    whiteKing: self.whiteKing,
                    blackPawns: self.blackPawns & ~destbb,
                    blackKnights: self.blackKnights & ~destbb,
                    blackBishops: self.blackBishops & ~destbb,
                    blackRooks: self.blackRooks & ~destbb,
                    blackQueens: self.blackQueens & ~destbb,
                    blackKing: self.blackKing & ~destbb,
                    plyNumber: self.plyNumber+1,
                    playerToMove: self.playerToMove.opposite(),
                    enpassantTargetSqauare: Bitboard.empty,
                    castlingRights: newCastlingRights
                )
            } else {
                resultingBoardState = BoardState(
                    whitePawns: self.whitePawns & ~destbb,
                    whiteKnights: self.whiteKnights & ~destbb,
                    whiteBishops: self.whiteBishops & ~destbb,
                    whiteRooks: self.whiteRooks & ~destbb,
                    whiteQueens: self.whiteQueens & ~destbb,
                    whiteKing: self.whiteKing & ~destbb,
                    blackPawns: self.blackPawns,
                    blackKnights: (self.blackKnights & ~originbb) | destbb,
                    blackBishops: self.blackBishops,
                    blackRooks: self.blackRooks,
                    blackQueens: self.blackQueens,
                    blackKing: self.blackKing,
                    plyNumber: self.plyNumber+1,
                    playerToMove: self.playerToMove.opposite(),
                    enpassantTargetSqauare: Bitboard.empty,
                    castlingRights: newCastlingRights
                )
            }
            
            // 3. Filter out illegal moves (e.g., moves that get/leave king in check)
            guard !resultingBoardState.isKingInCheck(self.playerToMove) else {
                continue
            }
            
            let sanMove = self.generateSAN(
                from: originSquare,
                to: destSquare,
                piece: .knight,
                capturedPiece: capturedPiece,
                promotion: nil,
                isCastling: false,
                resultingBoardState: resultingBoardState
            )
            
            let move = Move(
                from: originSquare,
                to: destSquare,
                piece: .knight,
                capturedPiece: capturedPiece,
                promotion: nil,
                resultingBoardState: resultingBoardState,
                ply: self.plyNumber+1,
                color: self.playerToMove.opposite(),
                san: sanMove
            )
            
            output.append(move)
        }
        
        // MARK: Bishop Moves
        for move in bishopMoves {
            let originSquare = Square(rawValue: move.from.popLSB()!.0)!
            let originbb = Bitboard.squareMask(originSquare)
            let destSquare = Square(rawValue: move.to.popLSB()!.0)!
            let destbb = Bitboard.squareMask(destSquare)
            
            let capturedPiece: PieceType? = self.whatPieceIsOn(destSquare)
            
            let newCastlingRights: [CastlingRights]
            if capturedPiece == .rook {
                if playerToGenerate == .white { // remove black's ability to castle the direction we took their rook
                    if destSquare == .a8 {
                        newCastlingRights = self.castlingRights.filter { $0 != .q }
                    } else if destSquare == .h8 {
                        newCastlingRights = self.castlingRights.filter { $0 != .k }
                    } else {
                        newCastlingRights = self.castlingRights
                    }
                } else { // remove white's ability to castle the direction we took their rook
                    if destSquare == .a1 {
                        newCastlingRights = self.castlingRights.filter { $0 != .Q }
                    } else if destSquare == .h1 {
                        newCastlingRights = self.castlingRights.filter { $0 != .K }
                    } else {
                        newCastlingRights = self.castlingRights
                    }
                }
            } else {
                newCastlingRights = self.castlingRights
            }
            
            let resultingBoardState: BoardState
            if self.playerToMove == .white {
                resultingBoardState = BoardState(
                    whitePawns: self.whitePawns,
                    whiteKnights: self.whiteKnights,
                    whiteBishops: (self.whiteBishops & ~originbb) | destbb,
                    whiteRooks: self.whiteRooks,
                    whiteQueens: self.whiteQueens,
                    whiteKing: self.whiteKing,
                    blackPawns: self.blackPawns & ~destbb,
                    blackKnights: self.blackKnights & ~destbb,
                    blackBishops: self.blackBishops & ~destbb,
                    blackRooks: self.blackRooks & ~destbb,
                    blackQueens: self.blackQueens & ~destbb,
                    blackKing: self.blackKing & ~destbb,
                    plyNumber: self.plyNumber+1,
                    playerToMove: self.playerToMove.opposite(),
                    enpassantTargetSqauare: Bitboard.empty,
                    castlingRights: newCastlingRights
                )
            } else {
                resultingBoardState = BoardState(
                    whitePawns: self.whitePawns & ~destbb,
                    whiteKnights: self.whiteKnights & ~destbb,
                    whiteBishops: self.whiteBishops & ~destbb,
                    whiteRooks: self.whiteRooks & ~destbb,
                    whiteQueens: self.whiteQueens & ~destbb,
                    whiteKing: self.whiteKing & ~destbb,
                    blackPawns: self.blackPawns,
                    blackKnights: self.blackKnights,
                    blackBishops: (self.blackBishops & ~originbb) | destbb,
                    blackRooks: self.blackRooks,
                    blackQueens: self.blackQueens,
                    blackKing: self.blackKing,
                    plyNumber: self.plyNumber+1,
                    playerToMove: self.playerToMove.opposite(),
                    enpassantTargetSqauare: Bitboard.empty,
                    castlingRights: newCastlingRights
                )
            }
            
            // 3. Filter out illegal moves (e.g., moves that get/leave king in check)
            guard !resultingBoardState.isKingInCheck(self.playerToMove) else {
                continue
            }
            
            let sanMove = self.generateSAN(
                from: originSquare,
                to: destSquare,
                piece: .bishop,
                capturedPiece: capturedPiece,
                promotion: nil,
                isCastling: false,
                resultingBoardState: resultingBoardState
            )
            
            let move = Move(
                from: originSquare,
                to: destSquare,
                piece: .bishop,
                capturedPiece: capturedPiece,
                promotion: nil,
                resultingBoardState: resultingBoardState,
                ply: self.plyNumber+1,
                color: self.playerToMove.opposite(),
                san: sanMove
            )
            
            output.append(move)
        }
        
        // MARK: Rook Moves
        for move in rookMoves {
            let originSquare = Square(rawValue: move.from.popLSB()!.0)!
            let originbb = Bitboard.squareMask(originSquare)
            let destSquare = Square(rawValue: move.to.popLSB()!.0)!
            let destbb = Bitboard.squareMask(destSquare)
            
            let capturedPiece: PieceType? = self.whatPieceIsOn(destSquare)
            
            var newCastlingRights: [CastlingRights] = []
            if capturedPiece == .rook {
                if playerToGenerate == .white { // remove black's ability to castle the direction we took their rook
                    if destSquare == .a8 {
                        newCastlingRights = self.castlingRights.filter { $0 != .q }
                    } else if destSquare == .h8 {
                        newCastlingRights = self.castlingRights.filter { $0 != .k }
                    } else {
                        newCastlingRights = self.castlingRights
                    }
                } else { // remove white's ability to castle the direction we took their rook
                    if destSquare == .a1 {
                        newCastlingRights = self.castlingRights.filter { $0 != .Q }
                    } else if destSquare == .h1 {
                        newCastlingRights = self.castlingRights.filter { $0 != .K }
                    } else {
                        newCastlingRights = self.castlingRights
                    }
                }
            } else {
                newCastlingRights = self.castlingRights
            }
            
            let resultingBoardState: BoardState
            if self.playerToMove == .white {
                // Remove our own ability to castle if we move our rook
                if originSquare == .a1 {
                    newCastlingRights = newCastlingRights.filter { $0 != .Q }
                } else if originSquare == .h1 {
                    newCastlingRights = newCastlingRights.filter { $0 != .K }
                }
                resultingBoardState = BoardState(
                    whitePawns: self.whitePawns,
                    whiteKnights: self.whiteKnights,
                    whiteBishops: self.whiteBishops,
                    whiteRooks: (self.whiteRooks & ~originbb) | destbb,
                    whiteQueens: self.whiteQueens,
                    whiteKing: self.whiteKing,
                    blackPawns: self.blackPawns & ~destbb,
                    blackKnights: self.blackKnights & ~destbb,
                    blackBishops: self.blackBishops & ~destbb,
                    blackRooks: self.blackRooks & ~destbb,
                    blackQueens: self.blackQueens & ~destbb,
                    blackKing: self.blackKing & ~destbb,
                    plyNumber: self.plyNumber+1,
                    playerToMove: self.playerToMove.opposite(),
                    enpassantTargetSqauare: Bitboard.empty,
                    castlingRights: newCastlingRights
                )
            } else {
                // Remove our own ability to castle if we move our rook
                if originSquare == .a8 {
                    newCastlingRights = newCastlingRights.filter { $0 != .q }
                } else if originSquare == .h8 {
                    newCastlingRights = newCastlingRights.filter { $0 != .k }
                }
                resultingBoardState = BoardState(
                    whitePawns: self.whitePawns & ~destbb,
                    whiteKnights: self.whiteKnights & ~destbb,
                    whiteBishops: self.whiteBishops & ~destbb,
                    whiteRooks: self.whiteRooks & ~destbb,
                    whiteQueens: self.whiteQueens & ~destbb,
                    whiteKing: self.whiteKing & ~destbb,
                    blackPawns: self.blackPawns,
                    blackKnights: self.blackKnights,
                    blackBishops: self.blackBishops,
                    blackRooks: (self.blackRooks & ~originbb) | destbb,
                    blackQueens: self.blackQueens,
                    blackKing: self.blackKing,
                    plyNumber: self.plyNumber+1,
                    playerToMove: self.playerToMove.opposite(),
                    enpassantTargetSqauare: Bitboard.empty,
                    castlingRights: newCastlingRights
                )
            }
            
            // 3. Filter out illegal moves (e.g., moves that get/leave king in check)
            guard !resultingBoardState.isKingInCheck(self.playerToMove) else {
                continue
            }
            
            let sanMove = self.generateSAN(
                from: originSquare,
                to: destSquare,
                piece: .rook,
                capturedPiece: capturedPiece,
                promotion: nil,
                isCastling: false,
                resultingBoardState: resultingBoardState
            )
            
            let move = Move(
                from: originSquare,
                to: destSquare,
                piece: .rook,
                capturedPiece: capturedPiece,
                promotion: nil,
                resultingBoardState: resultingBoardState,
                ply: self.plyNumber+1,
                color: self.playerToMove.opposite(),
                san: sanMove
            )
            
            output.append(move)
        }
        
        // MARK: Queen Moves
        for move in queenMoves {
            let originSquare = Square(rawValue: move.from.popLSB()!.0)!
            let originbb = Bitboard.squareMask(originSquare)
            let destSquare = Square(rawValue: move.to.popLSB()!.0)!
            let destbb = Bitboard.squareMask(destSquare)
            
            let capturedPiece: PieceType? = self.whatPieceIsOn(destSquare)
            
            let newCastlingRights: [CastlingRights]
            if capturedPiece == .rook {
                if playerToGenerate == .white { // remove black's ability to castle the direction we took their rook
                    if destSquare == .a8 {
                        newCastlingRights = self.castlingRights.filter { $0 != .q }
                    } else if destSquare == .h8 {
                        newCastlingRights = self.castlingRights.filter { $0 != .k }
                    } else {
                        newCastlingRights = self.castlingRights
                    }
                } else { // remove white's ability to castle the direction we took their rook
                    if destSquare == .a1 {
                        newCastlingRights = self.castlingRights.filter { $0 != .Q }
                    } else if destSquare == .h1 {
                        newCastlingRights = self.castlingRights.filter { $0 != .K }
                    } else {
                        newCastlingRights = self.castlingRights
                    }
                }
            } else {
                newCastlingRights = self.castlingRights
            }
            
            let resultingBoardState: BoardState
            if self.playerToMove == .white {
                resultingBoardState = BoardState(
                    whitePawns: self.whitePawns,
                    whiteKnights: self.whiteKnights,
                    whiteBishops: self.whiteBishops,
                    whiteRooks: self.whiteRooks,
                    whiteQueens: (self.whiteQueens & ~originbb) | destbb,
                    whiteKing: self.whiteKing,
                    blackPawns: self.blackPawns & ~destbb,
                    blackKnights: self.blackKnights & ~destbb,
                    blackBishops: self.blackBishops & ~destbb,
                    blackRooks: self.blackRooks & ~destbb,
                    blackQueens: self.blackQueens & ~destbb,
                    blackKing: self.blackKing & ~destbb,
                    plyNumber: self.plyNumber+1,
                    playerToMove: self.playerToMove.opposite(),
                    enpassantTargetSqauare: Bitboard.empty,
                    castlingRights: newCastlingRights
                )
            } else {
                resultingBoardState = BoardState(
                    whitePawns: self.whitePawns & ~destbb,
                    whiteKnights: self.whiteKnights & ~destbb,
                    whiteBishops: self.whiteBishops & ~destbb,
                    whiteRooks: self.whiteRooks & ~destbb,
                    whiteQueens: self.whiteQueens & ~destbb,
                    whiteKing: self.whiteKing & ~destbb,
                    blackPawns: self.blackPawns,
                    blackKnights: self.blackKnights,
                    blackBishops: self.blackBishops,
                    blackRooks: self.blackRooks,
                    blackQueens: (self.blackQueens & ~originbb) | destbb,
                    blackKing: self.blackKing,
                    plyNumber: self.plyNumber+1,
                    playerToMove: self.playerToMove.opposite(),
                    enpassantTargetSqauare: Bitboard.empty,
                    castlingRights: newCastlingRights
                )
            }
            
            // 3. Filter out illegal moves (e.g., moves that get/leave king in check)
            guard !resultingBoardState.isKingInCheck(self.playerToMove) else {
                continue
            }
            
            let sanMove = self.generateSAN(
                from: originSquare,
                to: destSquare,
                piece: .queen,
                capturedPiece: capturedPiece,
                promotion: nil,
                isCastling: false,
                resultingBoardState: resultingBoardState
            )
            
            let move = Move(
                from: originSquare,
                to: destSquare,
                piece: .queen,
                capturedPiece: capturedPiece,
                promotion: nil,
                resultingBoardState: resultingBoardState,
                ply: self.plyNumber+1,
                color: self.playerToMove.opposite(),
                san: sanMove
            )
            
            output.append(move)
        }
        
        // MARK: King Moves
        for move in kingMoves {
            let originSquare = Square(rawValue: move.from.popLSB()!.0)!
            //            let originbb = Bitboard.squareMask(originSquare)
            let destSquare = Square(rawValue: move.to.popLSB()!.0)!
            let destbb = Bitboard.squareMask(destSquare)
            
            let capturedPiece: PieceType? = self.whatPieceIsOn(destSquare)
            
            var newCastlingRights: [CastlingRights]
            if capturedPiece == .rook {
                if playerToGenerate == .white { // remove black's ability to castle the direction we took their rook
                    if destSquare == .a8 {
                        newCastlingRights = self.castlingRights.filter { $0 != .q }
                    } else if destSquare == .h8 {
                        newCastlingRights = self.castlingRights.filter { $0 != .k }
                    } else {
                        newCastlingRights = self.castlingRights
                    }
                } else { // remove white's ability to castle the direction we took their rook
                    if destSquare == .a1 {
                        newCastlingRights = self.castlingRights.filter { $0 != .Q }
                    } else if destSquare == .h1 {
                        newCastlingRights = self.castlingRights.filter { $0 != .K }
                    } else {
                        newCastlingRights = self.castlingRights
                    }
                }
            } else {
                newCastlingRights = self.castlingRights
            }
            
            let resultingBoardState: BoardState
            let isCastling: Bool
            
            if self.playerToMove == .white {
                newCastlingRights = newCastlingRights.filter { $0 != .K && $0 != .Q }
                
                let newRookBoard: Bitboard
                if originSquare == .e1 && destSquare == .g1 {
                    newRookBoard = (self.whiteRooks & ~Bitboard.squareMask(.h1)) | Bitboard.squareMask(.f1)
                    isCastling = true
                } else if originSquare == .e1 && destSquare == .c1 {
                    newRookBoard = (self.whiteRooks & ~Bitboard.squareMask(.a1)) | Bitboard.squareMask(.d1)
                    isCastling = true
                } else {
                    newRookBoard = self.whiteRooks
                    isCastling = false
                }
                
                resultingBoardState = BoardState(
                    whitePawns: self.whitePawns,
                    whiteKnights: self.whiteKnights,
                    whiteBishops: self.whiteBishops,
                    whiteRooks: newRookBoard,
                    whiteQueens: self.whiteQueens,
                    whiteKing: destbb,
                    blackPawns: self.blackPawns & ~destbb,
                    blackKnights: self.blackKnights & ~destbb,
                    blackBishops: self.blackBishops & ~destbb,
                    blackRooks: self.blackRooks & ~destbb,
                    blackQueens: self.blackQueens & ~destbb,
                    blackKing: self.blackKing & ~destbb,
                    plyNumber: self.plyNumber+1,
                    playerToMove: self.playerToMove.opposite(),
                    enpassantTargetSqauare: Bitboard.empty,
                    castlingRights: newCastlingRights
                )
            } else {
                newCastlingRights = newCastlingRights.filter { $0 != .k && $0 != .q }
                
                let newRookBoard: Bitboard
                if originSquare == .e8 && destSquare == .g8 {
                    newRookBoard = (self.blackRooks & ~Bitboard.squareMask(.h8)) | Bitboard.squareMask(.f8)
                    isCastling = true
                } else if originSquare == .e8 && destSquare == .c8 {
                    newRookBoard = (self.blackRooks & ~Bitboard.squareMask(.a8)) | Bitboard.squareMask(.d8)
                    isCastling = true
                } else {
                    newRookBoard = self.blackRooks
                    isCastling = false
                }
                resultingBoardState = BoardState(
                    whitePawns: self.whitePawns & ~destbb,
                    whiteKnights: self.whiteKnights & ~destbb,
                    whiteBishops: self.whiteBishops & ~destbb,
                    whiteRooks: self.whiteRooks & ~destbb,
                    whiteQueens: self.whiteQueens & ~destbb,
                    whiteKing: self.whiteKing & ~destbb,
                    blackPawns: self.blackPawns,
                    blackKnights: self.blackKnights,
                    blackBishops: self.blackBishops,
                    blackRooks: newRookBoard,
                    blackQueens: self.blackQueens,
                    blackKing: destbb,
                    plyNumber: self.plyNumber+1,
                    playerToMove: self.playerToMove.opposite(),
                    enpassantTargetSqauare: Bitboard.empty,
                    castlingRights: newCastlingRights
                )
            }
            
            // 3. Filter out illegal moves (e.g., moves that get/leave king in check)
            guard !resultingBoardState.isKingInCheck(self.playerToMove) else {
                continue
            }
            
            let sanMove = self.generateSAN(
                from: originSquare,
                to: destSquare,
                piece: .king,
                capturedPiece: capturedPiece,
                promotion: nil,
                isCastling: isCastling,
                resultingBoardState: resultingBoardState
            )
            
            let move = Move(
                from: originSquare,
                to: destSquare,
                piece: .king,
                capturedPiece: capturedPiece,
                promotion: nil,
                resultingBoardState: resultingBoardState,
                ply: self.plyNumber+1,
                color: self.playerToMove.opposite(),
                isCastling: isCastling,
                san: sanMove
            )
            
            output.append(move)
        }
        
        // 4. Return resulting legal [Move] list
        return output
    }
    
    // MARK: - generateSAN
    private func generateSAN(
        from originSquare: Square,
        to destSquare: Square,
        piece: PieceType,
        capturedPiece: PieceType?,
        promotion: PieceType?,
        isCastling: Bool,
        resultingBoardState: BoardState
    ) -> String {
        
        var output: String = ""
        
        // --- Handle Castling ---
        if isCastling && piece == .king {
            output = Bitboard.file(6)!.hasPiece(on: destSquare) ? "O-O" : "O-O-O"
        } else { // Get the piece, disambiguation, capturing, destination, and promotion together
            
            // --- only file for pawns ---
            if piece != .pawn {
                output += "\(piece.toLetter())"
            }
            
            // --- disambiguation (if applicable) ---
            let originbb = Bitboard.squareMask(originSquare)
            let destbb = Bitboard.squareMask(destSquare)
            
            let mask: Bitboard
            switch piece {
            case .pawn:
                let others = playerToMove == .white ? self.whitePawns : self.blackPawns
                mask = (playerToMove == .white ? destbb.seShift() | destbb.swShift() : destbb.neShift() | destbb.nwShift()) & others
            case .knight:
                let others = playerToMove == .white ? self.whiteKnights : self.blackKnights
                mask = Square.generateKnightMoves(destSquare) & others
            case .bishop:
                let others = playerToMove == .white ? self.whiteBishops : self.blackBishops
                mask = Square.slidingBishopAttacks(at: destSquare, blockers: self.allPieces) & others
            case .rook:
                let others = playerToMove == .white ? self.whiteRooks : self.blackRooks
                mask = Square.slidingRookAttacks(at: destSquare, blockers: self.allPieces) & others
            case .queen:
                let others = playerToMove == .white ? self.whiteQueens : self.blackQueens
                mask = Square.slidingQueenAttacks(at: destSquare, blockers: self.allPieces) & others
            case .king:
                mask = .empty // this makes no sense but like needs to be exhaustive ig
            }
            
            if mask.nonzeroBitCount == 2 { // one disambiguation needed
                let fileChar = ("\(originSquare)".first!)
                let rankChar = ("\(originSquare)".last!)
                
                let fileIndex = "abcdefgh".firstIndex(of: fileChar)!
                let file = Int("abcdefgh".distance(from: "abcefgh".startIndex, to: fileIndex)) + 1 // 1...8
                
                if (Bitboard.file(file)! & mask) == mask {
                    output += String(fileChar)
                } else {
                    output += String(rankChar)
                }
            } else if mask.nonzeroBitCount >= 3 { // two disambiguation needed
                output += "\(originSquare)"
            } else { // disambiguation not needed
            }
            
            // --- whether we are capturing ---
            if capturedPiece != nil {
                if piece == .pawn {
                    output += String("\(originSquare)".first!)
                }
                output += "x"
            }
            // --- destination square ---
            output += "\(destSquare)"
            
            // --- e.p. (if applicable) ---
            if piece == .pawn && destbb == self.enpassantTargetSquare {
                output += " e.p."
            }
            
            // --- promotion (if applicable) ---
            if let p = promotion {
                output += "=\(p.toLetter())"
            }
        }
        
        // --- handle whether check/checkmate ---
        
        if resultingBoardState.isKingInCheck() {
            if resultingBoardState.generateAllLegalMoves().count == 0 {
                output += "#"
            } else {
                output += "+"
            }
        }
        
        return output
    }
}
