//
//  mainContentView.swift
//  SanjaySwiftUI
//
//  Created by Sanjay Sampat on 24/10/20.
//  Copyright © 2020 Sanjay Sampat. All rights reserved.
//

import SwiftUI

struct MainContentView: View {
    
    @State var showContentView:Bool = false
    
    var body: some View {
        ZStack {
            if self.showContentView {
                //MenuView(menuSelection: $menuSelection, currentPos: $currentPos)
                ContentView(showContentView: $showContentView)
            } else {
                Button(action: {
                    // simple animation
                    withAnimation{
                        self.showContentView.toggle()
                    }
                }) {
                    Text("Start the SwiftUI")
                }
            }
            
            RecordFloatingMenuView()
        }
    }
}

struct mainContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainContentView()
    }
}
