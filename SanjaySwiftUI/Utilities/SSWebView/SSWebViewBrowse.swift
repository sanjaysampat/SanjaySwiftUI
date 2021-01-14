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
    @State private var siteTitle = ""
    @State var urlString = "https://www.dgflick.com"
    @State var isHtmlText = false

    // For WebView's refresh, forward and backward navigation
    var webViewNavigationBar: some View {
        VStack(spacing: 0) {
            Divider()
            HStack {
                Spacer()
                Button(action: {
                    // SSTODO to add button to get new url from user.
                    // change urlString to new url
                    // use alertSS
                    self.showingAlert = 1
                    self.alertSS(title: "URL", message: "Enter", text: urlString )
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
                
                Text(siteTitle)
                    .font(.caption2)
                    .lineLimit(nil)
                    .multilineTextAlignment(.center)
                    .onReceive(self.ssWebViewModel.showWebTitle.receive(on: RunLoop.main)) { value in
                    self.siteTitle = value
                }
                Divider()

                if isHtmlText {
                    SSWebView(ssWebViewModel: ssWebViewModel, htmlText: urlString )
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, idealHeight: 500, maxHeight: .infinity, alignment: .center)
                        .padding()
                } else {
                SSWebView(ssWebViewModel: ssWebViewModel, publicUrlOpt: url )
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, idealHeight: 500, maxHeight: .infinity, alignment: .center)
                    .padding()
                }
                webViewNavigationBar
                
            }
            
            if self.showSpinLoader {
                CircleSpinLoader("Loading ...")
            }
            
        }
        .onReceive(self.ssWebViewModel.showSpinLoader.receive(on: RunLoop.main)) { value in
            self.showSpinLoader = value
        }
        
    }
    
    private func alertSS( title:String = "", message:String = "", placeHolder:String = "Enter text here", text:String = "" ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.text = text
            textField.placeholder = placeHolder
        }

        alert.addAction(UIAlertAction(title: "Done", style: .default) { _ in
            
            let textField = alert.textFields![0] as UITextField
            if let textString = textField.text {
                var urlTextString = textString
                if urlTextString.lowercased().starts(with: "http://") {
                    let indexStartOfText = urlTextString.index(urlTextString.startIndex, offsetBy: 7)
                    let substring = urlTextString[indexStartOfText...]
                    urlTextString = String(substring)
                }
                if !urlTextString.isEmpty {
                if urlTextString.lowercased().starts(with: "<html>") {
                    self.urlString = urlTextString
                    self.isHtmlText = true
                } else if !urlTextString.lowercased().starts(with: "http") {
                    urlTextString = "https://\(urlTextString)"
                }
                    self.urlString = urlTextString
                    self.isHtmlText = false
                }
            }
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default) { _ in })
        
        showAlert(alert: alert)
    }

    private func showAlert(alert: UIAlertController) {
        if let controller = topMostViewController() {
            controller.present(alert, animated: true)
        }
    }
    
    private func keyWindow() -> UIWindow? {
        return UIApplication.shared.connectedScenes
        .filter {$0.activationState == .foregroundActive}
        .compactMap {$0 as? UIWindowScene}
        .first?.windows.filter {$0.isKeyWindow}.first
    }
    
    private func topMostViewController() -> UIViewController? {
        guard let rootController = keyWindow()?.rootViewController else {
            return nil
        }
        return topMostViewController(for: rootController)
    }

    private func topMostViewController(for controller: UIViewController) -> UIViewController {
        if let presentedController = controller.presentedViewController {
            return topMostViewController(for: presentedController)
        } else if let navigationController = controller as? UINavigationController {
            guard let topController = navigationController.topViewController else {
                return navigationController
            }
            return topMostViewController(for: topController)
        } else if let tabController = controller as? UITabBarController {
            guard let topController = tabController.selectedViewController else {
                return tabController
            }
            return topMostViewController(for: topController)
        }
        return controller
    }

}

struct SSWebViewBrowse_Previews: PreviewProvider {
    static var previews: some View {
        SSWebViewBrowse()
    }
}
