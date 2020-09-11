//
//  TabSwiftUiView.swift
//  SanjaySwiftUI
//
//  Created by Sanjay Sampat on 30/08/20.
//  Copyright © 2020 Sanjay Sampat. All rights reserved.
//

import SwiftUI

struct TabSwiftUiView: View {
    
    @State private var localeLanguage:String = "Localizable"
    
    var body: some View {
        TabView {
            LocalDemoView(localeLanguage: "Localizable")
                .onTapGesture {
                    self.localeLanguage = "Localizable"
                }
                .tabItem {
                    Image(systemName: "1.square.fill")
                    Text("Default")
                }
            LocalDemoView(localeLanguage: "LocalGujarati")
                .onTapGesture {
                    self.localeLanguage = "LocalGujarati"
                }
                .tabItem {
                    Image(systemName: "2.square.fill")
                    Text("ગુજરાતી")
                }
            LocalDemoView(localeLanguage: "LocalMarathi")
                .onTapGesture {
                    self.localeLanguage = "LocalMarathi"
                }
                .tabItem {
                    Image(systemName: "3.square.fill")
                    Text("मराठी")
                }
            LocalDemoView(localeLanguage: "LocalArabic")
                .onTapGesture {
                    self.localeLanguage = "LocalArabic"
                }
                .tabItem {
                    Image(systemName: "4.square.fill")
                    Text("عربى")
                }
        }
        .font(.headline)
    }
    
}

struct TabSwiftUiView_Previews: PreviewProvider {
    static var previews: some View {
        TabSwiftUiView()
    }
}
