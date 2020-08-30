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
        VStack {
            PrintinView("SSTODO - PrintinView - LocalDemoView - self.localeLanguage \(self.localeLanguage)")

            Text("string_my_name_is", tableName: localeLanguage, bundle: Bundle.main, comment: "Comment")
            Text("string_my_address_is", tableName: localeLanguage, bundle: Bundle.main, comment: "Comment")
        }
    }
}

struct LocalDemoView_Previews: PreviewProvider {
    static var previews: some View {
        LocalDemoView(localeLanguage: "Localizable")
    }
}
