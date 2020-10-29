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
                    
                    NavigationLink(destination: Shape3(), label: {
                        Text("Effects with CGAffineTransform")
                    })
                    
                    NavigationLink(destination: Shape4(), label: {
                        Text("Gradient Rectangle")
                    })
                }
            }
        }
        .navigationBarTitle(Text("Play with Shapes"), displayMode: .inline)
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
        .navigationBarTitle(Text("Standard Types"), displayMode: .inline)
        //.padding(.bottom, 20)
        
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
        .navigationBarTitle("Effects on Rect").padding(.bottom, 20)
    }
}

struct Shape3: View {
    @State var steps = 0.0
    @State var baseColor:UIColor = UIColor.systemBlue
    
    var body: some View {
        VStack {
            Stepper(value: $steps, in: 0.0...1.1, step:0.4) {
                Text("steps: \(steps, specifier: "%.1f")")
                    .foregroundColor(.black)
            }
            
            ZStack {
                if self.steps > 0.0 {
                    TransformedShape(shape: Rectangle(), transform: complexTransformation(steps: steps))
                        .foregroundColor(colorMixer2(c2: UIColor.systemRed, pct: CGFloat(self.steps) ))
                        .opacity(steps)
                        .animation(.default)
                }
            }
        }
        .navigationBarTitle("CGAffineTransform").padding(.bottom, 20)
    }
    
    // This is a very basic implementation of a color interpolation
    // between two values.
    func colorMixer2(c2: UIColor, pct: CGFloat) -> Color {
        guard let cc1 = baseColor.cgColor.components else { return Color(baseColor) }
        guard let cc2 = c2.cgColor.components else { return Color(baseColor) }
        
        let r = (cc1[0] + (cc2[0] - cc1[0]) * pct)
        let g = (cc1[1] + (cc2[1] - cc1[1]) * pct)
        let b = (cc1[2] + (cc2[2] - cc1[2]) * pct)

        return Color(red: Double(r), green: Double(g), blue: Double(b))
    }

    func complexTransformation(steps:Double = 3) -> CGAffineTransform {
        var affineTransform = CGAffineTransform(translationX: 170, y: 50)
        let st = ( steps > 1.0 ? 1.0 : ( steps > 0.5 ? 0.5 : steps ) )
        switch st {
        case 0.5 :
            affineTransform = affineTransform.scaledBy(x: 0.4, y: 0.4)
        case 1.0:
            affineTransform = affineTransform.scaledBy(x: 0.4, y: 0.4)
            affineTransform = affineTransform.rotated(by: 45)
        default:
            break
        }
        
        return affineTransform
    }
}

struct Shape4: View {
    let gradient = Gradient(colors: [.red, .orange, .yellow, .green, .blue])
    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .foregroundColor(.clear) .background(LinearGradient(gradient: gradient, startPoint: .top, endPoint: .bottom))
                TextOverlayView(string: "LinearGradient")
            }
            GeometryReader {
                geometry in
                ZStack {
                    Rectangle()
                        .foregroundColor(.clear)
                        .background(AngularGradient.init(gradient: self.gradient, center: .zero, angle: Angle(degrees: 180.0)))
                    TextOverlayView(string: "AngularGradient")
                }
            }
            GeometryReader {
                geometry in
                ZStack {
                    Rectangle()
                        .foregroundColor(.clear)
                        .background(RadialGradient.init(gradient: self.gradient, center: .zero, startRadius: 45, endRadius: 500))
                    TextOverlayView(string: "RadialGradient")
                }
            }
        }
        .navigationBarTitle("Gradient Rectangle").padding(.bottom, 20)
    }
}

struct TextOverlayView : View {
    let string: String
    var body: some View {
        VStack {
            Spacer()
            Text(string)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .font(.title)
        }
    }
}

struct CheckShapesView_Previews: PreviewProvider {
    static var previews: some View {
        CheckShapesView()
    }
}
