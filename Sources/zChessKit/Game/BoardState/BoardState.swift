//
//  BoardState.swift
//  zChessKit
//
//  Created by Ben Zobrist on 9/15/25.
//

import zBitboard

public struct BoardState: Codable {
    // MARK: - Immutable Bitboards
    public let whitePawns: Bitboard
    public let whiteKnights: Bitboard
    public let whiteBishops: Bitboard
    public let whiteRooks: Bitboard
    public let whiteQueens: Bitboard
    public let whiteKing: Bitboard
    
    public let blackPawns: Bitboard
    public let blackKnights: Bitboard
    public let blackBishops: Bitboard
    public let blackRooks: Bitboard
    public let blackQueens: Bitboard
    public let blackKing: Bitboard
    
    // MARK: - Metadata
    public let halfmoveClock: Int
    public let plyNumber: Int
    public let playerToMove: PlayerColor
    public let enpassantTargetSquare: Bitboard
    
    public let castlingRights: [CastlingRights]
    
    // MARK: - Derived Bitboards
    public var whitePieces: Bitboard {
        whitePawns | whiteKnights | whiteBishops | whiteRooks | whiteQueens | whiteKing
    }
    
    public var blackPieces: Bitboard {
        blackPawns | blackKnights | blackBishops | blackRooks | blackQueens | blackKing
    }
    
    public var allPieces: Bitboard {
        whitePieces | blackPieces
    }
    
    //MARK: - Init functions
    
    public init(
        whitePawns: Bitboard,
        whiteKnights: Bitboard,
        whiteBishops: Bitboard,
        whiteRooks: Bitboard,
        whiteQueens: Bitboard,
        whiteKing: Bitboard,
        blackPawns: Bitboard,
        blackKnights: Bitboard,
        blackBishops: Bitboard,
        blackRooks: Bitboard,
        blackQueens: Bitboard,
        blackKing: Bitboard,
        halfmoveClock: Int,
        plyNumber: Int,
        playerToMove: PlayerColor,
        enpassantTargetSqauare: Bitboard,
        castlingRights: [CastlingRights]
    ) {
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
        self.halfmoveClock = halfmoveClock
        self.plyNumber = plyNumber
        self.playerToMove = playerToMove
        self.enpassantTargetSquare = enpassantTargetSqauare
        self.castlingRights = castlingRights
    }
    
    public static func fromFEN(_ fen: String) -> BoardState? {
        guard let tokens = try? Lexer.getFENLexer().run(input: fen) else { return nil }
        guard let state = try? Parser.parseFEN(from: tokens) else { return nil }
        
        // TODO: Probably should ensure only one FEN in string
        // or maybe return [BoardState] instead
        return state.first
    }
        
    // MARK: - Static Constructors
    
    public static func startingPosition() -> BoardState {
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
            halfmoveClock: 0,
            plyNumber: 0,
            playerToMove: .white,
            enpassantTargetSqauare: Bitboard.empty,
            castlingRights: [.K, .Q, .k, .q]
        )
    }
}
