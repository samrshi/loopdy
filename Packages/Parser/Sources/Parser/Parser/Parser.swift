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
    mutating func parseFunctionCallList() throws (ParseError) -> FunctionCallListSyntax {
        // functionCallList ::= [whitespace] functionCall [whitespace] [functionCallList]
        try parseWhitespace()
        let functionCall = try parseFunctionCall()
        try parseWhitespace()
        let next = checkFunctionCallList() ? try parseFunctionCallList() : nil
        return FunctionCallListSyntax(functionCall: functionCall, next: next)
    }
    
    mutating func parseFunctionCall() throws(ParseError) -> FunctionCallSyntax {
        // functionCall ::= identifier "(" [labeled-argument] ")" [{ whitespace [functionCallList] whitespace }]
        let name = try parseIdentifier()
        try consume(.openParen)
        try parseWhitespace()
        let argument = checkIdentifier() ? try parseLabeledArgument() : nil
        try parseWhitespace()
        try consume(.closeParen)
        try parseWhitespace()
        
        var trailingList: FunctionCallListSyntax? = nil
        
        if peek()?.kind == .openCurly {
            try consume(.openCurly)
            try parseWhitespace()
            
            if checkFunctionCallList() {
                trailingList = try parseFunctionCallList()
            }
            
            try parseWhitespace()
            try consume(.closeCurly)
        }
        
        return FunctionCallSyntax(
            name: name,
            argument: argument,
            trailingList: trailingList
        )
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
            throw ParseError(reason: "Failed to parse idenfier (found: \(token))")
        }
    }
    
    mutating func parseExpression() throws(ParseError) -> any ExpressionSyntax {
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
            throw ParseError(reason: "Incorrect token kind. (\(token) != \(kind))")
        }
        
        return token
    }
    
    @discardableResult
    mutating func consume(while kind: TokenKind) throws(ParseError) -> [Token] {
        var result: [Token] = []
        
        while peek()?.kind == kind {
            result.append(try consume())
        }
        
        return result
    }
}
 
extension Parser {
    func peek() -> Token? {
        tokens.first
    }
    
    func checkIdentifier() -> Bool {
        peek()?.kind == .identifier
    }
    
    func checkFunctionCallList() -> Bool {
        checkFunctionCall()
    }
    
    func checkFunctionCall() -> Bool {
        peek()?.kind == .identifier
    }
}

private func ~= (kinds: [Token], actual: Token?) -> Bool {
    actual.map { kinds.contains($0) } ?? false
}
