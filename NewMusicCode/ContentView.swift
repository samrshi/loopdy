//
//  ContentView.swift
//  NewMusicCode
//
//  Created by Samuel Shi on 4/26/25.
//

import SwiftUI
@testable import Parser

struct FunctionCallView: View {
    @State private var expanded = true
    let functionCall: FunctionCallSyntax
    
    var body: some View {
        if let trailingList = functionCall.trailingList {
            DisclosureGroup("\(functionCall.name)", isExpanded: $expanded) {
                ForEach(trailingList.list, id: \.description) {
                    FunctionCallView(functionCall: $0)
                }
            }
        } else {
            Text("\(functionCall)")
        }
    }
}

struct ContentView: View {
    @State private var bpm = 120.0
    
    @State private var sounds: [Sound] = []
    @State private var errorMessage: String? = nil
    
    @State private var currentTask: Task<Void, Never>? = nil
    
    @State private var code: String = """
    Repeat(count: 4) {
        kick()
        hihat(open: false)
        snare()
    
        Subdivide(by: 0.5) {
            hihat(open: false)
            hihat(open: true)
        }
    }
    """
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                CodeEditor(code: $code)
                
                if let errorMessage {
                    Text(errorMessage)
                        .font(.footnote)
                        .fontWeight(.bold)
                        .foregroundStyle(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .background(.red.opacity(0.15), in: .rect(cornerRadius: 8))
                        .padding()
                        .transition(
                            .move(edge: .bottom)
                                .combined(with: .offset(x: 0, y: 15))
                                .combined(with: .scale(0.8))
                        )
                        .zIndex(1)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Music Editor")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        if let current = currentTask {
                            current.cancel()
                            currentTask = nil
                        } else {
                            currentTask = Task.detached {
                                let context = await SoundContext(bpm: bpm)
                                
                                for sound in await sounds {
                                    try? await sound.play(in: context)
                                }
                                
                                await stop()
                            }
                        }
                    } label: {
                        if currentTask != nil {
                            Label("Pause", systemImage: "pause.fill")
                        } else {
                            Label("Play", systemImage: "play.fill")
                        }
                    }
                    .disabled(sounds.isEmpty)
                }
            }
            .onChange(of: code, initial: true) {
                do {
                    stop()
                    
                    var parser = Parser(source: code)
                    let functionCalls = try parser.parseFunctionCallList()
                        
                    self.sounds = functionCalls.list.compactMap { $0.sound }
                        
                    if errorMessage != nil {
                        withAnimation { self.errorMessage = nil }
                    }
                } catch {
                    sounds = []
                    withAnimation { errorMessage = error.localizedDescription }
                }
            }
        }
    }
    
    func stop() {
        currentTask?.cancel()
        currentTask = nil
    }
}

#Preview {
    ContentView()
}
