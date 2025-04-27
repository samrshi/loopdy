//
//  Token.swift
//  NewMusicCode
//
//  Created by Samuel Shi on 4/26/25.
//

import Foundation

enum NoteAccidental: Character, Equatable {
    case flat = "b"
    case sharp = "#"
}

enum Token: Equatable {
    // Literals
    case noteLiteral(Character, NoteAccidental?, Int)
    case doubleLiteral(Double)
    case boolLiteral(Bool)
    case intLiteral(Int)
    
    // Identifier
    case identifier(String)

    // Whitespace
    case space
    case newline
    
    // Punctuation
    case openParen
    case closeParen
    case openCurly
    case closeCurly
    case colon
    case comma
    
    var text: String {
        switch self {
        case .noteLiteral(let c, let a, let o): "\(c)\(a.map { String($0.rawValue) } ?? "")\(o)"
        case .doubleLiteral(let value): "\(value)"
        case .boolLiteral(let value): "\(value)"
        case .intLiteral(let value): "\(value)"
        case .identifier(let value): "\(value)"
        case .space: " "
        case .newline: "\n"
        case .openParen: "("
        case .closeParen: ")"
        case .openCurly: "{"
        case .closeCurly: "}"
        case .colon: ":"
        case .comma: ","
        }
    }
}

enum TokenRegex {
    // Literals
    static let noteLiteral = /[A-G][b#]?[0-9]/
    static let boolLiteral = /false|true/
    static let doubleLiteral = /\d+\.\d+/
    static let intLiteral = /\d+/
    
    // Identifier
    static let identifier = /[a-zA-Z]+/
    
    // Whitespace
    static let space = /\ /
    static let newline = /\n/
    
    // Punctuation
    static let openParen = /\(/
    static let closeParen = /\)/
    static let openCurly = /{/
    static let closeCurly = /}/
    static let colon = /:/
    static let comma = /,/
}
