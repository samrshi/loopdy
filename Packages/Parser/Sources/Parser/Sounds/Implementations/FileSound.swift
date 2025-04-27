////
////  File.swift
////  Parser
////
////  Created by Samuel Shi on 4/27/25.
////
//
//import AVFoundation
//import Foundation
//import Synchronization
//
//private actor State {
//    let playerCount: Int
//    let players: [AVAudioPlayer]
//    
//    var currentPlayer: Int
//
//    init(playerCount: Int, url: URL) {
//        self.playerCount = playerCount
//        self.players = (1...playerCount).compactMap { _ in
//            try? AVAudioPlayer(contentsOf: url)
//        }
//        
//        self.currentPlayer = 0
//    }
//    
//    func play() {
//        currentPlayer = (currentPlayer + 1) % playerCount
//        
//        let player = players[currentPlayer]
//        player.play()
//        player.currentTime = 0
//    }
//}
//
//struct FileSound: Sound {
//    private let state: State
//    
//    init?(syntax: FunctionCallSyntax) {
//        guard let url = Bundle.module.url(forResource: syntax.name.name, withExtension: "mp3") else {
//            return nil
//        }
//        
//        self.state = State(playerCount: 12, url: url)
//    }
//    
//    func play(in context: SoundContext) async throws {
//        await state.play()
//        try await Task.sleep(for: context.duration)
//    }
//}
