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
                        Text("Enum 1 (Normal Enumerations)")
                    })
                }
                
            }
            .navigationBarTitle(Text("Sample"), displayMode: .inline)
        }
    }
}

// MARK: - Enumeration Code
// MARK: Enum 1 (Normal Enumerations)

struct Enum1: View {
    
    @State private var displayTotalText:String = "0.00"
    @State private var displayTranText:[String] = []
    @State private var enumCalculator = EnumCalculator()

    var body: some View {
        
        VStack {
            Spacer()
            EnumDisplayTotal(displayTotalText: $displayTotalText)
                .layoutPriority(1)
            Spacer(minLength: 20)
            EnumDisplayKeys(displayTotalText: $displayTotalText, displayTranText: $displayTranText, enumCalculator: $enumCalculator)
            HStack {
                EnumDisplayTran(displayTranText: $displayTranText)
                Spacer()
            }
            if displayTranText.count > 0 {
                EnumButtonNum(label: "clear text", font: .title3, maxHeight:10) {
                    self.displayTranText.removeAll()
                    self.enumCalculator.cleartransactionString()
                }
            }
        }
        .background(Color.black)
        .navigationBarTitle(Text("Enum 1"), displayMode: .inline)
    }
}

struct EnumDisplayKeys: View {
    
    @Binding var displayTotalText:String
    @Binding var displayTranText:[String]

    @Binding var enumCalculator:EnumCalculator
    
    @State private var isInMiddleOfTyping = false
    
    let margin: CGFloat = 10
    
    let data = [["C", "√", "π", "÷"],
                ["7", "8", "9", "×"],
                ["4", "5", "6", "−"],
                ["1", "2", "3", "+"],
                ["±", "0", ".", "="]]

    var body: some View {
        VStack(alignment: .center, spacing: margin) {
            ForEach(self.data, id:\.self) { items in
            //ForEach(data.identified(by: \.description)) { items in
                HStack(alignment: .center, spacing: margin) {
                    ForEach(items, id:\.self) { item in
                    //ForEach(items.identified(by: \.description)) { item in
                        if Int(item) != nil || item == "." {

                        EnumButtonNum(label: item) {
                            self.touchAction(item)
                        }
                        }
                        else
                        {
                            EnumButton(label: item) {
                                self.touchAction(item)
                            }
                        }
                        /*
                        Text(item)
                            .font(.title)
                            .bold()
                            .foregroundColor(Color.blue)
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                            .background(Color(red: 234 / 255.0, green: 240 / 255.0, blue: 241 / 255.0))
                            .onTapGesture {
                                self.touchAction(item)
                            }
                        */
                    }
                }
            }
        }
        .padding(EdgeInsets(top: 0, leading: margin, bottom: 0, trailing: margin))
    }
    
    private func touchAction(_ key: String) {
        if Int(key) != nil || key == "." {
            touchDigit(key)
        } else {
            performOperation(key)
        }
    }
    
    private func touchDigit(_ digit: String) {
        print(#function)
        if isInMiddleOfTyping {
            displayTotalText += digit
        } else {
            displayTotalText = digit
            isInMiddleOfTyping = true
        }
    }
    
    private func performOperation(_ key: String) {
        print(#function)
        if isInMiddleOfTyping {
            enumCalculator.setOperand(Double(displayTotalText)!)
            isInMiddleOfTyping = false
        }
        
        enumCalculator.performOperation(key)
        
        if let result = enumCalculator.result {
            displayTotalText = String(result)
        }
        
        if let transaction = enumCalculator.transaction {
            displayTranText = [transaction]
        }
    }
    
}

struct EnumDisplayTran: View {
    @Binding var displayTranText:[String]
    
    var body: some View {
        ScrollView {
            ForEach(displayTranText, id: \.self) { text in
                Text(text)
                    .font(.title2)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                    //.truncationMode(.head)  // Truncation is indicated by adding an ellipsis (…) to the line when removing text - .head = start of line
                    // as on date 'truncationMode(.head)' is not working. It is working like .tail ( so scrollview was added )
            }
        }
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

struct EnumCalculator {
    
    private var totalOptional:Double?
    private var transactionString:String = ""

    private enum ArtihmaticOperation {
        case constant(Double)
        case unary((Double) -> Double)
        case binary((Double,Double) -> Double)
        case equals
    }
    
    // Dictionary of operations with closures
    private var operations: Dictionary<String,ArtihmaticOperation> = [
        "C" : ArtihmaticOperation.constant(0.0),
        "π" : ArtihmaticOperation.constant(Double.pi),
        "√" : ArtihmaticOperation.unary(sqrt),
        "±" : ArtihmaticOperation.unary({ -$0 }),
        "×" : ArtihmaticOperation.binary({ $0 * $1 }),
        "÷" : ArtihmaticOperation.binary({ $0 / $1 }),
        "+" : ArtihmaticOperation.binary({ $0 + $1 }),
        "−" : ArtihmaticOperation.binary({ $0 - $1 }),
        //"%" : ArtihmaticOperation.binary({ $0 % $1 }),
        "=" : ArtihmaticOperation.equals
    ]
    
    mutating func performOperation(_ key: String) {
        if let operation = operations[key] {
            transactionString.append(key)
            switch operation {
            case .constant(let value):
                totalOptional = value
                transactionString = String("\n\(value)\n")
                //transactionString = (key=="C" ? "" : String("\(value)\n"))
            case .unary(let f):
                if totalOptional != nil {
                    totalOptional = f(totalOptional!)
                    transactionString = String("\(totalOptional!)\n")
                }
            case .binary(let f):
                if totalOptional != nil {
                    pendingBinaryOperation = PendingBinaryOperation(function: f, firstOperand: totalOptional!)
                    totalOptional = nil
                }
            case .equals:
                performPendingBinaryOperation()
            }
        } else {
            print("wrong key")
        }
    }
    
    mutating func performPendingBinaryOperation() {
        if pendingBinaryOperation != nil && totalOptional != nil {
            totalOptional = pendingBinaryOperation!.perform(with: totalOptional!)
            transactionString.append("\(totalOptional!)\n")
            pendingBinaryOperation = nil
        }
    }
    
    mutating func cleartransactionString() {
        transactionString.removeAll()
    }
    
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    // embedded private struct to support binary operations
    // with a constant function and pending first operand
    // doesn't need mutating since its just returning a value
    private struct PendingBinaryOperation {
        let function: (Double, Double) -> Double
        let firstOperand: Double
        
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    
    // mark method as mutating in order to assign to property
    mutating func setOperand(_ operand: Double) {
        totalOptional = operand
        transactionString.append(String(operand))
    }
    
    var result: Double? {
        get {
            return totalOptional
        }
    }
    
    var transaction: String? {
        get {
            return transactionString
        }
    }

}

/*
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
 */

struct EnumButtonNum: View {
    let label: String
    var font: Font = .title
    var textColor: Color = .white
    var backColor: Color = .gray
    var backOpacity: Double = 0.2
    var backCornerRadius:CGFloat = 5
    var minWidth:CGFloat = 0
    var minHeight:CGFloat = 0
    var maxWidth:CGFloat = .infinity
    var maxHeight:CGFloat = .infinity
    let action: () -> ()
    
    var body: some View {
        EnumButton(label: label, font: font, textColor: textColor, backColor: backColor, backOpacity: backOpacity, backCornerRadius: backCornerRadius, minWidth: minWidth, minHeight: minHeight, maxWidth: maxWidth, maxHeight: maxHeight, action: action)
    }
}

struct EnumButton: View {
    let label: String
    var font: Font = .title
    var textColor: Color = .white
    var backColor: Color = .orange
    var backOpacity: Double = 1
    var backCornerRadius:CGFloat = 5
    var minWidth:CGFloat = 0
    var minHeight:CGFloat = 0
    var maxWidth:CGFloat = .infinity
    var maxHeight:CGFloat = .infinity
    let action: () -> ()
    
    var body: some View {
        Button(action: {
            self.action()
        }, label: {
            Text(label)
                .font(font)
                //.padding(5)
                //.frame(width: 70)
                .frame(minWidth: minWidth, maxWidth: maxWidth, minHeight: minHeight, maxHeight: maxHeight)
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
