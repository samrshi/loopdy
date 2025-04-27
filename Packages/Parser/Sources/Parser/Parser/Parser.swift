//
//  Parser.swift
//  NewMusicCode
//
//  Created by Samuel Shi on 4/26/25.
//

import DequeModule
import Foundation

struct Parser {
    // TODO: Maybe rewrite to use TokenIterator
    var tokens: Deque<Token>
    
    init(source: String) {
        let sequence = TokenSequence(source: source)
        self.tokens = Deque(sequence)
    }
}

extension Parser {
    mutating func parseFunctionCall() throws(ParseError) -> FunctionCallSyntax {
        // functionCall ::= identifier "(" [labeled-argument] ")"
        let name = try parseIdentifier()
        try consume(.openParen)
        try parseWhitespace()
        
        let argument: LabeledValueSyntax? = switch peek() {
        case .identifier: try parseLabeledArgument()
        default: nil
        }
        
        try parseWhitespace()
        try consume(.closeParen)
        return FunctionCallSyntax(name: name, argument: argument)
    }
    
    mutating func parseLabeledArgument() throws(ParseError) -> LabeledValueSyntax {
        // labeled-argument ::= identifier ":" whitespace expression
        let label = try parseIdentifier()
        try consume(.colon)
        try parseWhitespace()
        let value = try parseExpression()
        
        return LabeledValueSyntax(label: label, value: value)
    }
    
    mutating func parseIdentifier() throws(ParseError) -> IdentifierSyntax {
        let token = try consume()
        
        if case .identifier(let name) = token {
            return IdentifierSyntax(name: name)
        } else {
            throw ParseError(reason: "Failed to parse idenfier (found: \(token)")
        }
    }
    
    mutating func parseExpression() throws(ParseError) -> ExpressionSyntax {
        // expression ::= integerLiteral | doubleLiteral | boolLiteral | noteLiteral
        let token = try consume()
        
        switch token {
        case .intLiteral(let value): return IntegerExpressionSyntax(value: value)
        case .doubleLiteral(let value): return DoubleExpressionSyntax(value: value)
        case .boolLiteral(let value): return BoolExpressionSyntax(value: value)
        case .noteLiteral(let value): return NoteExpressionSyntax(value: value)
        default: throw ParseError(reason: "Failed to parse expression.")
        }
    }
    
    mutating func parseWhitespace() throws(ParseError) {
        // whitespace ::= (space | newline)...
        while [.space, .newline] ~= peek() {
            try consume()
        }
    }
}

extension Parser {
    @discardableResult
    mutating func consume() throws(ParseError) -> Token {
        if let token = tokens.popFirst() {
            return token
        } else {
            throw ParseError.outOfTokens
        }
    }
    
    @discardableResult
    mutating func consume(_ kind: TokenKind) throws(ParseError) -> Token {
        guard let token = tokens.popFirst() else {
            throw ParseError.outOfTokens
        }
        
        guard token.kind == kind else {
            throw ParseError(reason: "Incorrect token kind. (\(token) != \(kind)")
        }
        
        return token
    }
}
 
extension Parser {
    mutating func peek() -> Token? {
        tokens.first
    }
}

private func ~= (kinds: [Token], actual: Token?) -> Bool {
    actual.map { kinds.contains($0) } ?? false
}
