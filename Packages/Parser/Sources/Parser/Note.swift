//
//  Note.swift
//  NewMusicCode
//
//  Created by Samuel Shi on 4/27/25.
//

import Foundation

/// Representation of a music note.
/// Examples: `Ab4`, `C5`, `D#3`
struct Note: Equatable {
    let letter: Letter
    let accidental: Accidental?
    let octave: Int
    
    init?(letter: Character, accidental: Character?, octave: Int) {
        if let letter = Letter(letter) {
            self.letter = letter
            self.accidental = accidental.flatMap { Accidental($0) }
            self.octave = octave
        } else {
            return nil
        }
    }
    
    init(letter: Letter, accidental: Accidental? = nil, octave: Int) {
        self.letter = letter
        self.accidental = accidental
        self.octave = octave
    }
}

extension Note {
    enum Accidental: CustomStringConvertible, Equatable {
        case sharp, flat
        
        init?(_ character: Character) {
            switch character {
            case "#": self = .sharp
            case "b": self = .flat
            default: return nil
            }
        }
        
        var description: String {
            switch self {
            case .sharp: "#"
            case .flat: "b"
            }
        }
    }
    
    enum Letter: CustomStringConvertible, Equatable {
        case a, b, c, d, e, f, g
        
        init?(_ character: Character) {
            switch character {
            case "a", "A": self = .a
            case "b", "B": self = .b
            case "c", "C": self = .c
            case "d", "D": self = .d
            case "e", "E": self = .e
            case "f", "F": self = .f
            case "g", "G": self = .g
            default: return nil
            }
        }
        
        var description: String {
            switch self {
            case .a: "A"
            case .b: "B"
            case .c: "C"
            case .d: "D"
            case .e: "E"
            case .f: "F"
            case .g: "G"
            }
        }
    }
}

extension Note: CustomStringConvertible {
    var description: String {
        "\(letter)\(accidental?.description ?? "")\(octave)"
    }
}
