import AudioKit
import AVFoundation

enum Drum {
    case hiHatOpen, hiTom, midTom, loTom, hiHat, clap, snare, kick
}

struct DrumSample {
    var name: String
    var fileName: String
    var midiNote: Int
    var audioFile: AVAudioFile?

    init(_ prettyName: String, file: String, note: Int) {
        name = prettyName
        fileName = file
        midiNote = note

        guard let url = Bundle.module.resourceURL?.appendingPathComponent(file) else { return }
        do {
            audioFile = try AVAudioFile(forReading: url)
        } catch {
            Log("Could not load: \(fileName)")
        }
    }
}

class DrumsConductor: HasAudioEngine {
    let engine = AudioEngine()

    let drumSamples: [Drum : DrumSample] =
        [
            .hiHatOpen: DrumSample("OPEN HI HAT", file: "Samples/open_hi_hat_A#1.wav", note: 34),
            .hiTom: DrumSample("HI TOM", file: "Samples/hi_tom_D2.wav", note: 38),
            .midTom: DrumSample("MID TOM", file: "Samples/mid_tom_B1.wav", note: 35),
            .loTom: DrumSample("LO TOM", file: "Samples/lo_tom_F1.wav", note: 29),
            .hiHat: DrumSample("HI HAT", file: "Samples/closed_hi_hat_F#1.wav", note: 30),
            .clap: DrumSample("CLAP", file: "Samples/clap_D#1.wav", note: 27),
            .snare: DrumSample("SNARE", file: "Samples/snare_D1.wav", note: 26),
            .kick: DrumSample("KICK", file: "Samples/bass_drum_C1.wav", note: 24),
        ]

    let drums = AppleSampler()

    func play(drum: Drum) {
        guard let sample = drumSamples[drum] else { fatalError() }
        drums.play(noteNumber: MIDINoteNumber(sample.midiNote))
    }

    init() {
        engine.output = drums
        do {
            let files = drumSamples.map {
                $0.value.audioFile!
            }
            try drums.loadAudioFiles(files)

        } catch {
            Log("Files Didn't Load")
        }
        
        start()
    }
    
    deinit {
        stop()
    }
}

actor Drums {
    static let shared = Drums()
    
    let conductor = DrumsConductor()
    
    func play(drum: Drum) {
        conductor.play(drum: drum)
    }
}
