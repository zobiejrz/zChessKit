//
//  PGNTests.swift
//  zChessKit
//
//  Created by Ben Zobrist on 9/23/25.
//

import Testing
@testable import zChessKit

@Test func testImportSingleValidGame() async throws {
    
    let PGN = """
        [Event "Live Chess"]
        [Site "Chess.com"]
        [Date "2025.09.19"]
        [Round "?"]
        [White "real_zobie"]
        [Black "Yuyobrujo"]
        [Result "1-0"]
        [ECO "C62"]
        [WhiteElo "1411"]
        [BlackElo "1392"]
        [TimeControl "600"]
        [EndTime "20:04:04 GMT+0000"]
        [Termination "real_zobie won by resignation"]
        [Link "https://www.chess.com/analysis/game/pgn/3ASPXqbUKY/analysis"]
        
        1. e4 e5 2. Nf3 Nc6 3. Bb5 d6 4. d4 Bd7 5. Nc3 Nge7 6. Bg5 f6 7. Bh4 g5 8. Nxg5
        fxg5 9. Bxg5 Bg7 10. Qh5+ Ng6 11. Bxd8 Nxd8 12. Bxd7+ Kxd7 13. dxe5 Nxe5 14. f4
        Ng6 15. Qf5+ Ne6 16. Qf7+ Ne7 17. f5 Rhf8 18. fxe6+ Kc6 19. Qxg7 1-0
        """
    
    let tokens = Lexer().run(input: PGN)
    let games = try! Parser().parse(tokens: tokens)
    
    #expect(games.count == 1, "Only one game was in the input")
    
    let game = games.first!
    
    #expect(game.currentState == BoardState(FEN: "r4r2/ppp1n1Qp/2kpP3/8/4P3/2N5/PPP3PP/R3K2R b KQ - 0 19"), "These boardstates should match")
    
}

@Test func testImportSeveralValidGames() async throws {
    
    let PGN = """
        [Event "Live Chess"]
        [Site "Chess.com"]
        [Date "2025.09.19"]
        [Round "?"]
        [White "real_zobie"]
        [Black "Yuyobrujo"]
        [Result "1-0"]
        [ECO "C62"]
        [WhiteElo "1411"]
        [BlackElo "1392"]
        [TimeControl "600"]
        [EndTime "20:04:04 GMT+0000"]
        [Termination "real_zobie won by resignation"]
        [Link "https://www.chess.com/analysis/game/pgn/3ASPXqbUKY/analysis"]
        
        1. e4 e5 2. Nf3 Nc6 3. Bb5 d6 4. d4 Bd7 5. Nc3 Nge7 6. Bg5 f6 7. Bh4 g5 8. Nxg5
        fxg5 9. Bxg5 Bg7 10. Qh5+ Ng6 11. Bxd8 Nxd8 12. Bxd7+ Kxd7 13. dxe5 Nxe5 14. f4
        Ng6 15. Qf5+ Ne6 16. Qf7+ Ne7 17. f5 Rhf8 18. fxe6+ Kc6 19. Qxg7 1-0
        
        [Event "Let\'s Play!"]
        [Site "Chess.com"]
        [Date "2025.06.25"]
        [Round "?"]
        [White "10_on_Mohs_scale"]
        [Black "real_zobie"]
        [Result "0-1"]
        [TimeControl "1/1209600"]
        [WhiteElo "460"]
        [BlackElo "859"]
        [Termination "real_zobie won by checkmate"]
        [ECO "B07"]
        [EndDate "2025.07.16"]
        [Link "https://www.chess.com/game/daily/831269378?move=0"]
        
        d4 Nf6 2. Nc3 g6 3. e4 d6 4. d5 Bg7 5. Bb5+ c6 6. Ba4 b5 7. Bb3 O-O 8. a3 e6
        dxe6 Bxe6 10. Bxe6 fxe6 11. Bg5 h6 12. Bh4 Nbd7 13. Qxd6 g5 14. Qxe6+ Kh8 15.
        Bg3 Nc5 16. Qxc6 Ncxe4 17. Nge2 Qd2+ 18. Kf1 Nxf2 19. Bd6 N6e4 20. Bc5 Nxc5 21.
        Qxc5 Ne4+ 22. Qxf8+ Rxf8+ 23. Kg1 Qe3# {[%c_effect
        h8;square;h8;type;Winner;animated;true;keyPressed;undefined;persistent;true,g1;square;g1;type;CheckmateWhite;animated;true;keyPressed;undefined;persistent;true]}
        0-1
        
        [Event "Live Chess"]
        [Site "Chess.com"]
        [Date "2025.08.04"]
        [Round "?"]
        [White "real_zobie"]
        [Black "Bambroo"]
        [Result "1-0"]
        [TimeControl "900+10"]
        [WhiteElo "1211"]
        [BlackElo "1216"]
        [Termination "real_zobie won by resignation"]
        [ECO "B13"]
        [EndTime "19:47:08 GMT+0000"]
        [Link "https://www.chess.com/game/live/141488990826"]
        
        e4 {[%clk 0:15:06.4][%timestamp 36]} 1... c6 {[%clk 0:15:05.1][%timestamp
        49]} 2. d4 {[%clk 0:15:14][%timestamp 24]} 2... d5 {[%clk 0:15:09.1][%timestamp
        60]} 3. exd5 {[%clk 0:15:23.3][%timestamp 7]} 3... cxd5 {[%clk
        0:15:16.6][%timestamp 25]} 4. Bf4 {[%clk 0:15:24.5][%timestamp 88]} 4... Nc6
        {[%clk 0:15:23.6][%timestamp 30]} 5. c3 {[%clk 0:15:33.5][%timestamp 10]} 5...
        Qb6 {[%clk 0:15:28.8][%timestamp 48]} 6. Qc2 {[%clk 0:15:28.8][%timestamp 147]}
        6... Nf6 {[%clk 0:15:26.9][%timestamp 119]} 7. Bd3 {[%clk 0:15:14.8][%timestamp
        240]} 7... Na5 {[%clk 0:15:07.1][%timestamp 298]} 8. Nd2 {[%clk
        0:15:03.5][%timestamp 213]} 8... Bg4 {[%clk 0:14:52.2][%timestamp 249]} 9. Ngf3
        {[%clk 0:14:47.9][%timestamp 256]} 9... Bxf3 {[%clk 0:14:56.8][%timestamp 54]}
        gxf3 {[%clk 0:14:57.8][%timestamp 1]} 10... O-O-O {[%clk
        0:14:53.7][%timestamp 131]} 11. c4 {[%clk 0:14:42.3][%timestamp 255]} 11... dxc4
        {[%clk 0:14:43][%timestamp 207]} 12. Nxc4 {[%clk 0:14:46.8][%timestamp 55]}
        12... Nxc4 {[%clk 0:14:33.5][%timestamp 195]} 13. Qxc4+ {[%clk
        0:14:55.1][%timestamp 17]} 13... Qc6 {[%clk 0:14:33.2][%timestamp 103]} 14. Rc1
        {[%clk 0:14:38.6][%timestamp 265]} 14... e5 {[%clk 0:13:52.1][%timestamp 511]}
        Qxf7 {[%clk 0:14:37.4][%timestamp 112]} 15... exf4 {[%clk
        0:13:08.3][%timestamp 538]} 16. Rxc6+ {[%clk 0:14:45.9][%timestamp 15]} 16...
        bxc6 {[%clk 0:13:12.3][%timestamp 60]} 17. Ba6+ {[%clk 0:14:43.9][%timestamp
        120][%c_effect
        e1;square;e1;type;Winner;animated;true;keyPressed;undefined;persistent;true,c8;square;c8;type;ResignBlack;animated;true;keyPressed;undefined;persistent;true]}
        1-0
        """
    
    let tokens = Lexer().run(input: PGN)
    let games = try! Parser().parse(tokens: tokens)
    
    #expect(games.count == 3, "Three games were in the input")
        
    #expect(games[0].currentState == BoardState(FEN: "r4r2/ppp1n1Qp/2kpP3/8/4P3/2N5/PPP3PP/R3K2R b KQ - 0 19"), "These boardstates should match")
    #expect(games[1].currentState == BoardState(FEN: "5r1k/p5b1/7p/1p4p1/4n3/P1N1q3/1PP1N1PP/R5KR w - - 2 24"), "These boardstates should match")
    #expect(games[2].currentState == BoardState(FEN: "2kr1b1r/p4Qpp/B1p2n2/8/3P1p2/5P2/PP3P1P/4K2R b K - 1 17"), "These boardstates should match")

}
