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

    @State var showSpinLoader = false
    @State var siteTitle = ""

    // For WebView's refresh, forward and backward navigation
    var webViewNavigationBar: some View {
        VStack(spacing: 0) {
            Divider()
            HStack {
                Spacer()
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
            let url = URL(string: "https://www.dgflick.com")
            
            VStack(spacing: 0) {
                
                Text(siteTitle)
                    .font(.caption2)
                    .lineLimit(nil)
                    .multilineTextAlignment(.center)
                    .onReceive(self.ssWebViewModel.showWebTitle.receive(on: RunLoop.main)) { value in
                    self.siteTitle = value
                }
                Divider()

                SSWebView(ssWebViewModel: ssWebViewModel, publicUrlOpt: url )
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, idealHeight: 500, maxHeight: .infinity, alignment: .center)
                    .padding()

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
}

struct SSWebViewBrowse_Previews: PreviewProvider {
    static var previews: some View {
        SSWebViewBrowse()
    }
}
