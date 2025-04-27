//
//  File.swift
//  Parser
//
//  Created by Samuel Shi on 4/27/25.
//

import Foundation

struct SubdivideSound: Sound {
    var subdivision: Double
    var sounds: [Sound] = []
    
    init?(syntax: FunctionCallSyntax) {
        guard
            syntax.name == "Subdivide",
            let argument = syntax.argument,
            argument.label == "by",
            let subdivision = argument.value.as(DoubleExpressionSyntax.self),
            let trailingList = syntax.trailingList
        else { return nil }
        
        self.subdivision = subdivision.value
        
        for syntax in trailingList.list {
            if let sound = syntax.sound {
                sounds.append(sound)
            } else {
                return nil
            }
        }
    }
    
    func play(in context: SoundContext) async throws {
        var context = context
        context.bpm /= subdivision
        
        for sound in sounds {
            try await sound.play(in: context)
        }
    }
}
