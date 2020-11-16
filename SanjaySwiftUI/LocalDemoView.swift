//
//  LocalDemoView.swift
//  SanjaySwiftUI
//
//  Created by Sanjay Sampat on 30/08/20.
//  Copyright © 2020 Sanjay Sampat. All rights reserved.
//

import NaturalLanguage
import SwiftUI

struct LocalDemoView: View {
    
    @State var localeLanguage:String = "Localizable"
    @State var addressLocalized:String = ""
    @State var addressWords:[String] = [String]()
    
    @State var stringIdentifiableArray:[StringIdentifiable] = []

    var body: some View {
        return ScrollView {
            
            VStack( alignment: .leading) {
                //PrintinView("SSPrint - PrintinView - LocalDemoView - self.localeLanguage \(self.localeLanguage)")
                
                Text("string_my_name_is", tableName: nil, bundle: Bundle.main, comment: "Comment")
                    .padding(.top, 10)
                
                Text("string_my_address_is", tableName: nil, bundle: Bundle.main, comment: "Comment")
                .padding(.top, 10)

                Text("The above text will auto display in the iPhone device language. It will be right to left in Arabic, Farsi or Urdu iPhone device languages.")
                    .padding(.top, 10)
                    .foregroundColor(Color.gray)
                
            }
            Divider()
            if !localeLanguage.elementsEqual("Localizable") {
                VStack( alignment: .trailing) {
                    //PrintinView("SSPrint - PrintinView - LocalDemoView - self.localeLanguage \(self.localeLanguage)")
                    
                    Text("string_my_name_is", tableName: localeLanguage, bundle: Bundle.main, comment: "Comment")
                    .multilineTextAlignment(.trailing)
                    .padding(.top, 10)

                    Text("string_my_address_is", tableName: localeLanguage, bundle: Bundle.main, comment: "Comment")
                    .multilineTextAlignment(.trailing)
                    .padding(.top, 10)

                    Text("The above text is manually set as right to left alignment. It is using Hardcoded language table to load string.")
                        .multilineTextAlignment(.trailing)
                        .padding(.top, 10)
                    .foregroundColor(Color.gray)

                }
                Divider()
            }
            VStack {
                if stringIdentifiableArray.count > 0 {
                    Text("NLTokenizer of Address words  \(localeLanguage)").underline()
                }
                // SSNote :- need to create struct conforming to protocol 'Identifiable' to ForEach loop. We can not use ( 0 ..< stringArrayObj.count ) OR ( stringArrayObj. id: \self ) when stringArrayObj @State variable modify itself in the body of struct for eg. in .onAppear below.
                //
                ForEach( stringIdentifiableArray ) { stringIdentifiable in
                    Text("\(stringIdentifiable.word)")
                }
            }
            .onAppear() {
                addressWords.removeAll()
                stringIdentifiableArray.removeAll()
                addressLocalized = Bundle.main.localizedString(forKey: "string_my_address_is", value: "test", table: localeLanguage)
                
                let tokenizer = NLTokenizer(unit: .word)
                tokenizer.string = addressLocalized
                tokenizer.enumerateTokens(in: addressLocalized.startIndex..<addressLocalized.endIndex) { (range, attributes) -> Bool in
                    let word = addressLocalized[range]
                    addressWords.append(String(word))
                    stringIdentifiableArray.append(StringIdentifiable(word: String(word)))
                    return true
                }
            }
        }
    }
}

struct StringIdentifiable: Identifiable {
    var id = UUID()
    var word:String
}

struct LocalDemoView_Previews: PreviewProvider {
    static var previews: some View {
        LocalDemoView(localeLanguage: "Localizable")
    }
}
