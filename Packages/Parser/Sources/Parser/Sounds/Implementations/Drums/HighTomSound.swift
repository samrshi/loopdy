//
//  File.swift
//  Parser
//
//  Created by Samuel Shi on 4/27/25.
//

import Foundation

struct HighTomSound: Sound {
    init?(syntax: FunctionCallSyntax) {
        guard syntax.name == "highTom", syntax.argument == nil else {
            return nil
        }
    }
    
    func play(in context: SoundContext) async throws {
        await Drums.shared.play(drum: .hiTom)
        try await Task.sleep(for: context.duration)
    }
}
