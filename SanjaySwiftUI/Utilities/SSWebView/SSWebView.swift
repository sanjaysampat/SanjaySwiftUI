//
//  SSWebView.swift
//  SanjaySwiftUI
//
//  Created by Sanjay Sampat on 17/12/20.
//  Copyright © 2020 Sanjay Sampat. All rights reserved.
//

import SwiftUI
import WebKit
import Combine

// MARK: - WebViewHandlerDelegate
// For values received from web app
protocol WebViewHandlerDelegate {
    func receivedJsonValueFromWebView(value: [String: Any?])
    func receivedStringValueFromWebView(value: String)
}

struct SSWebView: UIViewRepresentable, WebViewHandlerDelegate {
    
    func receivedJsonValueFromWebView(value: [String : Any?]) {
        print("JSON value received from site is: \(value)")
    }
    
    func receivedStringValueFromWebView(value: String) {
        print("String value received from site is: \(value)")
    }

    let htmlText: String
    let localFileUrlOpt:URL?
    let localUrlFolderForReadAccessOpt:URL?
    let publicUrlOpt:URL?
    
    // Observable SSWebViewModel object
    @ObservedObject var ssWebViewModel: SSWebViewModel

    /**
     - Parameter publicUrlOpt: optional : create it as url = URL(string: "https://www.dgflick.com")
     - Parameter localFileUrlOpt OR localUrlFolderForReadAccessOpt: optional : create it as url = Bundle.main.url(forResource: "LocalPageInBundle", withExtension: "html", subdirectory: "localSite")
     */
    init( ssWebViewModel:SSWebViewModel, htmlText: String = "", localFileUrlOpt: URL? = nil, localUrlFolderForReadAccessOpt: URL? = nil, publicUrlOpt: URL? = nil ) {
        self.ssWebViewModel = ssWebViewModel
        self.htmlText = htmlText
        self.localFileUrlOpt = localFileUrlOpt
        self.localUrlFolderForReadAccessOpt = localUrlFolderForReadAccessOpt
        self.publicUrlOpt = publicUrlOpt
    }
    
    // Coordinator to co-ordinate with WKWebView's delegate methods
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> WKWebView {
        // Enable javascript in WKWebView
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        
        let configuration = WKWebViewConfiguration()
        configuration.userContentController.add(self.makeCoordinator(), name: "ssFromiOSApp")
        configuration.preferences = preferences
        
        let uiView = WKWebView(frame: CGRect.zero, configuration: configuration)
        uiView.navigationDelegate = context.coordinator
        uiView.allowsBackForwardNavigationGestures = true
        uiView.scrollView.isScrollEnabled = true
        return uiView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        if !htmlText.isEmpty {
            uiView.loadHTMLString(htmlText, baseURL: nil)
        } else if let localFileUrl = localFileUrlOpt {
            let readAccessToUrl = localUrlFolderForReadAccessOpt ?? localFileUrl.deletingLastPathComponent()
            uiView.loadFileURL(localFileUrl, allowingReadAccessTo: readAccessToUrl)
        } else if let publicUrl = publicUrlOpt {
            uiView.load(URLRequest(url: publicUrl))
        }
    }
    
    class Coordinator : NSObject, WKNavigationDelegate {
        var parent: SSWebView
        var delegate: WebViewHandlerDelegate?
        var valueSubscriber: AnyCancellable? = nil
        var webViewNavigationSubscriber: AnyCancellable? = nil
        
        init(_ ssWebView: SSWebView) {
            self.parent = ssWebView
            self.delegate = parent
        }
        
        deinit {
            valueSubscriber?.cancel()
            webViewNavigationSubscriber?.cancel()
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            // Get the title of loaded webcontent
            webView.evaluateJavaScript("document.title") { (response, error) in
                if let error = error {
                    print("Error getting title")
                    print(error.localizedDescription)
                }
                
                guard let title = response as? String else {
                    return
                }
                
                self.parent.ssWebViewModel.showWebTitle.send(title)
            }
            
            /* Observer that observes 'ssWebViewModel.valuePublisher' to pass the value to web app by calling JavaScript function */
            valueSubscriber = parent.ssWebViewModel.valuePublisher
                .receive(on: RunLoop.main)
                .sink(receiveValue: { value in
                    let javascriptFunction = "valueGotFromIOS(\(value));"
                    webView.evaluateJavaScript(javascriptFunction) { (response, error) in
                        if let error = error {
                            print("Error calling javascript:valueGotFromIOS()")
                            print(error.localizedDescription)
                        } else {
                            print("Called javascript:valueGotFromIOS()")
                        }
                    }
                })
            
            // Page loaded so no need to show loader anymore
            self.parent.ssWebViewModel.showSpinLoader.send(false)
        }
        
        // WKWebView's delegate functions
        
        func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
            // Hides loader
            parent.ssWebViewModel.showSpinLoader.send(false)
        }
        
        
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            // Hides loader
            parent.ssWebViewModel.showSpinLoader.send(false)
        }
        
        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            // Hides loader
            parent.ssWebViewModel.showSpinLoader.send(false)
        }

        func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
            // Shows loader
            parent.ssWebViewModel.showSpinLoader.send(true)
        }
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            // Shows loader
            parent.ssWebViewModel.showSpinLoader.send(true)
            self.webViewNavigationSubscriber = self.parent.ssWebViewModel.webViewNavigationPublisher.receive(on: RunLoop.main).sink(receiveValue: { navigation in
                switch navigation {
                    case .backward:
                        if webView.canGoBack {
                            webView.goBack()
                        }
                    case .forward:
                        if webView.canGoForward {
                            webView.goForward()
                        }
                    case .reload:
                        webView.reload()
                }
            })
        }
        
        // Function for intercepting every navigation in the webview
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            // Get information about new url from 'navigationAction.request.description'
            if let host = navigationAction.request.url?.host {
                // If don't want to go to a site 'notToAllow.com'
                if host == "notToAllow.com" {
                    // Cancels the navigation
                    decisionHandler(.cancel)
                    return
                }
            }
            // Allows the navigation
            decisionHandler(.allow)
        }
    }
}

// MARK: - Extensions
extension SSWebView.Coordinator: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        // Your set delegate "ssFromiOSApp" is called
        if message.name == "ssFromiOSApp" {
            if let body = message.body as? [String: Any?] {
                delegate?.receivedJsonValueFromWebView(value: body)
            } else if let body = message.body as? String {
                delegate?.receivedStringValueFromWebView(value: body)
            }
        }
    }
}
