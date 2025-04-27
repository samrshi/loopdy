//
//  Tokenizer.swift
//  NewMusicCode
//
//  Created by Samuel Shi on 4/26/25.
//

import Foundation

private func ~= (pattern: Regex<Substring>, value: Substring) -> Bool {
    return value.prefixMatch(of: pattern) != nil
}

struct TokenSequence: Sequence {
    let source: String
    
    func makeIterator() -> TokenIterator {
        TokenIterator(source: source)
    }
}


struct TokenIterator: IteratorProtocol {
    typealias Element = Token
    
    let source: String
    var currentIndex: String.Index
    
    init(source: String) {
        self.source = source
        self.currentIndex = source.startIndex
    }
    
    mutating func next() -> Token? {
        switch source[currentIndex...] {
        // Literals
        case TokenRegex.noteLiteral: lexNoteLiteral()
        case TokenRegex.doubleLiteral: lexDoubleLiteral()
        case TokenRegex.boolLiteral: lexBoolLiteral()
        case TokenRegex.intLiteral: lexIntLiteral()
            
        // Identifier
        case TokenRegex.identifier: lexIdentifier()
            
        // Whitespace
        case TokenRegex.space: lex(token: .space)
        case TokenRegex.newline: lex(token: .newline)

        // Punctuation
        case TokenRegex.openParen: lex(token: .openParen)
        case TokenRegex.closeParen: lex(token: .closeParen)
        case TokenRegex.openCurly: lex(token: .openCurly)
        case TokenRegex.closeCurly: lex(token: .closeCurly)
        case TokenRegex.colon: lex(token: .colon)
        case TokenRegex.comma: lex(token: .comma)
        default: nil
        }
    }
}

extension TokenIterator {
    private func peek() -> Character {
        source[currentIndex]
    }
    
    @discardableResult
    private mutating func advance() -> Character {
        let index = currentIndex
        source.formIndex(after: &currentIndex)
        return source[index]
    }
    
    private mutating func lexNoteLiteral() -> Token {
        // Read letter
        let letter = advance()
        
        // Read accidental, if present
        let accidental = switch peek() {
        case "b", "#": NoteAccidental(rawValue: advance())
        default: NoteAccidental?.none
        }
        
        // Read octave number & return
        let octave = advance().wholeNumberValue!
        return .noteLiteral(letter, accidental, octave)
    }
    
    private mutating func lexDoubleLiteral() -> Token {
        let match = try! TokenRegex.doubleLiteral.prefixMatch(
            in: source[currentIndex...])!
        
        let value = Double(match.output)!
        currentIndex = match.endIndex
        return .doubleLiteral(value)
    }
    
    private mutating func lexBoolLiteral() -> Token {
        let match = try! TokenRegex.boolLiteral.prefixMatch(
            in: source[currentIndex...])!
        
        let value = Bool(String(match.output))!
        currentIndex = match.endIndex
        return .boolLiteral(value)
    }
    
    private mutating func lexIntLiteral() -> Token {
        let match = try! TokenRegex.intLiteral.prefixMatch(
            in: source[currentIndex...])!
        
        let value = Int(match.output)!
        currentIndex = match.endIndex
        return .intLiteral(value)
    }
    
    private mutating func lexIdentifier() -> Token {
        let match = try! TokenRegex.identifier.prefixMatch(
            in: source[currentIndex...])!
        
        let value = String(match.output)
        currentIndex = match.endIndex
        return .identifier(value)
    }
    
    private mutating func lex(token: Token) -> Token {
        advance()
        return token
    }
}
