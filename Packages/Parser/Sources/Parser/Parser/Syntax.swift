//
//  Syntax.swift
//  NewMusicCode
//
//  Created by Samuel Shi on 4/27/25.
//

import Foundation

// MARK: Base Protcol

/// Protocol that all syntax types conform to.
protocol Syntax: Equatable, CustomStringConvertible {
    /// Returns true iff self is of type T
    func `is`<T>(_ type: T.Type) -> Bool
    
    /// Returns non-nil T if self is of type t, and nil otherwise
    func `as`<T>(_ type: T.Type) -> T?
}

extension Syntax {
    func `is`<T>(_ type: T.Type) -> Bool {
        return self is T
    }
    
    func `as`<T>(_ type: T.Type) -> T? {
        return self as? T
    }
}

// MARK: Function Calls

/// Syntax for multiple function calls
class FunctionCallListSyntax: Syntax {
    let functionCall: FunctionCallSyntax
    let next: FunctionCallListSyntax?
    
    init(functionCall: FunctionCallSyntax, next: FunctionCallListSyntax?) {
        self.functionCall = functionCall
        self.next = next
    }
    
    var list: [FunctionCallSyntax] {
        var result = [functionCall]
        var next = next
        
        while let current = next {
            result.append(current.functionCall)
            next = current.next
        }
        
        return result
    }
    
    var description: String {
        var result = "\(functionCall)"
        
        if let next {
            result += "\n\(next)"
        }
        
        return result
    }
    
    static func == (lhs: FunctionCallListSyntax, rhs: FunctionCallListSyntax) -> Bool {
        lhs.functionCall == rhs.functionCall && lhs.next == rhs.next
    }
}

/// Syntax for a functional call expression.
/// Example: `Repeat(count: 4, subdivision: 0.5)`
struct FunctionCallSyntax: Syntax {
    let name: IdentifierSyntax
    let argument: LabeledValueSyntax?
    var trailingList: FunctionCallListSyntax? = nil
    
    var description: String {
        var result = "\(name)("
        
        if let argument { result += "\(argument)" }
        result += ")"
        
        if let trailingList { result += " {\n    \(trailingList)\n}" }
        return result
    }
}

/// Syntax for a list of labeled values
/// Example: a function call's arguments
class LabeledValueListSyntax: Syntax {
    let labeledValue: LabeledValueSyntax
    let next: LabeledValueListSyntax?
    
    init(labeledValue: LabeledValueSyntax, next: LabeledValueListSyntax?) {
        self.labeledValue = labeledValue
        self.next = next
    }
    
    static func == (lhs: LabeledValueListSyntax, rhs: LabeledValueListSyntax) -> Bool {
        lhs.labeledValue == rhs.labeledValue && lhs.next == rhs.next
    }
    
    var description: String {
        var result = "\(labeledValue)"
        if let next { result += ", \(next.description)" }
        return result
    }
}

/// Syntax for a labeled value, such as arguments
/// Example: an argument to a function call
struct LabeledValueSyntax: Syntax {
    let label: IdentifierSyntax
    let value: any ExpressionSyntax
    
    var description: String { "\(label): \(value)" }
    
    static func == (lhs: LabeledValueSyntax, rhs: LabeledValueSyntax) -> Bool {
        if lhs.label != rhs.label {
            return false
        }
    
        // Compare values by type
        switch (lhs.value, rhs.value) {
        case let (l as IntegerExpressionSyntax, r as IntegerExpressionSyntax): return l == r
        case let (l as DoubleExpressionSyntax, r as DoubleExpressionSyntax): return l == r
        case let (l as BoolExpressionSyntax, r as BoolExpressionSyntax): return l == r
        case let (l as NoteExpressionSyntax, r as NoteExpressionSyntax): return l == r
        default:
            assert(type(of: lhs) != type(of: rhs))
            return false
        }
    }
}

// MARK: Identifier

struct IdentifierSyntax: Syntax {
    let name: String
    var description: String { name }
}

extension IdentifierSyntax: ExpressibleByStringLiteral {
    init(stringLiteral value: StringLiteralType) {
        self.name = value
    }
}

// MARK: Expressions

/// Protocol that all expression syntaxes conform to.
protocol ExpressionSyntax: Syntax {}

/// Expression syntax for Int literals.
struct NoteExpressionSyntax: ExpressionSyntax {
    let value: Note
    var description: String { "\(value)" }
}

/// Expression syntax for Int literals.
struct IntegerExpressionSyntax: ExpressionSyntax {
    let value: Int
    var description: String { "\(value)" }
}

/// Expression syntax for Double literals.
struct DoubleExpressionSyntax: ExpressionSyntax {
    let value: Double
    var description: String { "\(value)" }
}

/// Expression syntax for Bool literals.
struct BoolExpressionSyntax: ExpressionSyntax {
    let value: Bool
    var description: String { "\(value)" }
}
