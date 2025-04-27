//
//  TokenizerTests.swift
//  NewMusicCodeTests
//
//  Created by Samuel Shi on 4/26/25.
//

import Foundation
import Testing
@testable import NewMusicCode

@Test(arguments: [
    ("A", NoteAccidental.flat, 4),
    ("B", nil, 2),
])
func testNoteLiteral(
    details: (Character, NoteAccidental?, Int)
) {
    let note = Token.noteLiteral(details.0, details.1, details.2)
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
