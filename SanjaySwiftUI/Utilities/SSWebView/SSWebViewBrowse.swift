//
//  SSWebViewBrowse.swift
//  SanjaySwiftUI
//
//  Created by Sanjay Sampat on 24/12/20.
//  Copyright © 2020 Sanjay Sampat. All rights reserved.
//

import SwiftUI

struct SSWebViewBrowse: View {
    @ObservedObject var ssWebViewModel = SSWebViewModel()

    @State private var showingAlert:Int = 0
    @State private var showSpinLoader = false
    @State private var siteStatus = ""
    @State var urlString = "https://apple.com"
    @State var isHtmlText = false
    @State var siteTitle = ""
    @State var showTitle = true
    @State var showNavigationBar = true

    // For WebView's refresh, forward and backward navigation
    var webViewNavigationBar: some View {
        VStack(spacing: 0) {
            Divider()
            HStack {
                Spacer()
                Button(action: {
                    // use alertSS to get urlString and will convert to new url
                    self.showingAlert = 1
                    self.alertSS(title: "URL", message: "Enter web address or html text", text: urlString )
                }) {
                    //Text("New")
                    Image(systemName: "cloud")
                        .font(.system(size: 20, weight: .regular))
                        .imageScale(.large)
                        .foregroundColor(.gray)
                }
                Group {
                    Spacer()
                    Divider()
                    Spacer()
                }
                
                Button(action: {
                    self.ssWebViewModel.webViewNavigationPublisher.send(.backward)
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .regular))
                        .imageScale(.large)
                        .foregroundColor(.gray)
                }
                Group {
                    Spacer()
                    Divider()
                    Spacer()
                }
                Button(action: {
                    self.ssWebViewModel.webViewNavigationPublisher.send(.forward)
                }) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 20, weight: .regular))
                        .imageScale(.large)
                        .foregroundColor(.gray)
                }
                Group {
                    Spacer()
                    Divider()
                    Spacer()
                }
                Button(action: {
                    self.ssWebViewModel.webViewNavigationPublisher.send(.reload)
                }) {
                    Image(systemName: "arrow.clockwise")
                        .font(.system(size: 20, weight: .regular))
                        .imageScale(.large)
                        .foregroundColor(.gray).padding(.bottom, 4)
                }
                Spacer()
            }.frame(height: 45)
            Divider()
        }
    }

    var body: some View {
        
        ZStack {
            let url = URL(string: urlString )
            
            VStack(spacing: 0) {
                
                Group {
                    if siteStatus.isEmpty {
                        EmptyView()
                    } else {
                        Text(siteStatus)
                            .font(.caption2)
                            .foregroundColor( ( siteStatus.starts(with: "Success") ? .primary : .red ) )
                            .lineLimit(nil)
                            .multilineTextAlignment(.center)
                        Divider()
                    }
                }
                .onReceive(self.ssWebViewModel.statusMessageFromSSWebView.receive(on: RunLoop.main)) { value in
                    self.siteStatus = value
                }
                
                if showTitle {
                    Text(siteTitle)
                        .font(.caption2)
                        .lineLimit(nil)
                        .multilineTextAlignment(.center)
                        .onReceive(self.ssWebViewModel.showWebTitle.receive(on: RunLoop.main)) { value in
                            self.siteTitle = value
                        }
                    Divider()
                }
                
                if isHtmlText {
                    SSWebView(ssWebViewModel: ssWebViewModel, htmlText: urlString )
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, idealHeight: 500, maxHeight: .infinity, alignment: .center)
                        .padding()
                } else {
                    SSWebView(ssWebViewModel: ssWebViewModel, publicUrlOpt: url )
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, idealHeight: 500, maxHeight: .infinity, alignment: .center)
                        .padding()
                }
                
                if showNavigationBar {
                    webViewNavigationBar
                }
                
            }
            
            if self.showSpinLoader {
                CircleSpinLoader("Loading ...")
            }
            
        }
        .onReceive(self.ssWebViewModel.showSpinLoader.receive(on: RunLoop.main)) { value in
            self.showSpinLoader = value
        }
        
    }

    private func showAlert(alert: UIAlertController) {
        if let controller = CommonUtils.topMostViewController() {
            controller.present(alert, animated: true)
        }
    }

    private func alertSS( title:String = "", message:String = "", placeHolder:String = "Enter text here", text:String = "" ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.text = text
            textField.placeholder = placeHolder
        }

        // nonEscaping closure
        alert.addAction(UIAlertAction(title: "Done", style: .default) { _ in
            
            let textField = alert.textFields![0] as UITextField
            if let textString = textField.text {
                formUrlString(urlString: textString)
            }
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default) { _ in })
        
        showAlert(alert: alert)
    }
    
    private func formUrlString( urlString : String) {
        var urlTextString = urlString
        if urlTextString.lowercased().starts(with: "http://") {
            let indexStartOfText = urlTextString.index(urlTextString.startIndex, offsetBy: 7)
            let substring = urlTextString[indexStartOfText...]
            urlTextString = String(substring)
        }
        if !urlTextString.isEmpty {
            self.isHtmlText = false
            if urlTextString.lowercased().starts(with: "<html>") {
                let indexStartOfText = urlTextString.index(urlTextString.startIndex, offsetBy: 6)
                let substring = urlTextString[indexStartOfText...]
                let headerString = "<html><header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=5.0, minimum-scale=0.5, user-scalable=yes'><meta name='color-scheme' content='dark light'></header>"
                urlTextString = headerString + String(substring)
                self.isHtmlText = true
            } else if !urlTextString.lowercased().starts(with: "http") {
                urlTextString = "https://\(urlTextString)"
            }
            self.ssWebViewModel.statusMessageFromSSWebView.send("")
            self.urlString = urlTextString
        }
    }

}

struct SSWebViewBrowse_Previews: PreviewProvider {
    static var previews: some View {
        SSWebViewBrowse()
    }
}
