//
//  File.swift
//  Parser
//
//  Created by Samuel Shi on 4/27/25.
//

import Foundation

struct RepeatSound: Sound {
    var count: Int?
    var sounds: [Sound] = []
    
    init?(syntax: FunctionCallSyntax) {
        guard
            syntax.name == "Repeat",
            let trailingList = syntax.trailingList
        else { return nil }
        
        if let argument = syntax.argument {
            if argument.label == "count",
               let count = argument.value.as(IntegerExpressionSyntax.self)
            {
                self.count = count.value
            } else {
                return nil
            }
        }
        
        for syntax in trailingList.list {
            if let sound = syntax.sound {
                sounds.append(sound)
            } else {
                return nil
            }
        }
    }
    
    func play(in context: SoundContext) async throws {
        if let count {
            for _ in 0..<count {
                for sound in sounds {
                    try await sound.play(in: context)
                }
            }
        } else {
            while !Task.isCancelled {
                for sound in sounds {
                    try await sound.play(in: context)
                }
            }
        }
    }
}
