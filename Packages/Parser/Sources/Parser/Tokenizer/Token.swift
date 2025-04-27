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

enum TokenKind: Equatable {
    // Literals
    case noteLiteral
    // TODO: Chord literal—ex: Am7
    case doubleLiteral
    case boolLiteral
    case intLiteral
        
    // Identifier
    case identifier

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
}

enum Token: Equatable {
    // Literals
    // TODO: Make octave number optional
    case noteLiteral(Note)
    // TODO: Chord literal—ex: Am7
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
        case .noteLiteral(let value): "\(value)"
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
    
    var kind: TokenKind {
        switch self {
        case .noteLiteral: .noteLiteral
        case .doubleLiteral: .doubleLiteral
        case .boolLiteral: .boolLiteral
        case .intLiteral: .intLiteral
        case .identifier: .identifier
        case .space: .space
        case .newline: .newline
        case .openParen: .openParen
        case .closeParen: .closeParen
        case .openCurly: .openCurly
        case .closeCurly: .closeCurly
        case .colon: .colon
        case .comma: .comma
        }
    }
}

enum TokenRegex {
    // Literals
    static var noteLiteral: Regex<Substring> { /[A-G][b#]?[0-9]/ }
    static var boolLiteral: Regex<Substring> { /false|true/ }
    static var doubleLiteral: Regex<Substring> { /\d+\.\d+/ }
    static var intLiteral: Regex<Substring> { /\d+/ }
    
    // Identifier
    static var identifier: Regex<Substring> { /[a-zA-Z]+/ }
    
    // Whitespace
    static var space: Regex<Substring> { /\ / }
    static var newline: Regex<Substring> { /\n/ }
    
    // Punctuation
    static var openParen: Regex<Substring> { /\(/ }
    static var closeParen: Regex<Substring> { /\)/ }
    static var openCurly: Regex<Substring> { /{/ }
    static var closeCurly: Regex<Substring> { /}/ }
    static var colon: Regex<Substring> { /:/ }
    static var comma: Regex<Substring> { /,/ }
}
