//
//  SSWebViewModel.swift
//  SanjaySwiftUI
//
//  Created by Sanjay Sampat on 18/12/20.
//  Copyright © 2020 Sanjay Sampat. All rights reserved.
//

import Foundation
import Combine

class SSWebViewModel: ObservableObject {
    var webViewNavigationPublisher = PassthroughSubject<WebViewNavigation, Never>()
    var showWebTitle = PassthroughSubject<String, Never>()
    var showSpinLoader = PassthroughSubject<Bool, Never>()
    var valuePublisher = PassthroughSubject<String, Never>()
}

// For identifiying WebView's forward and backward navigation
enum WebViewNavigation {
    case backward, forward, reload
}

