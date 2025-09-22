//
//  BoardState.swift
//  zChessKit
//
//  Created by Ben Zobrist on 9/15/25.
//

import zBitboard

struct BoardState: Codable {
    // MARK: - Immutable Bitboards
    let whitePawns: Bitboard
    let whiteKnights: Bitboard
    let whiteBishops: Bitboard
    let whiteRooks: Bitboard
    let whiteQueens: Bitboard
    let whiteKing: Bitboard
    
    let blackPawns: Bitboard
    let blackKnights: Bitboard
    let blackBishops: Bitboard
    let blackRooks: Bitboard
    let blackQueens: Bitboard
    let blackKing: Bitboard
    
    // MARK: - Metadata
    let plyNumber: Int
    let playerToMove: PlayerColor
    let enpassantTargetSquare: Bitboard
    
    let castlingRights: [CastlingRights]
    
    // MARK: - Derived Bitboards
    var whitePieces: Bitboard {
        whitePawns | whiteKnights | whiteBishops | whiteRooks | whiteQueens | whiteKing
    }
    
    var blackPieces: Bitboard {
        blackPawns | blackKnights | blackBishops | blackRooks | blackQueens | blackKing
    }
    
    var allPieces: Bitboard {
        whitePieces | blackPieces
    }
    
    //MARK: - Init functions
    
    init(whitePawns: Bitboard, whiteKnights: Bitboard, whiteBishops: Bitboard, whiteRooks: Bitboard, whiteQueens: Bitboard, whiteKing: Bitboard, blackPawns: Bitboard, blackKnights: Bitboard, blackBishops: Bitboard, blackRooks: Bitboard, blackQueens: Bitboard, blackKing: Bitboard, plyNumber: Int, playerToMove: PlayerColor, enpassantTargetSqauare: Bitboard, castlingRights: [CastlingRights]) {
        self.whitePawns = whitePawns
        self.whiteKnights = whiteKnights
        self.whiteBishops = whiteBishops
        self.whiteRooks = whiteRooks
        self.whiteQueens = whiteQueens
        self.whiteKing = whiteKing
        self.blackPawns = blackPawns
        self.blackKnights = blackKnights
        self.blackBishops = blackBishops
        self.blackRooks = blackRooks
        self.blackQueens = blackQueens
        self.blackKing = blackKing
        self.plyNumber = plyNumber
        self.playerToMove = playerToMove
        self.enpassantTargetSquare = enpassantTargetSqauare
        self.castlingRights = castlingRights
    }
    
    init(FEN: String) {
        var whitePawns: Bitboard = .empty
        var whiteKnights: Bitboard = .empty
        var whiteBishops: Bitboard = .empty
        var whiteRooks: Bitboard = .empty
        var whiteQueens: Bitboard = .empty
        var whiteKing: Bitboard = .empty
        var blackPawns: Bitboard = .empty
        var blackKnights: Bitboard = .empty
        var blackBishops: Bitboard = .empty
        var blackRooks: Bitboard = .empty
        var blackQueens: Bitboard = .empty
        var blackKing: Bitboard = .empty
        
        let lexer = Lexer()
        let tokens = lexer.run(input: FEN)
        
        var idx = 0
        var rank = 7
        while rank >= 0 {
            var file = 0
            let current = tokens[idx]
            idx += 1
            
            if current.tokenType == .FORWARD_SLASH {
                continue
            }
            
            while file <= 7 {
                if current.tokenType == .SYMBOL {
                    for currPiece in current.value {
                        let sq = Square(rawValue: (rank*8) + file)!
                        if currPiece == "K" {
                            whiteKing |= Bitboard.squareMask(sq)
                        } else if currPiece == "Q" {
                            whiteQueens |= Bitboard.squareMask(sq)
                        } else if currPiece == "R" {
                            whiteRooks |= Bitboard.squareMask(sq)
                        } else if currPiece == "B" {
                            whiteBishops |= Bitboard.squareMask(sq)
                        } else if currPiece == "N" {
                            whiteKnights |= Bitboard.squareMask(sq)
                        } else if currPiece == "P" {
                            whitePawns |= Bitboard.squareMask(sq)
                        } else if currPiece == "k" {
                            blackKing |= Bitboard.squareMask(sq)
                        } else if currPiece == "q" {
                            blackQueens |= Bitboard.squareMask(sq)
                        } else if currPiece == "r" {
                            blackRooks |= Bitboard.squareMask(sq)
                        } else if currPiece == "b" {
                            blackBishops |= Bitboard.squareMask(sq)
                        } else if currPiece == "n" {
                            blackKnights |= Bitboard.squareMask(sq)
                        } else if currPiece == "p" {
                            blackPawns |= Bitboard.squareMask(sq)
                        } else if currPiece.isNumber {
                            let emptySquares = Int("\(currPiece)")! - 1
                            file += emptySquares
                        }
                        file += 1
                    }
                } else if current.tokenType == .INTEGER {
                    let emptySquares = Int(current.value)!
                    file += emptySquares
                }
            }
            
            rank -= 1
        }
        
        self.whitePawns = whitePawns
        self.whiteKnights = whiteKnights
        self.whiteBishops = whiteBishops
        self.whiteRooks = whiteRooks
        self.whiteQueens = whiteQueens
        self.whiteKing = whiteKing
        self.blackPawns = blackPawns
        self.blackKnights = blackKnights
        self.blackBishops = blackBishops
        self.blackRooks = blackRooks
        self.blackQueens = blackQueens
        self.blackKing = blackKing
        
        self.playerToMove = tokens[idx].value == "w" ? .white : .black
        idx += 1
        
        let castling = tokens[idx].value
        var castlingRights: [CastlingRights] = []
        if castling.contains("K") {
            castlingRights.append(.K)
        }
        if castling.contains("Q") {
            castlingRights.append(.Q)
        }
        if castling.contains("k") {
            castlingRights.append(.k)
        }
        if castling.contains("q") {
            castlingRights.append(.q)
        }
        self.castlingRights = castlingRights
        idx += 1
        
        if tokens[idx].value == "-" {
            self.enpassantTargetSquare = .empty
        } else {
            let rank: Int = Int(tokens[idx].value.unicodeScalars.first!.value - "a".unicodeScalars.first!.value)
            let file = Int(tokens[idx].value.unicodeScalars.last!.value - "1".unicodeScalars.first!.value)
            
            let sq = Square(rawValue: (rank * 8) + file)!
            self.enpassantTargetSquare = Bitboard.squareMask(sq)
        }
        idx += 1
        
        // MARK: Halfmove Clock isn't something I do anything with at the moment
        
        idx += 1
        var plyNumber = (Int(tokens[idx].value)! - 1) * 2
        if self.playerToMove == .black {
            plyNumber += 1
        }
        self.plyNumber = plyNumber
    }
    
    // MARK: - Piece Move Generators (Pseudo-Legal)
    
    private func generateWhitePawnMoves() -> [(from: Bitboard,  to: Bitboard)] {
        // - Forward 1
        // - Forward 2 (from rank 2)
        // - Captures (left/right)
        // - En passant
        // TODO: Implement Pawn Moves
        return []
    }
    
    private func generateBlackPawnMoves() -> [(from: Bitboard,  to: Bitboard)] {
        // - Forward 1
        // - Forward 2 (from rank 7)
        // - Captures (left/right)
        // - En passant
        // TODO: Implement Pawn Moves
        return []
    }
    
    private func generateWhiteKnightMoves() -> [(from: Bitboard,  to: Bitboard)] {
        // - All L-shaped jumps (8 directions)
        // - Avoid friendly fire
        
        var output: [(from: Bitboard,  to: Bitboard)] = []
                
        var remainingKnights = self.whiteKnights
        while remainingKnights.nonzeroBitCount > 0 {
            guard let tmp = remainingKnights.popLSB() else { break }
            guard let originSquare = Square(rawValue: tmp.0) else { break }
            remainingKnights = tmp.1
            let origin: Bitboard = Bitboard.squareMask(originSquare)
            
            var total = Square.generateKnightMoves(originSquare, blockers: self.whitePieces)
            
            while total != Bitboard.empty {
                guard let curr = total.popLSB() else { break }
                total = curr.1
                output.append((origin, Bitboard.squareMask(Square(rawValue: curr.0)!)))
            }
        }
        
        return output
    }
    
    private func generateBlackKnightMoves() -> [(from: Bitboard,  to: Bitboard)] {
        // - All L-shaped jumps (8 directions)
        // - Avoid friendly fire
        
        var output: [(from: Bitboard,  to: Bitboard)] = []
        
        var remainingKnights = self.blackKnights
        while remainingKnights.nonzeroBitCount > 0 {
            guard let tmp = remainingKnights.popLSB() else { break }
            guard let originSquare = Square(rawValue: tmp.0) else { break }
            remainingKnights = tmp.1
            let origin: Bitboard = Bitboard.squareMask(originSquare)
            
            var total = Square.generateKnightMoves(originSquare, blockers: self.blackPieces)
            
            while total != Bitboard.empty {
                guard let curr = total.popLSB() else { break }
                total = curr.1
                output.append((origin, Bitboard.squareMask(Square(rawValue: curr.0)!)))
            }
            
        }
        
        return output
    }
    
    private func generateWhiteBishopMoves() -> [(from: Bitboard,  to: Bitboard)] {
        // - Slide diagonally until obstruction
        // - Capture enemies
        // - Block at first obstruction
        var output: [(from: Bitboard,  to: Bitboard)] = []
        var tmp = self.whiteBishops
        while tmp != Bitboard.empty {
            guard let curr = tmp.popLSB() else { break }
            tmp = curr.1
            let sq = Square(rawValue: curr.0)!
            
            let moves = self.generateDiagonalMoves(for: sq, friendlyPieces: self.whitePieces)
            
            for target in moves {
                if target != Bitboard.empty {
                    output.append((from: Bitboard.squareMask(sq), to: target))
                }
            }
            
        }
        
        return output
    }
    
    private func generateBlackBishopMoves() -> [(from: Bitboard,  to: Bitboard)] {
        // - Slide diagonally until obstruction
        // - Capture enemies
        // - Block at first obstruction
        var output: [(from: Bitboard,  to: Bitboard)] = []
        var tmp = self.blackBishops
        while tmp != Bitboard.empty {
            guard let curr = tmp.popLSB() else { break }
            tmp = curr.1
            let sq = Square(rawValue: curr.0)!
            
            let moves = self.generateDiagonalMoves(for: sq, friendlyPieces: self.blackPieces)
            
            for target in moves {
                if target != Bitboard.empty {
                    output.append((from: Bitboard.squareMask(sq), to: target))
                }
            }
            
        }
        
        return output
    }
    
    private func generateWhiteRookMoves() -> [(from: Bitboard,  to: Bitboard)] {
        // - Slide vertically and horizontally
        // - Stop at obstructions or captures
        var output: [(from: Bitboard,  to: Bitboard)] = []
        var tmp = self.whiteRooks
        while tmp != Bitboard.empty {
            guard let curr = tmp.popLSB() else { break }
            tmp = curr.1
            let sq = Square(rawValue: curr.0)!
            
            let moves = self.generateOrthogonalMoves(for: sq, friendlyPieces: self.whitePieces)
            
            for target in moves {
                if target != Bitboard.empty {
                    output.append((from: Bitboard.squareMask(sq), to: target))
                }
            }
            
        }
        
        return output
    }
    
    private func generateBlackRookMoves() -> [(from: Bitboard,  to: Bitboard)] {
        // - Slide vertically and horizontally
        // - Stop at obstructions or captures
        var output: [(from: Bitboard,  to: Bitboard)] = []
        var tmp = self.blackRooks
        while tmp != Bitboard.empty {
            guard let curr = tmp.popLSB() else { break }
            tmp = curr.1
            let sq = Square(rawValue: curr.0)!
            
            let moves = self.generateOrthogonalMoves(for: sq, friendlyPieces: self.blackPieces)
            
            for target in moves {
                if target != Bitboard.empty {
                    output.append((from: Bitboard.squareMask(sq), to: target))
                }
            }
            
        }
        
        return output
    }
    
    private func generateWhiteQueenMoves() -> [(from: Bitboard,  to: Bitboard)] {
        // - Combine rook + bishop movement
        var output: [(from: Bitboard,  to: Bitboard)] = []
        var tmp = self.whiteQueens
        while tmp != Bitboard.empty {
            guard let curr = tmp.popLSB() else { break }
            tmp = curr.1
            let sq = Square(rawValue: curr.0)!
            
            let dMoves = self.generateDiagonalMoves(for: sq, friendlyPieces: self.whitePieces)
            let oMoves = self.generateOrthogonalMoves(for: sq, friendlyPieces: self.whitePieces)
            for target in dMoves {
                if target != Bitboard.empty {
                    output.append((from: Bitboard.squareMask(sq), to: target))
                }
            }
            for target in oMoves {
                if target != Bitboard.empty {
                    output.append((from: Bitboard.squareMask(sq), to: target))
                }
            }
        }
        
        return output
    }
    
    private func generateBlackQueenMoves() -> [(from: Bitboard,  to: Bitboard)] {
        // - Combine rook + bishop movement
        var output: [(from: Bitboard,  to: Bitboard)] = []
        var tmp = self.blackQueens
        while tmp != Bitboard.empty {
            guard let curr = tmp.popLSB() else { break }
            tmp = curr.1
            let sq = Square(rawValue: curr.0)!
            
            let dMoves = self.generateDiagonalMoves(for: sq, friendlyPieces: self.blackPieces)
            let oMoves = self.generateOrthogonalMoves(for: sq, friendlyPieces: self.blackPieces)
            for target in dMoves {
                if target != Bitboard.empty {
                    output.append((from: Bitboard.squareMask(sq), to: target))
                }
            }
            for target in oMoves {
                if target != Bitboard.empty {
                    output.append((from: Bitboard.squareMask(sq), to: target))
                }
            }
        }
        
        return output
    }
    
    private func generateWhiteKingMoves() -> [(from: Bitboard,  to: Bitboard)] {
        // - Move one square in any direction
        // - Castling (if legal)
        guard let tmp = self.whiteKing.popLSB() else { return [] }
        guard let originSquare = Square(rawValue: tmp.0) else { return [] }
        
        let origin: Bitboard = Bitboard.squareMask(originSquare)
            
        // generate cardinal direction moves
        var total = (
            origin.nShift() | origin.neShift() |
            origin.eShift() | origin.seShift() |
            origin.sShift() | origin.swShift() |
            origin.wShift() | origin.nwShift()
        ) & ~self.whitePieces
        
        // add castling moves
        if self.castlingRights.contains(.K) && originSquare == .e1 && !self.isKingInCheck(.white) {
            if !self.allPieces.hasPiece(on: .f1) && !self.allPieces.hasPiece(on: .g1) && self.whiteRooks.hasPiece(on: .h1) {
                if !self.isKingInCheck(.white, kingLocation: Bitboard.squareMask(.f1)) {
                    total |= Bitboard.squareMask(.g1)
                }
            }
        }
        if self.castlingRights.contains(.Q) && originSquare == .e1 && !self.isKingInCheck(.white) {
            if !self.allPieces.hasPiece(on: .d1) && !self.allPieces.hasPiece(on: .c1) && !self.allPieces.hasPiece(on: .b1) && self.whiteRooks.hasPiece(on: .a1) {
                if !self.isKingInCheck(.white, kingLocation: Bitboard.squareMask(.d1)) {
                    total |= Bitboard.squareMask(.c1)
                }
            }
        }
        
        // return possible moves
        var output: [(from: Bitboard,  to: Bitboard)] = []
        while total != Bitboard.empty {
            guard let curr = total.popLSB() else { break }
            total = curr.1
            output.append((origin, Bitboard.squareMask(Square(rawValue: curr.0)!)))
        }
        
        return output
    }
    
    private func generateBlackKingMoves() -> [(from: Bitboard,  to: Bitboard)] {
        // - Move one square in any direction
        // - Castling (if legal)
        guard let tmp = self.blackKing.popLSB() else { return [] }
        guard let originSquare = Square(rawValue: tmp.0) else { return [] }
        
        let origin: Bitboard = Bitboard.squareMask(originSquare)
        
        // generate cardinal direction moves
        var total = (
            origin.nShift() | origin.neShift() |
            origin.eShift() | origin.seShift() |
            origin.sShift() | origin.swShift() |
            origin.wShift() | origin.nwShift()
        ) & ~self.blackPieces
        
        // add castling moves
        if self.castlingRights.contains(.k) && originSquare == .e8 && !self.isKingInCheck(.black) {
            if !self.allPieces.hasPiece(on: .f8) && !self.allPieces.hasPiece(on: .g8) && self.blackRooks.hasPiece(on: .h8) {
                if !self.isKingInCheck(.white, kingLocation: Bitboard.squareMask(.f8)) {
                    total |= Bitboard.squareMask(.g8)
                }
            }
        }
        if self.castlingRights.contains(.q) && originSquare == .e8 && !self.isKingInCheck(.black) {
            if !self.allPieces.hasPiece(on: .d8) && !self.allPieces.hasPiece(on: .c8) && !self.allPieces.hasPiece(on: .b8) && self.blackRooks.hasPiece(on: .a8) {
                if !self.isKingInCheck(.white, kingLocation: Bitboard.squareMask(.d8)) {
                    total |= Bitboard.squareMask(.c8)
                }
            }
        }
        
        // return possible moves
        var output: [(from: Bitboard,  to: Bitboard)] = []
        while total != Bitboard.empty {
            guard let curr = total.popLSB() else { break }
            total = curr.1
            output.append((origin, Bitboard.squareMask(Square(rawValue: curr.0)!)))
        }
        
        return output
    }
    
    private func generateDiagonalMoves(for sq: Square, friendlyPieces: Bitboard) -> [Bitboard] {
        var output: [Bitboard] = []
        
        let relevantOccupancy = bishopMask(forSquare: sq)           // squares that can block this bishop
        let blockers = self.allPieces & relevantOccupancy           // actual blockers from the board
        let magicEntry = MagicTables.bishop[sq.rawValue]            // struct Magic for this square
        let idx = Int((blockers &* magicEntry.magic) >> UInt64(magicEntry.shift))
        let attacksBB = magicEntry.attacks[idx]                     // <-- one bitboard, not an array
        
        // Now filter out friendly pieces
        var combined = attacksBB & ~friendlyPieces
        
        while combined != 0 {
            let tmp = combined.popLSB()!
            combined = tmp.newBitboard
            output.append(Bitboard.squareMask(Square(rawValue: tmp.index)!))
        }
        
        return output
    }
    
    private func generateOrthogonalMoves(for sq: Square, friendlyPieces: Bitboard) -> [Bitboard] {
        var output: [Bitboard] = []
        
        let relevantOccupancy = rookMask(forSquare: sq)             // squares that can block this bishop
        let blockers = self.allPieces & relevantOccupancy           // actual blockers from the board
        let magicEntry = MagicTables.rook[sq.rawValue]              // struct Magic for this square
        let idx = Int((blockers &* magicEntry.magic) >> UInt64(magicEntry.shift))
        let attacksBB = magicEntry.attacks[idx]                     // <-- one bitboard, not an array
        
        // Now filter out friendly pieces
        var combined = attacksBB & ~friendlyPieces
        
        while combined != 0 {
            let tmp = combined.popLSB()!
            combined = tmp.newBitboard
            output.append(Bitboard.squareMask(Square(rawValue: tmp.index)!))
        }
        
        return output
    }
    
    private func whatPieceIsOn(_ square: Square) -> PieceType? {
        if (self.blackPawns | self.whitePawns).hasPiece(on: square) {
            return .pawn
        }
        if (self.blackKnights | self.whiteKnights).hasPiece(on: square) {
            return .knight
        }
        if (self.blackBishops | self.whiteBishops).hasPiece(on: square) {
            return .bishop
        }
        if (self.blackRooks | self.whiteRooks).hasPiece(on: square) {
            return .rook
        }
        if (self.blackQueens | self.whiteQueens).hasPiece(on: square) {
            return .queen
        }
        if (self.blackKing | self.whiteKing).hasPiece(on: square) {
            return .king
        }
        
        return nil
    }
    
    // MARK: - Combined Move Generator (Entry Point)
    
    func generateAllLegalMoves(_ player: PlayerColor? = nil) -> [Move] {
                
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
        // TODO: Implement pawn moves
//        for pawnMove in pawnMoves {
//            let originSquare = Square(rawValue: pawnMove.from.popLSB()!.0)!
//            let destSquare = Square(rawValue: pawnMove.to.popLSB()!.0)!
//            let capturedPiece: PieceType? = self.whatPieceIsOn(destSquare)
//            
//            let possiblePromotions: [PieceType?] = (
//                Bitboard.squareMask(destSquare) & (Bitboard.rank1 | Bitboard.rank8) > 0 ?
//                [.knight, .bishop, .rook, .queen] : [nil]
//            )
//            
//            for promotion in possiblePromotions {
//                let resultingBoardState = BoardState(
//                    whitePawns: <#T##Bitboard#>,
//                    whiteKnights: <#T##Bitboard#>,
//                    whiteBishops: <#T##Bitboard#>,
//                    whiteRooks: <#T##Bitboard#>,
//                    whiteQueens: <#T##Bitboard#>,
//                    whiteKing: <#T##Bitboard#>,
//                    blackPawns: <#T##Bitboard#>,
//                    blackKnights: <#T##Bitboard#>,
//                    blackBishops: <#T##Bitboard#>,
//                    blackRooks: <#T##Bitboard#>,
//                    blackQueens: <#T##Bitboard#>,
//                    blackKing: <#T##Bitboard#>,
//                    plyNumber: self.plyNumber+1,
//                    playerToMove: self.playerToMove.opposite(),
//                    enpassantTargetSquare: <#T##Bitboard#>,
//                    isCheck: <#T##Bool#>,
//                    castlingRights: self.castlingRights
//                )
//                
//                let move = Move(
//                    from: originSquare,
//                    to: destSquare,
//                    piece: .pawn,
//                    capturedPiece: capturedPiece,
//                    promotion: promotion,
//                    resultingBoardState: resultingBoardState,
//                    ply: self.plyNumber+1,
//                    color: self.playerToMove.opposite()
//                )
//            }
//        }
        
        for move in knightMoves {
            let originSquare = Square(rawValue: move.from.popLSB()!.0)!
            let originbb = Bitboard.squareMask(originSquare)
            let destSquare = Square(rawValue: move.to.popLSB()!.0)!
            let destbb = Bitboard.squareMask(destSquare)
            
            let capturedPiece: PieceType? = self.whatPieceIsOn(destSquare)

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
                    castlingRights: self.castlingRights
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
                    castlingRights: self.castlingRights
                )
            }
            
            // 3. Filter out illegal moves (e.g., moves that get/leave king in check)
            guard !resultingBoardState.isKingInCheck(self.playerToMove) else {
                continue
            }

            let move = Move(
                from: originSquare,
                to: destSquare,
                piece: .knight,
                capturedPiece: capturedPiece,
                promotion: nil,
                resultingBoardState: resultingBoardState,
                ply: self.plyNumber+1,
                color: self.playerToMove.opposite()
            )
            
            output.append(move)
        }
        
        for move in bishopMoves {
            let originSquare = Square(rawValue: move.from.popLSB()!.0)!
            let originbb = Bitboard.squareMask(originSquare)
            let destSquare = Square(rawValue: move.to.popLSB()!.0)!
            let destbb = Bitboard.squareMask(destSquare)
            
            let capturedPiece: PieceType? = self.whatPieceIsOn(destSquare)
            
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
                    castlingRights: self.castlingRights
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
                    castlingRights: self.castlingRights
                )
            }
            
            // 3. Filter out illegal moves (e.g., moves that get/leave king in check)
            guard !resultingBoardState.isKingInCheck(self.playerToMove) else {
                continue
            }
            
            let move = Move(
                from: originSquare,
                to: destSquare,
                piece: .bishop,
                capturedPiece: capturedPiece,
                promotion: nil,
                resultingBoardState: resultingBoardState,
                ply: self.plyNumber+1,
                color: self.playerToMove.opposite()
            )
            
            output.append(move)
        }
        
        for move in rookMoves {
            let originSquare = Square(rawValue: move.from.popLSB()!.0)!
            let originbb = Bitboard.squareMask(originSquare)
            let destSquare = Square(rawValue: move.to.popLSB()!.0)!
            let destbb = Bitboard.squareMask(destSquare)
            
            let capturedPiece: PieceType? = self.whatPieceIsOn(destSquare)
                        
            let resultingBoardState: BoardState
            if self.playerToMove == .white {
                let newCastlingRights: [CastlingRights]
                if originSquare == .a1 {
                    newCastlingRights = self.castlingRights.filter { $0 != .Q }
                } else if originSquare == .h1 {
                    newCastlingRights = self.castlingRights.filter { $0 != .K }
                } else {
                    newCastlingRights = self.castlingRights
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
                let newCastlingRights: [CastlingRights]
                if originSquare == .a8 {
                    newCastlingRights = self.castlingRights.filter { $0 != .q }
                } else if originSquare == .h8 {
                    newCastlingRights = self.castlingRights.filter { $0 != .k }
                } else {
                    newCastlingRights = self.castlingRights
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
            
            let move = Move(
                from: originSquare,
                to: destSquare,
                piece: .rook,
                capturedPiece: capturedPiece,
                promotion: nil,
                resultingBoardState: resultingBoardState,
                ply: self.plyNumber+1,
                color: self.playerToMove.opposite()
            )
            
            output.append(move)
        }
        
        for move in queenMoves {
            let originSquare = Square(rawValue: move.from.popLSB()!.0)!
            let originbb = Bitboard.squareMask(originSquare)
            let destSquare = Square(rawValue: move.to.popLSB()!.0)!
            let destbb = Bitboard.squareMask(destSquare)
            
            let capturedPiece: PieceType? = self.whatPieceIsOn(destSquare)
            
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
                    castlingRights: self.castlingRights
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
                    castlingRights: self.castlingRights
                )
            }
            
            // 3. Filter out illegal moves (e.g., moves that get/leave king in check)
            guard !resultingBoardState.isKingInCheck(self.playerToMove) else {
                continue
            }
            
            let move = Move(
                from: originSquare,
                to: destSquare,
                piece: .queen,
                capturedPiece: capturedPiece,
                promotion: nil,
                resultingBoardState: resultingBoardState,
                ply: self.plyNumber+1,
                color: self.playerToMove.opposite()
            )
            
            output.append(move)
        }
                
        for move in kingMoves {
            let originSquare = Square(rawValue: move.from.popLSB()!.0)!
//            let originbb = Bitboard.squareMask(originSquare)
            let destSquare = Square(rawValue: move.to.popLSB()!.0)!
            let destbb = Bitboard.squareMask(destSquare)
            
            let capturedPiece: PieceType? = self.whatPieceIsOn(destSquare)
                        
            let resultingBoardState: BoardState
            if self.playerToMove == .white {
                let newCastlingRights = self.castlingRights.filter { $0 != .K && $0 != .Q }
                
                let newRookBoard: Bitboard
                if originSquare == .e1 && destSquare == .g1 {
                    newRookBoard = (self.whiteRooks & ~Bitboard.squareMask(.h1)) | Bitboard.squareMask(.f1)
                } else if originSquare == .e1 && destSquare == .c1 {
                    newRookBoard = (self.whiteRooks & ~Bitboard.squareMask(.a1)) | Bitboard.squareMask(.d1)
                } else {
                    newRookBoard = self.whiteRooks
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
                let newCastlingRights = self.castlingRights.filter { $0 != .k && $0 != .q }
                
                let newRookBoard: Bitboard
                if originSquare == .e8 && destSquare == .g8 {
                    newRookBoard = (self.blackRooks & ~Bitboard.squareMask(.h8)) | Bitboard.squareMask(.f8)
                } else if originSquare == .e8 && destSquare == .c8 {
                    newRookBoard = (self.blackRooks & ~Bitboard.squareMask(.a8)) | Bitboard.squareMask(.d8)
                } else {
                    newRookBoard = self.blackRooks
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
            
            let move = Move(
                from: originSquare,
                to: destSquare,
                piece: .king,
                capturedPiece: capturedPiece,
                promotion: nil,
                resultingBoardState: resultingBoardState,
                ply: self.plyNumber+1,
                color: self.playerToMove.opposite()
            )
            
            output.append(move)
        }
        
        // 4. Return resulting legal [Move] list
        return output
    }
    
    
    // MARK: - isKingInCheck(_ color: PlayerColor? = nil) -> Bool
    
    func isKingInCheck(_ color: PlayerColor? = nil, kingLocation: Bitboard? = nil) -> Bool {
        let playerToCheck = color ?? self.playerToMove
        
        if playerToCheck == .white { // see if black pieces attack white king
            let kingLocation = kingLocation ?? self.whiteKing
            for move in self.generateBlackPawnMoves() {
                if kingLocation & move.to > 0 {
                    return true
                }
            }
            
            for move in self.generateBlackKnightMoves() {
                if kingLocation & move.to > 0 {
                    return true
                }
            }
            
            for move in self.generateBlackBishopMoves() {
                if kingLocation & move.to > 0 {
                    return true
                }
            }
            
            for move in self.generateBlackRookMoves() {
                if kingLocation & move.to > 0 {
                    return true
                }
            }
            
            for move in self.generateBlackQueenMoves() {
                if kingLocation & move.to > 0 {
                    return true
                }
            }
            
            // It's weird but will be used to prevent this move from occurring
            // TODO: This has the danger of infinite loops, so it should be reworked
//            for move in self.generateBlackKingMoves() {
//                if kingLocation & move.to > 0 {
//                    return true
//                }
//            }
        } else if playerToCheck == .black { // see if white pieces attack black king
            let kingLocation = kingLocation ?? self.blackKing
            for move in self.generateWhitePawnMoves() {
                if kingLocation & move.to > 0 {
                    return true
                }
            }
            
            for move in self.generateWhiteKnightMoves() {
                if kingLocation & move.to > 0 {
                    return true
                }
            }
            
            for move in self.generateWhiteBishopMoves() {
                if kingLocation & move.to > 0 {
                    return true
                }
            }
            
            for move in self.generateWhiteRookMoves() {
                if kingLocation & move.to > 0 {
                    return true
                }
            }
            
            for move in self.generateWhiteQueenMoves() {
                if kingLocation & move.to > 0 {
                    return true
                }
            }
            
            // It's weird but will be used to prevent this move from occurring
            // TODO: This has the danger of infinite loops, so it should be reworked
//            for move in self.generateWhiteKingMoves() {
//                if kingLocation & move.to > 0 {
//                    return true
//                }
//            }
        }
        
        return false
    }
    
    // MARK: - SingleMoveGenerator
    
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
    
    // MARK: - Pretty String
    
    func boardString() -> String {
        // mapping from square -> piece symbol
        var board = Array(repeating: ".", count: 64)
        
        func placePieces(_ bitboard: UInt64, symbol: String) {
            var bb = bitboard
            while bb != 0 {
                let sq = bb.trailingZeroBitCount
                board[sq] = symbol
                bb &= bb - 1 // clear lowest set bit
            }
        }
        
        // Place white pieces
        placePieces(self.whitePawns, symbol: "♙")
        placePieces(self.whiteKnights, symbol: "♘")
        placePieces(self.whiteBishops, symbol: "♗")
        placePieces(self.whiteRooks, symbol: "♖")
        placePieces(self.whiteQueens, symbol: "♕")
        placePieces(self.whiteKing, symbol: "♔")
        
        // Place black pieces
        placePieces(self.blackPawns, symbol: "♟")
        placePieces(self.blackKnights, symbol: "♞")
        placePieces(self.blackBishops, symbol: "♝")
        placePieces(self.blackRooks, symbol: "♜")
        placePieces(self.blackQueens, symbol: "♛")
        placePieces(self.blackKing, symbol: "♚")
        
        // Build string
        var result = ""
        for rank in (0..<8).reversed() {
            result += "\(rank + 1) "
            for file in 0..<8 {
                let sq = rank * 8 + file
                result += " \(board[sq]) "
            }
            result += "\n"
        }
        result += "   a  b  c  d  e  f  g  h\n"
        
        return result
    }
        
    // MARK: - Static Constructors
    
    static func startingPosition() -> BoardState {
        BoardState(
            whitePawns: 0x000000000000FF00,
            whiteKnights: 0x0000000000000042,
            whiteBishops: 0x0000000000000024,
            whiteRooks: 0x0000000000000081,
            whiteQueens: 0x0000000000000008,
            whiteKing: 0x0000000000000010,
            blackPawns: 0x00FF000000000000,
            blackKnights: 0x4200000000000000,
            blackBishops: 0x2400000000000000,
            blackRooks: 0x8100000000000000,
            blackQueens: 0x0800000000000000,
            blackKing: 0x1000000000000000,
            plyNumber: 0,
            playerToMove: .white,
            enpassantTargetSqauare: Bitboard.empty,
            castlingRights: [.K, .Q, .k, .q]
        )
    }
    
    static func testingPosition() -> BoardState {
        BoardState(
            whitePawns: Bitboard.empty,
            whiteKnights: 0x0000000000000042,
            whiteBishops: 0x0000000000000024,
            whiteRooks: 0x0000000000000081,
            whiteQueens: 0x0000000000000008,
            whiteKing: 0x0000000000000010,
            blackPawns: Bitboard.empty,
            blackKnights: 0x4200000000000000,
            blackBishops: 0x2400000000000000,
            blackRooks: 0x8100000000000000,
            blackQueens: 0x0800000000000000,
            blackKing: 0x1000000000000000,
            plyNumber: 0,
            playerToMove: .white,
            enpassantTargetSqauare: Bitboard.empty,
            castlingRights: [.K, .Q, .k, .q]
        )
    }
}
