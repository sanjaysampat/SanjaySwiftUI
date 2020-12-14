//
//  EnumerationSampleView.swift
//  SanjaySwiftUI
//
//  Created by Sanjay Sampat on 03/12/20.
//  Copyright © 2020 Sanjay Sampat. All rights reserved.
//

import SwiftUI

struct EnumerationSampleView: View {
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Enumeration Code")) {
                    NavigationLink(destination: Enum1(), label: {
                        Text("Enum 1 (Recursive Enumerations)")
                    })
                }

            }
            .navigationBarTitle(Text("Sample"), displayMode: .inline)
        }
    }
}

// MARK: - Enumeration Code
// MARK: Enum 1 (Recursive Enumerations)

indirect enum ArithmeticExpression {
    case number(Double)
    case addition(ArithmeticExpression, ArithmeticExpression)
    case multiplication(ArithmeticExpression, ArithmeticExpression)
    case division(ArithmeticExpression, ArithmeticExpression)
}

enum EnumCalculatorKey {
    case operation(String)
    case number(String)
    case other(String)
}

struct Enum1: View {
    @State var displayTotalText:String = "0.00"
    @State var displayTranText:[String] = ["1+2=3","3x4=12"]
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                EnumDisplayTran(displayTranText: $displayTranText)
            }
            EnumDisplayTotal(displayTotalText: $displayTotalText)
                .layoutPriority(1)
            Spacer(minLength: 20)
        }
        .background(Color.black)
        .navigationBarTitle(Text("Enum 1"), displayMode: .inline)
    }
}

struct EnumDisplayTran: View {
    @Binding var displayTranText:[String]
    
    var body: some View {
        VStack(alignment: .trailing) {
                //Spacer()
                ForEach(displayTranText, id: \.self) { text in
                Text(text)
                    .font(.title2)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.trailing)
                }
            }
            //.cornerRadius(10)
            //.overlay(
            //    RoundedRectangle(cornerRadius: 10)
            //        .stroke(Color.purple, lineWidth: 1)
            //)   // SSNote - border with cornerradius
            .padding(5)
    }
}

struct EnumDisplayTotal: View {
    @Binding var displayTotalText:String
    
    var body: some View {
            HStack {
                Spacer()
                Text(displayTotalText)
                    .font(.title)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.trailing)
            }
            .frame(height: 70)
            .padding()
            .background(Color.purple.opacity(0.2))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.purple, lineWidth: 1)
            )   // SSNote - border with cornerradius
            .padding(5)
    }
}

struct EnumCalcButtonView: View {
    
    var rowButtons:[(id:String, enumKey:EnumCalculatorKey)]
    
    init() {
        rowButtons = EnumCalcButtonView.createEnumCalcButtons()
    }
    
    var body: some View {
        HStack {
            ForEach( self.rowButtons, id: \.self.id )  { rowButton in
            
            
                return Text("")
            
            // SSTODO
            
            }
        }
    }
    
    static private func createEnumCalcButtons() -> [(id:String, enumKey:EnumCalculatorKey)] {
        var calKeys:[(id:String, enumKey:EnumCalculatorKey)] = []
        calKeys.append( (UUID().uuidString,EnumCalculatorKey.other("C")) )
        calKeys.append( (UUID().uuidString,EnumCalculatorKey.other("􀅺")) )
        calKeys.append( (UUID().uuidString,EnumCalculatorKey.other("􀘾")) )
        calKeys.append( (UUID().uuidString,EnumCalculatorKey.operation("􀅿")) )
        calKeys.append( (UUID().uuidString,EnumCalculatorKey.number("7")) )
        calKeys.append( (UUID().uuidString,EnumCalculatorKey.number("8")) )
        calKeys.append( (UUID().uuidString,EnumCalculatorKey.number("9")) )
        calKeys.append( (UUID().uuidString,EnumCalculatorKey.operation("􀅾")) )
        calKeys.append( (UUID().uuidString,EnumCalculatorKey.number("4")) )
        calKeys.append( (UUID().uuidString,EnumCalculatorKey.number("5")) )
        calKeys.append( (UUID().uuidString,EnumCalculatorKey.number("6")) )
        calKeys.append( (UUID().uuidString,EnumCalculatorKey.operation("􀅽")) )
        calKeys.append( (UUID().uuidString,EnumCalculatorKey.number("1")) )
        calKeys.append( (UUID().uuidString,EnumCalculatorKey.number("2")) )
        calKeys.append( (UUID().uuidString,EnumCalculatorKey.number("3")) )
        calKeys.append( (UUID().uuidString,EnumCalculatorKey.operation("􀅼")) )
        calKeys.append( (UUID().uuidString,EnumCalculatorKey.number("0")) )
        calKeys.append( (UUID().uuidString,EnumCalculatorKey.number("")) )
        calKeys.append( (UUID().uuidString,EnumCalculatorKey.number(".")) )
        calKeys.append( (UUID().uuidString,EnumCalculatorKey.operation("􀆀")) )
        return calKeys
    }
}

struct EnumButtonNum: View {
    let label: String
    var font: Font = .title
    var textColor: Color = .white
    var backColor: Color = .white
    var backOpacity: Double = 0.2
    var backCornerRadius:CGFloat = 5
    let action: () -> ()

    var body: some View {
        EnumButton(label: label, font: font, textColor: textColor, backColor: backColor, backOpacity: backOpacity, backCornerRadius: backCornerRadius, action: action)
    }
}

struct EnumButton: View {
    let label: String
    var font: Font = .title
    var textColor: Color = .white
    var backColor: Color = .orange
    var backOpacity: Double = 1
    var backCornerRadius:CGFloat = 5
    let action: () -> ()
    
    var body: some View {
        Button(action: {
            self.action()
        }, label: {
            Text(label)
                .font(font)
                .padding(5)
                //.frame(width: 70)
                .background(RoundedRectangle(cornerRadius: backCornerRadius).foregroundColor(backColor).opacity(backOpacity))
                .foregroundColor(textColor)
            
        })
    }
}

struct EnumerationSampleView_Previews: PreviewProvider {
    static var previews: some View {
        EnumerationSampleView()
    }
}
