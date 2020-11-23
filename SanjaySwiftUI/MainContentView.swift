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
                VStack {
                    Button(action: {
                        // simple animation
                        withAnimation{
                            self.showContentView.toggle()
                        }
                    }) {
                        Text("Start the SwiftUI")
                    }

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
 different progressview indicators - https://stackoverflow.com/a/59056440/2641380
 
 
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
 
 pushnotifications
 // SSTODO (MenuView) to create views to show list of local notifications and to create new local notification
 
 use new Views lazy grid/stack
 
 how to create App clip
 
 edit photos via system photo library
 
 long running background tasks
 
 use of example swift package
 
 to check
  https://www.raywenderlich.com/1484288-preventing-man-in-the-middle-attacks-in-ios-with-ssl-pinning
 
 Round specific corners for any side
 https://stackoverflow.com/a/58606176/2641380
 
 MKPointAnnotation - Map - How to call a function or tell if Annotation Point is clicked on.
 https://stackoverflow.com/q/64950827/2641380
 
 iOS Charts - How to get highlighted value
 https://stackoverflow.com/q/64948971/2641380
 
 */
