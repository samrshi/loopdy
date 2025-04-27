//
//  File.swift
//  Parser
//
//  Created by Samuel Shi on 4/27/25.
//

import Foundation

struct LowTomSound: Sound {
    init?(syntax: FunctionCallSyntax) {
        guard syntax.name == "lowTom", syntax.argument == nil else {
            return nil
        }
    }
    
    func play(in context: SoundContext) async throws {
        await Drums.shared.play(drum: .loTom)
        try await Task.sleep(for: context.duration)
    }
}
