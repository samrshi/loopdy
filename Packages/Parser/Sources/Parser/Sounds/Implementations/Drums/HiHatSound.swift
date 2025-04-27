//
//  File.swift
//  Parser
//
//  Created by Samuel Shi on 4/27/25.
//

import Foundation

struct HiHatSound: Sound {
    let open: Bool
    
    init?(syntax: FunctionCallSyntax) {
        guard
            syntax.name == "hihat",
            let argument = syntax.argument,
            argument.label == "open",
            let open = argument.value.as(BoolExpressionSyntax.self)
        else {
            return nil
        }
        
        self.open = open.value
    }
    
    func play(in context: SoundContext) async throws {
        await Drums.shared.play(drum: open ? .hiHatOpen : .hiHat)
        try await Task.sleep(for: context.duration)
    }
}
