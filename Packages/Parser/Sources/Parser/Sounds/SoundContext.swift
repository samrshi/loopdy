//
//  File.swift
//  Parser
//
//  Created by Samuel Shi on 4/27/25.
//

import Foundation

struct SoundContext {
    var bpm: Double
    var duration: Duration { .seconds(60.0 / bpm) }
}
