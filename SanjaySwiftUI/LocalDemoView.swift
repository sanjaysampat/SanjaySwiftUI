//
//  LocalDemoView.swift
//  SanjaySwiftUI
//
//  Created by Sanjay Sampat on 30/08/20.
//  Copyright © 2020 Sanjay Sampat. All rights reserved.
//

import SwiftUI

struct LocalDemoView: View {
    
    @State var localeLanguage:String = "Localizable"

    var body: some View {
        ScrollView {
            VStack( alignment: .leading) {
                PrintinView("SSPrint - PrintinView - LocalDemoView - self.localeLanguage \(self.localeLanguage)")
                
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
                    PrintinView("SSPrint - PrintinView - LocalDemoView - self.localeLanguage \(self.localeLanguage)")
                    
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
        }
    }
}

struct LocalDemoView_Previews: PreviewProvider {
    static var previews: some View {
        LocalDemoView(localeLanguage: "Localizable")
    }
}
