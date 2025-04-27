//
//  ParseError.swift
//  NewMusicCode
//
//  Created by Samuel Shi on 4/27/25.
//

import Foundation

struct ParseError: LocalizedError {
    let reason: String
    
    var errorDescription: String? { reason }
}

extension ParseError {
    static var outOfTokens: ParseError {
        ParseError(reason: "Unexpectedly ran out of tokens.")
    }
}
