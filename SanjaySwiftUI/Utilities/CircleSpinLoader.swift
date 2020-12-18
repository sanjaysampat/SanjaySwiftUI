//
//  CircleLoader.swift
//  SanjaySwiftUI
//
//  Created by Sanjay Sampat on 18/12/20.
//  Copyright © 2020 Sanjay Sampat. All rights reserved.
//

import SwiftUI

struct CircleSpinLoader: View {
    @State var circleSpin = false
    
    let message:String
    
    init(_ message:String = "Please wait...") {
        self.message = message
    }
    
    var body: some View {
        ZStack {
            //Rectangle().frame(width:150, height: 120).background(Color.black).cornerRadius(8).opacity(0.6).shadow(color: .black, radius: 16)
            VStack {
                Circle()
                    .trim(from: 0.3, to: 1)
                    .stroke(Color.white, lineWidth:3)
                    .frame(width:40, height: 40)
                    .padding(.all, 8)
                    .rotationEffect(.degrees(circleSpin ? 0 : -360), anchor: .center)
                    .animation(Animation.linear(duration: 0.6).repeatForever(autoreverses: false))
                    .onAppear {
                        self.circleSpin = true
                    }
                Text(self.message)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(5)
                
            }.background(Color.black).cornerRadius(8).opacity(0.6).shadow(color: .black, radius: 16)
        }
    }
    
}

struct CircleLoader_Previews: PreviewProvider {
    static var previews: some View {
        CircleSpinLoader("test the spin loader")
    }
}
