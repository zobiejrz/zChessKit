//
//  Automata.swift
//  zchess
//
//  Created by Ben Zobrist on 9/12/25.
//

protocol Automata {
    func run(input: String) -> UInt
    func getType() -> TokenType
}
