//
//  CheckShapesView.swift
//  SanjaySwiftUI
//
//  Created by Sanjay Sampat on 19/09/20.
//  Copyright © 2020 Sanjay Sampat. All rights reserved.
//

import SwiftUI

struct CheckShapesView: View {
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Part 1: Standard")) {
                    NavigationLink(destination: Shape1(), label: {
                        Text("Standard Types")
                    })
                    
                    NavigationLink(destination: Shape2(), label: {
                        Text("Effects on Standard Types")
                    })
                }
            }
        }.navigationBarTitle("Play with Shapes")
    }
}

struct Shape1: View {
    
    var body: some View {
        VStack {
            HStack {
                VStack {
                    Text("Circle")
                    Circle()
                        .frame(width: 150, height: 50)
                }
                VStack {
                    Text("Ellipse")
                    Ellipse()
                        .frame(width: 150, height: 50)
                }
            }
            HStack{
                VStack {
                    Text("Rounded rectangle")
                    RoundedRectangle(cornerRadius: 15)
                        .frame(width: 100, height: 200)
                }
                VStack {
                    Text("Capsule")
                    Capsule()
                        .frame(width: 100, height: 200)
                }
                VStack {
                    Text("Rectangle")
                    
                    Rectangle()
                        .frame(width: 100, height: 200)
                }
            }
        }
    }
}

struct Shape2: View {
    
    var body: some View {
        VStack {
            Text("Yellow background is added to show actual position of view.")
                .multilineTextAlignment(.center)
                .font(.caption)
            
            ScaledShape(shape: Rectangle(), scale: CGSize(width: 0.5, height: 0.5))
                .overlay(Text("Scaled shape")
                .foregroundColor(.white))
                .background(Color.yellow.opacity(0.4))

            RotatedShape(shape: Rectangle(), angle: Angle(degrees: 45))
                .frame(width: 125, height: 125)
                .overlay(Text("Rotated shape")
                .foregroundColor(.white))
                .background(Color.yellow.opacity(0.4))

            Group {
                OffsetShape(shape: Rectangle(), offset: CGSize(width: 110, height: 50))
                    .frame(width: 100, height: 100)
                    .overlay(Text("Offset shape"))
            }
            .frame(height: 150)
            .background(Color.yellow.opacity(0.4))
            
            Spacer()
        }
    }
}

struct CheckShapesView_Previews: PreviewProvider {
    static var previews: some View {
        CheckShapesView()
    }
}
