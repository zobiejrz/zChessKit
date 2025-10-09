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
    
    let tokens = Lexer.getPGNLexer().run(input: PGN)
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
        
        [Event "Live Chess"]
        [Site "Chess.com"]
        [Date "2025.09.18"]
        [Round "?"]
        [White "Nair75"]
        [Black "real_zobie"]
        [Result "0-1"]
        [TimeControl "600"]
        [WhiteElo "1386"]
        [BlackElo "1381"]
        [Termination "real_zobie won by resignation"]
        [ECO "C01"]
        [EndTime "0:11:22 GMT+0000"]
        [Link "https://www.chess.com/game/live/143249380584"]
        
        1. e4 e6 2. d4 d5 3. exd5 exd5 4. Nc3 Nf6 5. Bb5+ c6 6. Bd3 Bd6 7. Bg5 Nbd7 8.
        Nge2 O-O 9. O-O Qb6 10. Rb1 Bb4 11. Na4 Qa5 12. c3 Bd6 13. b4 Qc7 14. h3 b5 15.
        Nc5 Bxc5 16. bxc5 a5 17. a4 bxa4 18. Qxa4 Ne4 19. Bf4 Nxc3 20. Nxc3 Qxf4 21.
        Qxc6 Nf6 22. Qxa8 Qg5 23. Kh2 Bxh3 24. Qxf8+ Kxf8 25. Kxh3 Qd2 26. Nxd5 Nxd5 27.
        Rfd1 Qh6+ 28. Kg3 Qg5+ 29. Kf3 Qf4+ 30. Ke2 Nc3+ 31. Kf1 Nxd1 32. Rxd1 Qxd4 33.
        Be2 Qxc5 34. Ra1 Qb4 35. Bd3 a4 36. Rb1 Qc3 37. Bxh7 a3 38. Be4 a2 39. Re1 a1=Q
        40. Rb1 0-1
        
        [Event "Live Chess"]
        [Site "Chess.com"]
        [Date "2025.09.17"]
        [Round "?"]
        [White "MalCerebro"]
        [Black "real_zobie"]
        [Result "0-1"]
        [TimeControl "600"]
        [WhiteElo "1351"]
        [BlackElo "1365"]
        [Termination "real_zobie won - game abandoned"]
        [ECO "C00"]
        [EndTime "23:25:14 GMT+0000"]
        [Link "https://www.chess.com/game/live/143248357170"]
        
        1. e4 e6 2. Nc3 d5 3. exd5 exd5 4. d4 Nf6 5. Bg5 Bb4 6. Qd3 Nc6 7. O-O-O O-O 8.
        Kb1 Bxc3 9. Qxc3 Ne4 10. Bxd8 Nxc3+ 11. bxc3 Rxd8 12. Bb5 Bd7 13. Nf3 a6 14. Ba4
        b5 15. Bb3 Be6 16. Rhe1 Na5 17. Ne5 Nc4 18. Nc6 Rd6 19. Ne5 f6 20. Nd3 a5 21. a4
        bxa4 22. Bxa4 Rb8+ 23. Ka1 Bf5 24. Re8+ Rxe8 25. Bxe8 Na3 26. Kb2 Nc4+ 27. Ka2
        Bxd3 28. cxd3 Nb6 29. Ka3 Re6 30. Bh5 g6 31. Bg4 f5 32. Bh3 Rc6 33. Rc1 Nc8 34.
        g4 Nd6 35. gxf5 gxf5 36. Ka4 Kf8 37. Kxa5 Rb6 38. Bg2 Ke7 39. Bxd5 Rb5+ 40. Ka6
        Rxd5 41. Re1+ Kf6 42. c4 Rxd4 43. c5 Nf7 44. Kb7 Rxd3 45. Kxc7 Rc3 46. c6 Ne5
        47. Rxe5 Kxe5 48. Kd7 Ke4 49. c7 Kf3 50. c8=Q Rxc8 51. Kxc8 Kxf2 52. Kd7 f4 53.
        Ke6 f3 54. Kf5 Kg2 55. Kg4 f2 56. h3 f1=Q 57. h4 Qf6 58. h5 Qh6 59. Kh4 Kf2 60.
        Kg4 Qg7+ 61. Kh4 Qf6+ 62. Kg4 Ke3 63. h6 Qxh6 64. Kf5 Qg6+ 65. Ke5 h6 0-1
        
        [Event "Live Chess"]
        [Site "Chess.com"]
        [Date "2025.09.17"]
        [Round "-"]
        [White "real_zobie"]
        [Black "jokerpez"]
        [Result "1-0"]
        [CurrentPosition "8/8/r7/6R1/5Bk1/6P1/6K1/8 b - - 13 57"]
        [Timezone "UTC"]
        [ECO "B09"]
        [ECOUrl "https://www.chess.com/openings/Pirc-Defense-Main-Line-Austrian-Attack-4...Bg7-5.e5-dxe5"]
        [UTCDate "2025.09.17"]
        [UTCTime "01:25:49"]
        [WhiteElo "1332"]
        [BlackElo "1328"]
        [TimeControl "600"]
        [Termination "real_zobie won by checkmate"]
        [StartTime "01:25:49"]
        [EndDate "2025.09.17"]
        [EndTime "01:42:58"]
        [Link "https://www.chess.com/analysis/game/live/143211107298/analysis?move=112"]
        [WhiteUrl "https://images.chesscomfiles.com/uploads/v1/user/123828444.65833378.50x50o.36881bc35c13.jpg"]
        [WhiteCountry "2"]
        [WhiteTitle ""]
        [BlackUrl "https://www.chess.com/bundles/web/images/noavatar_l.84a92436.gif"]
        [BlackCountry "34"]
        [BlackTitle ""]
        
        1. e4 d6 2. d4 Nf6 3. Nc3 g6 4. f4 Bg7 5. e5 dxe5 6. fxe5 Nd5 7. Nxd5 Qxd5 8.
        Nf3 Nc6 9. c3 O-O 10. Be2 f6 11. O-O fxe5 12. b3 Kh8 13. Bc4 Qd6 14. Ng5 Rxf1+
        15. Qxf1 Qf6 16. Nf7+ Kg8 17. Qxf6 Bxf6 18. Bh6 e6 19. Ng5 Bxg5 20. Bxg5 exd4
        21. Bh6 dxc3 22. Rf1 Bd7 23. Rc1 Ne5 24. Rxc3 Nxc4 25. Rxc4 c6 26. Rd4 Bc8 27.
        Rf4 Bd7 28. Rd4 Rd8 29. Bg5 Rb8 30. Rxd7 h5 31. Re7 b5 32. Rxe6 c5 33. Rxg6+ Kf7
        34. Rf6+ Kg7 35. Ra6 c4 36. Rxa7+ Kg6 37. Bf4 Rd8 38. Ra6+ Kf5 39. g3 c3 40. Rc6
        b4 41. Kg2 h4 42. Kh3 hxg3 43. hxg3 Rh8+ 44. Kg2 Re8 45. Kf2 Ra8 46. Bd6 Rxa2+
        47. Kf3 c2 48. Bxb4 $9 (48. Bf4 c1=Q 49. g4#) 48... Rb2 49. Rc3 c1=Q 50. Rxc1
        Rxb3+ 51. Bc3 Kg5 52. Kg2 Kg4 53. Be5 Ra3 54. Rc4+ Kf5 55. Bf4 Ra6 56. Rc5+ Kg4
        57. Rg5# 1-0
        """
    
    let tokens = Lexer.getPGNLexer().run(input: PGN)
    let games = try! Parser().parse(tokens: tokens)
    
    #expect(games.count == 6, "The number of inputted PGNs needs to match number of games")
    
    #expect(games[0].currentState == BoardState(FEN: "r4r2/ppp1n1Qp/2kpP3/8/4P3/2N5/PPP3PP/R3K2R b KQ - 0 19"), "These boardstates should match")
    #expect(games[1].currentState == BoardState(FEN: "5r1k/p5b1/7p/1p4p1/4n3/P1N1q3/1PP1N1PP/R5KR w - - 2 24"), "These boardstates should match")
    #expect(games[2].currentState == BoardState(FEN: "2kr1b1r/p4Qpp/B1p2n2/8/3P1p2/5P2/PP3P1P/4K2R b K - 1 17"), "These boardstates should match")
    #expect(games[3].currentState == BoardState(FEN: "5k2/5pp1/8/8/4B3/2q5/5PP1/qR3K2 b - - 1 40"), "These boardstates should match")
    #expect(games[4].currentState == BoardState(FEN: "8/8/6qp/4K3/8/4k3/8/8 w - - 0 66"), "These boardstates should match")
    #expect(games[5].currentState == BoardState(FEN: "8/8/r7/6R1/5Bk1/6P1/6K1/8 b - - 13 57"), "These boardstates should match")


}

@Test func testCommentedLines() async throws {
    
    let PGN = """
        [Event "Line 01"]
        [Site "?"]
        [Date "????.??.??"]
        [Round "?"]
        [White "zChess"]
        [Black "USER"]
        [Result "0-1"]
        
        1. e4 {To get to the Traxler Counterattack, we first have to get to the Italian
        Game: Two Knights Defense. Respond to 1. e4 with 1... e5.} 1... e5 2. Nf3
        {Notice how 2. Nf3 attacks our e5 pawn. Defend it with 2... Nc6.} 2... Nc6 3.
        Bc4 {We've made it to the Italian Game. Several responses are available from
        here, but we achieve the Two Knights Defense with 3... Nf6.} 3... Nf6 4. Ng5
        {Now that we see the Fried Liver Attack, we can tempt White to fork our Queen
        and Rook with 4... Bc5.} 4... Bc5 5. Nxf7 {We start the Counterattack with 5...
        Bxf2+, sacrificing the exchange.} 5... Bxf2+ {Think about ways to check the King
        that tries to draw the opposing King out into the open.} 6. Kxf2 {The King
        doesn't always have to take, but if it does we need to get another pawn with
        6... Nxe4+, which puts more pressure on the exposed enemy King.} 6... Nxe4+
        {Find a follow up check that puts more pressure on the opposing King.} 7. Ke3
        {Now that the King is marching forward, we get our Queen into the attack with
        7... Qh4. This defends the e4 Knight while continuing to put pressure on the
        exposed enemy King.} 7... Qh4 {Look for ways to save our Queen from the fork and
        defend our Knight.} 8. Nxh8 {White should have remembered that King safety is
        more important than winning a Rook. M4 starting with 8... Qf4+.} 8... Qf4+
        {Check the King with our Queen.} 9. Kd3 {The King only has one square to run
        away to right now and 9... Nb4+ forces it back towards our Queen.} 9... Nb4+
        {Try using the other Knight to force the King to its last remaining square.} 10.
        Ke2 {Now we can finish the game with 10... Qf2#.} 10... Qf2# {Find the checkmate
        in one.} 0-1
        """
    
    let tokens = Lexer.getPGNLexer().run(input: PGN)
    let games = try! Parser().parse(tokens: tokens)
    
    #expect(games.count == 1, "The number of inputted PGNs needs to match number of games")
    #expect(games[0].currentState == BoardState(FEN: "r1b1k2N/pppp2pp/8/4p3/1nB1n3/8/PPPPKqPP/RNBQ3R w q - 5 11"), "These boardstates should match")
    #expect(games[0].moves.first?.annotation == "To get to the Traxler Counterattack, we first have to get to the Italian Game: Two Knights Defense. Respond to 1. e4 with 1... e5.")
    #expect(games[0].moves.last?.annotation == "Find the checkmate in one.")
}
