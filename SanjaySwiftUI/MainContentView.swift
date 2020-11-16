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


/*
 // SSTODO in SwiftUI project.
 
 Show progress with - ProgressView("Text", value: 10, total: 100)
 
 to use image as background
 Text("Hello World")
     .font(.largeTitle)
     .background(
         Image("hello_world")
             .resizable()
             .frame(width: 100, height: 100)
     )
 
 or gradiant background
 .background(
     LinearGradient(
         gradient: Gradient(colors: [.white, .red, .black]),
         startPoint: .leading,
         endPoint: .trailing
     ),
     cornerRadius: 0
 )
 
 
 onChange - listen to state changes and perform actions on a view accordingly.
 TextEditor(text: $currentText)
                 .onChange(of: clearText) { value in
                     if clearText{
                         currentText = ""
                     }
                 }
 
 pushnotifications, localnotifications in SwiftUIViewApp
 
 use new Views lazy grid/stack
 
 how to create App clip
 
 edit photos via system photo library
 
 long running background tasks
 
 use of example swift package
 
  
 */
