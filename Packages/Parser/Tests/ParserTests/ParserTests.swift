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
