//
//  AnimArcInsettableShapeViewEx.swift
//  SanjaySwiftUI
//
//  Created by Sanjay Sampat on 12/09/20.
//  Copyright © 2020 Sanjay Sampat. All rights reserved.
//

import SwiftUI

struct AnimArcInsettableShapeViewEx: View {
    
    @State var startAngleDegree = -180.0
    @State var endAngleDegree = 0.0
    @State var clockwise: Bool = true
    
    struct Arc : InsettableShape {
        var insetAmount: CGFloat = 0
        var startAngleDegree = -180.0
        var endAngleDegree = 0.0
        var clockwise: Bool = true

        var animatableData: AnimatablePair<Double, Double> {
          get {return AnimatablePair(startAngleDegree, endAngleDegree)}
          set {
            startAngleDegree = newValue.first
            endAngleDegree = newValue.second
          }
        }
        
        func inset(by amount: CGFloat) -> some InsettableShape {
            var arc = self
            arc.insetAmount += amount
            return arc
        }
        
        func path(in rect: CGRect) -> Path {
            //let rotationAdjustment = Angle.degrees(90)
            //let modifiedStart = Angle.degrees(startAngleDegree) - rotationAdjustment
            //let modifiedEnd = Angle.degrees(endAngleDegree) - rotationAdjustment

            var path = Path()
            path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: rect.width / 2 - insetAmount, startAngle: Angle.degrees(startAngleDegree), endAngle: Angle.degrees(endAngleDegree), clockwise: !clockwise)

            return path
        }
    }
    
    var body: some View {
        
        GeometryReader {
            geometry in
            ZStack {
                Arc(startAngleDegree: self.startAngleDegree, endAngleDegree: self.endAngleDegree, clockwise: self.clockwise)
                    .strokeBorder(Color.blue, lineWidth: 40)
                    .animation(.spring())
                VStack {
                    Spacer()
                    Group {
                        Stepper(value: self.$startAngleDegree, in: -275...85, step: 22.5) {
                            Text("startAngleDegree: \(self.startAngleDegree, specifier: "%.2f")")
                                .foregroundColor(.black)
                        }
                        Stepper(onIncrement: {
                            self.startAngleDegree += 45
                            self.endAngleDegree += 45
                            if self.startAngleDegree > 85 {
                                self.startAngleDegree = 85
                            }
                            if self.endAngleDegree > 95 {
                                self.endAngleDegree = 95
                            }
                        }, onDecrement: {
                            self.startAngleDegree -= 45
                            self.endAngleDegree -= 45
                            if self.startAngleDegree < -275 {
                                self.startAngleDegree = -275
                            }
                            if self.endAngleDegree < -265 {
                                self.endAngleDegree = -265
                            }
                        }) {
                            Text("startAngleDegree:\(self.startAngleDegree, specifier: "%.2f"), endAngleDegree:\(self.endAngleDegree, specifier: "%.2f")")
                                .foregroundColor(.black)
                        }
                        Stepper(value: self.$endAngleDegree, in: -265...95, step: 22.5) {
                            Text("endAngleDegree: \(self.endAngleDegree, specifier: "%.2f")")
                                .foregroundColor(.black)
                        }
                    }
                    .background(Color.white)
                }
                
            }
        }
        
    }
}

struct AnimArcInsettableShapeViewEx_Previews: PreviewProvider {
    static var previews: some View {
        AnimatablePairSwiftUIViewEx()
    }
}
