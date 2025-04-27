//
//  TokenizerTests.swift
//  NewMusicCodeTests
//
//  Created by Samuel Shi on 4/26/25.
//

import Foundation
import Testing
@testable import Parser

@Test(arguments: [
    Note(letter: .a, accidental: .flat, octave: 4),
    Note(letter: .b, octave: 2)
])
func testNoteLiteral(
    note: Note
) {
    let note = Token.noteLiteral(note)
    var iterator = TokenIterator(source: note.text)
    
    #expect(iterator.next() == note)
    #expect(iterator.next() == nil)
}

@Test(arguments: [0.0, 12.12, 234.0])
func testDoubleLiteral(value: Double) async throws {
    var iterator = TokenIterator(source: "\(value)")
    #expect(iterator.next() == .doubleLiteral(value))
    #expect(iterator.next() == nil)
}

@Test(arguments: [true, false])
func testDoubleLiteral(value: Bool) async throws {
    var iterator = TokenIterator(source: "\(value)")
    #expect(iterator.next() == .boolLiteral(value))
    #expect(iterator.next() == nil)
}

@Test(arguments: [0, 234, 10923, 23])
func testDoubleLiteral(value: Int) async throws {
    var iterator = TokenIterator(source: "\(value)")
    #expect(iterator.next() == .intLiteral(value))
    #expect(iterator.next() == nil)
}

@Test(arguments: ["bass", "kick", "yooo"])
func testDoubleLiteral(value: String) async throws {
    var iterator = TokenIterator(source: value)
    #expect(iterator.next() == .identifier(value))
    #expect(iterator.next() == nil)
}

@Test(arguments: [
    // Whitespace
    Token.space,
    Token.newline,
    
    // Punctuation
    Token.openParen,
    Token.closeParen,
    Token.openCurly,
    Token.closeCurly,
    Token.colon,
    Token.comma,
])
func testEverythingElse(token: Token) {
    var iterator = TokenIterator(source: token.text)
    #expect(iterator.next() == token)
    #expect(iterator.next() == nil)
}
