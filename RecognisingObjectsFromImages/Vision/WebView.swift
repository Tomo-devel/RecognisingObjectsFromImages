//
//  WebView.swift
//  RecognisingObjectsFromImages
//
//  Created by 井上智輝 on 2023-03-16.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let url: String
    
    func makeUIView(context: Context) -> WKWebView {
           WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let url = URL(string: url) else {
            return
        }
        
        uiView.load(URLRequest(url: url))
    }
}
