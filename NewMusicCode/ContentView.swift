//
//  ContentView.swift
//  NewMusicCode
//
//  Created by Samuel Shi on 4/26/25.
//

import SwiftUI
@testable import Parser

struct ContentView: View {
    @State private var fileName: String = "rock-drums.song"
    @State private var functionCall: FunctionCallSyntax? = nil
    @State private var errorMessage: String? = nil
    
    @State private var code: String = """
    """
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    CodeEditor(code: $code)
                        .frame(height: 250)
                } footer: {
                    if let errorMessage {
                        Text(errorMessage)
                            .font(.footnote)
                            .fontWeight(.bold)
                            .foregroundStyle(.red)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(.red.opacity(0.15), in: .rect(cornerRadius: 8))
                            .listRowInsets(EdgeInsets())
                            .padding(.top, 8)
                    }
                }
                
                if let errorMessage {
                    Section("Error") {
                        Text("🛑 \(errorMessage)")
                            .fontDesign(.monospaced)
                            .font(.footnote)
                    }
                }
                
                if let functionCall {
                    Section("Function") {
                        Text("\(functionCall)")
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle($fileName)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        // play
                    } label: {
                        Label("Play", systemImage: "play.fill")
                    }
                }
                    
                ToolbarItem(placement: .bottomBar) {
                    Button("Hi") {}
                }
            }
            .onChange(of: code, initial: true) {
                do {
                    var parser = Parser(source: code)
                    functionCall = try parser.parseFunctionCall()
                    errorMessage = nil
                } catch {
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
