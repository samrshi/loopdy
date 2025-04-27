//
//  CodeEditor.swift
//  NewMusicCode
//
//  Created by Samuel Shi on 4/27/25.
//

import Runestone
import SwiftUI

struct CodeEditor: UIViewRepresentable {
    @Binding var code: String
    
    func makeCoordinator() -> Coordinator { Coordinator(code: $code) }
    
    func makeUIView(context: Context) -> TextView {
        let textView = TextView(frame: .zero)
        textView.editorDelegate = context.coordinator
        textView.setState(TextViewState(text: code))
        
        let insets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        textView.textContainerInset = insets
        
        textView.showLineNumbers = true
        textView.lineHeightMultiplier = 1.2
        textView.kern = 0
        textView.isLineWrappingEnabled = false
        textView.showPageGuide = true
        textView.pageGuideColumn = 80
        textView.autocorrectionType = .no
        textView.autocapitalizationType = .none
        textView.smartQuotesType = .no
        textView.smartDashesType = .no
        textView.backgroundColor = .systemBackground
        
        textView.indentStrategy = .space(length: 4)
        return textView
    }
    
    // TODO: Runestone style "Col 1 Line 2" view. But, you can drag from it to move the cursor like a trackpad??
    
    func updateUIView(_ textView: TextView, context: Context) {
        textView.setState(TextViewState(text: code))
    }
    
    @MainActor
    class Coordinator: NSObject, @preconcurrency TextViewDelegate {
        @Binding var code: String
        
        init(code: Binding<String>) {
            self._code = code
        }
        
        func textViewDidChange(_ textView: TextView) {
            code = textView.text
        }
    }
}
