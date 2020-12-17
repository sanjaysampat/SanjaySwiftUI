//
//  SSWebView.swift
//  SanjaySwiftUI
//
//  Created by Sanjay Sampat on 17/12/20.
//  Copyright © 2020 Sanjay Sampat. All rights reserved.
//

import SwiftUI
import WebKit

struct SSWebView: UIViewRepresentable {
    let htmlText: String
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.loadHTMLString(htmlText, baseURL: nil)
    }
}
