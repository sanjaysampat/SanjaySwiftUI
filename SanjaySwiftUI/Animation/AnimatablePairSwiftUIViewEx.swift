//
//  AnimatablePairSwiftUIViewEx.swift
//  SanjaySwiftUI
//
//  Created by Sanjay Sampat on 12/09/20.
//  Copyright © 2020 Sanjay Sampat. All rights reserved.
//

import SwiftUI

struct AnimatablePairSwiftUIViewEx: View {
    @State var xOffset = CGFloat(15)
    @State var yOffset = CGFloat(15)
    
    struct Square : Shape {
      var xOffset: CGFloat
      var yOffset: CGFloat
      var animatableData: AnimatablePair<CGFloat, CGFloat> {
        get {return AnimatablePair(xOffset, yOffset)}
        set {
          xOffset = newValue.first
          yOffset = newValue.second
        }
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
        path.move(to: CGPoint(x: rect.minX - xOffset, y: rect.minY - yOffset))
        path.addLine(to: CGPoint(x: rect.minX - xOffset, y: (rect.minY + length) - yOffset))
        path.addLine(to: CGPoint(x: (rect.minX + length)  - xOffset, y: (rect.minY + length) - yOffset))
        path.addLine(to: CGPoint(x: (rect.minX + length) - xOffset, y: rect.minY - yOffset))
        
        return path
      }
    }
    
    var body: some View {
        GeometryReader {
            geometry in
            ZStack {
                Square(xOffset: self.xOffset, yOffset: self.yOffset)
                    .foregroundColor(.red)
                    .animation(.spring())
                VStack {
                    Spacer()
                    Group {
                        Stepper(value: self.$xOffset, in: -(geometry.size.width / 2)...geometry.size.width / 2, step: 25) {
                            Text("X Offset: \(Int(self.xOffset))")
                                .foregroundColor(.black)
                        }
                        Stepper(onIncrement: {
                            self.xOffset += 50
                            self.yOffset += 50
                            if self.xOffset > geometry.size.width / 2 {
                                self.xOffset = -(geometry.size.width / 2)
                            }
                            if self.yOffset > geometry.size.height / 2 {
                                self.yOffset = -(geometry.size.height / 2)
                            }
                        }, onDecrement: {
                            self.xOffset -= 50
                            self.yOffset -= 50
                            if self.xOffset < -(geometry.size.width / 2) {
                                self.xOffset = geometry.size.width / 2
                            }
                            if self.yOffset < -(geometry.size.height / 2) {
                                self.yOffset = geometry.size.height / 2
                            }
                        }) {
                            Text("X Offset:\(Int(self.xOffset)), Y Offset:\(Int(self.yOffset))")
                                .foregroundColor(.black)
                        }
                        Stepper(value: self.$yOffset, in: -(geometry.size.height / 2)...geometry.size.height / 2, step: 25) {
                            Text("Y Offset: \(Int(self.yOffset))")
                                .foregroundColor(.black)
                        }
                    }
                    .background(Color.white)
                }
                
            }
        }
    }
}

struct AnimatablePairSwiftUIViewEx_Previews: PreviewProvider {
    static var previews: some View {
        AnimatablePairSwiftUIViewEx()
    }
}
