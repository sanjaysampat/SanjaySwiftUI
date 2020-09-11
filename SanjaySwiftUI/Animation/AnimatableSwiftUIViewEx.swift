//
//  AnimatableSwiftUIViewEx.swift
//  SanjaySwiftUI
//
//  Created by Sanjay Sampat on 09/09/20.
//  Copyright © 2020 Sanjay Sampat. All rights reserved.
//

import SwiftUI

struct AnimatableSwiftUIViewEx: View {
    @State var offset = CGFloat(15)

    struct Square : Shape {
      var offset: CGFloat
      var animatableData: CGFloat {
        get {return offset}
        set {offset = newValue}
      }
      func path(in rect: CGRect) -> Path {
        var path = Path()
        var length = CGFloat()
        if rect.width <= rect.height {
          length = rect.width
        }
        else {
          length = rect.height
        }
        path.move(to: CGPoint(x: rect.minX, y: rect.minY - offset))
        path.addLine(to: CGPoint(x: rect.minX, y: (rect.minY + length) - offset))
        path.addLine(to: CGPoint(x: rect.minX + length, y: (rect.minY + length) - offset))
        path.addLine(to: CGPoint(x: rect.minX + length, y: rect.minY - offset))
        
        return path
      }
    }

    var body: some View {
        GeometryReader {
          geometry in
          ZStack {
            Square(offset: self.offset)
              .foregroundColor(.red)
              .animation(.spring())
            VStack {
              Spacer()
              Stepper(value: self.$offset, in: -(geometry.size.height / 2)...geometry.size.height / 2, step: 25) {
                Text("Offset: \(Int(self.offset))")
                  .foregroundColor(.black)
              }
              .padding()
              .background(Color.white)
            }
          }
        }
    }
}

struct AnimatableSwiftUIViewEx_Previews: PreviewProvider {
    static var previews: some View {
        AnimatableSwiftUIViewEx()
    }
}
