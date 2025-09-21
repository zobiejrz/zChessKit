//
//  MagicTables.swift
//  zChessKit
//
//  Created by Ben Zobrist on 9/16/25.
//
import zBitboard

enum MagicTables {
    
    static let rook: [MagicBitboard] = {
        
        var tables: [MagicBitboard] = []
        for sq in Square.allCases {
            let mag = MagicNumbers.rookMagics[sq.rawValue]
            tables.append(
                MagicBitboard(
                    square: sq,
                    magicNumber: mag,
                    maskForSquare: rookMask(forSquare: sq),
                    slidingAttacks: Square.slidingRookAttacks
                )
            )
        }
        return tables
    }()
    
    static let bishop: [MagicBitboard] = {
                
        var tables: [MagicBitboard] = []
        for sq in Square.allCases {
            let mag = MagicNumbers.bishopMagics[sq.rawValue]
            tables.append(
                MagicBitboard(
                    square: sq,
                    magicNumber: mag,
                    maskForSquare: bishopMask(forSquare: sq),
                    slidingAttacks: Square.slidingBishopAttacks
                )
            )
        }
        return tables
    }()
}

/// Generate the bishop occupancy mask for a given square:
/// all diagonal squares except the *edges* of the board.
/// These are the "relevant blocker" squares for magic indexing.
func bishopMask(forSquare sq: Square) -> Bitboard {
    let file0 = sq.rawValue & 7
    let rank0 = sq.rawValue >> 3
    
    var mask = Bitboard.empty
    
    // diagonal directions: NE, NW, SE, SW
    let dirs = [(1, 1), (-1, 1), (1, -1), (-1, -1)]
    
    for (dx, dy) in dirs {
        var f = file0 + dx
        var r = rank0 + dy
        while f >= 0 && f <= 7 && r >= 0 && r <= 7 {
            // stop before the edge square
            if f == 0 || f == 7 || r == 0 || r == 7 {
                break
            }
            mask |= Bitboard.squareMask(Square(rawValue: (r*8) + f)!)//bit(squareIndex(file: f, rank: r))
            f += dx
            r += dy
        }
    }
    return mask
}

/// Generate the rook occupancy mask for a given square:
/// all squares along the four rook rays except the *edges* of the board.
/// These are the "relevant blocker" squares for magic indexing.
func rookMask(forSquare sq: Square) -> Bitboard {
    let file0 = sq.rawValue & 7
    let rank0 = sq.rawValue >> 3
    
    var mask = Bitboard.empty
    
    // directions as (dx, dy): East, West, North, South
    let dirs = [(1, 0), (-1, 0), (0, 1), (0, -1)]
    
    for (dx, dy) in dirs {
        var f = file0 + dx
        var r = rank0 + dy
        while f >= 0 && f <= 7 && r >= 0 && r <= 7 {
            // if we reached an edge square, stop and do NOT add it to the mask.
            if (dx == 1 && f == 7) ||     // moving east, stop when you hit file h (don't include h)
                (dx == -1 && f == 0) ||    // moving west, stop when you hit file a (don't include a)
                (dy == 1  && r == 7) ||    // moving north, stop when you hit rank 8 (don't include 8)
                (dy == -1 && r == 0) {     // moving south, stop when you hit rank 1 (don't include 1)
                break
            }
            mask |= Bitboard.squareMask(Square(rawValue: (r*8) + f)!)
            f += dx
            r += dy
        }
    }
    return mask
}
