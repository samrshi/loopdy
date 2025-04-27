//
//  File.swift
//  Parser
//
//  Created by Samuel Shi on 4/27/25.
//

import Foundation
import AudioToolbox

struct SystemSound: Sound {
    var soundID: SystemSoundID
    
    init?(syntax: FunctionCallSyntax) {
        if syntax.name == "system",
           let argument = syntax.argument,
           argument.label.name == "id",
           let soundID = argument.value.as(IntegerExpressionSyntax.self)
        {
            self.soundID = SystemSoundID(soundID.value)
        } else {
            return nil
        }
    }
    
    func play(in context: SoundContext) async throws {
        AudioServicesPlaySystemSound(soundID)
        try await Task.sleep(for: context.duration)
    }
}
