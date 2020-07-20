//
//  ContentView.swift
//  SanjaySwiftUI
//
//  Created by Sanjay Sampat on 20/07/20.
//  Copyright © 2020 Sanjay Sampat. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack() {
            Rectangle()
                .scale(1.25)
                .rotation(Angle(degrees: -45))
                .edgesIgnoringSafeArea(.all)
                .opacity(0.15)
            
            
            Image(systemName: "heart")
                .resizable(resizingMode: .stretch)
                .rotationEffect(Angle(degrees: -45))
                .scaledToFit()
                .foregroundColor(Color.pink)
                .opacity(0.75)

            VStack() {
                Spacer()
                Text("My Name in Heart")
                    .font(.title)
                    //.fontWeight(.thin)
                    .foregroundColor(Color.pink)
                    .rotationEffect(Angle(degrees: -45))

                Spacer()
                
                }
        }
        .background(Color.blue)
        .edgesIgnoringSafeArea(.all)
    
    
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
