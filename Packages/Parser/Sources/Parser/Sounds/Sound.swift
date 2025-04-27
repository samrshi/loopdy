//
//  File.swift
//  Parser
//
//  Created by Samuel Shi on 4/27/25.
//

import Foundation

protocol Sound: Sendable {
    init?(syntax: FunctionCallSyntax)
    func play(in context: SoundContext) async throws
}

extension FunctionCallSyntax {
    var sound: Sound? {
        let makers: [(FunctionCallSyntax) -> Sound?] = [
            SystemSound.init,
            RepeatSound.init,
            SubdivideSound.init,
            KickSound.init,
            SnareSound.init,
            HiHatSound.init,
            LowTomSound.init,
            HighTomSound.init,
        ]
        
        for maker in makers {
            if let sound = maker(self) {
                return sound
            }
        }
        
        print("Failed to create sound for \(self)")
        return nil
    }
}
