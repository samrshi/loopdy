//
//  File.swift
//  Parser
//
//  Created by Samuel Shi on 4/27/25.
//

import Foundation
import Testing
@testable import Parser

@Test
func functionCallNoArgs() async throws {
    var parser = Parser(source: "kick()")
    
    let actual = try parser.parseFunctionCall()
    let expected = FunctionCallSyntax(name: "kick", argument: nil)
    #expect(actual == expected)
}

@Test
func functionCallSingleArg() async throws {
    var parser = Parser(source: "hihat(open: true)")
    
    let actual = try parser.parseFunctionCall()
    let expected = FunctionCallSyntax(
        name: "hihat",
        argument: LabeledValueSyntax(
            label: "open",
            value: BoolExpressionSyntax(value: true)
        )
    )
    
    #expect(actual == expected)
}

@Test
func functionCallWithList() async throws {
    var parser = Parser(source: """
    Repeat(count: 4) {
        kick()
        snare()
    }
    """)
    
    let actual = try parser.parseFunctionCall()
    let expected = FunctionCallSyntax(
        name: "Repeat",
        argument: LabeledValueSyntax(
            label: "count",
            value: IntegerExpressionSyntax(value: 4)
        ),
        trailingList: FunctionCallListSyntax(
            functionCall: .init(name: "kick", argument: nil),
            next: FunctionCallListSyntax(
                functionCall: .init(name: "snare", argument: nil),
                next: nil
            )
        )
    )
    
    #expect(actual == expected)
}

@Test
func functionCallList() async throws {
    var parser = Parser(source: """
    kick()
    snare()
    kick()
    snare()
    """)
    
    let actual = try parser.parseFunctionCallList()
    let expected = FunctionCallListSyntax(
        functionCall: .init(name: "kick", argument: nil),
        next: FunctionCallListSyntax(
            functionCall: .init(name: "snare", argument: nil),
            next: FunctionCallListSyntax(
                functionCall: .init(name: "kick", argument: nil),
                next: FunctionCallListSyntax(
                    functionCall: .init(name: "snare", argument: nil),
                    next: nil
                )
            )
        )
    )
    
    #expect(actual == expected)
}
