//
//  ChartDemoView.swift
//  SanjaySwiftUI
//
//  Created by Sanjay Sampat on 19/01/21.
//  Copyright © 2021 Sanjay Sampat. All rights reserved.
//

import Foundation
import SwiftUI

struct ChartDemoView: View {
    
    var body: some View {
        return NavigationView {
            List {
                Section(header: Text("Charts")) {
                    
                    NavigationLink(destination: Example31(), label: {
                        Text("Example 31 - Line Chart")
                    })
                    /*
                    NavigationLink(destination: Example32(), label: {
                        Text("Example 32 - Another Chart
                    })
                    
                    NavigationLink(destination: Example33(), label: {
                        Text("Exmaple 33 - Another Chart")
                    })
                    */
                    
                }
            }
            .navigationBarTitle(Text("Chart Demo"), displayMode: .inline)
        }

    }

}

struct Example31: View {
    
    var body: some View {
        Text("SSTODO - Line Chart using Swift Package Manager.")
    }
    
}

struct ChartDemoView_Previews: PreviewProvider {
    static var previews: some View {
        ChartDemoView()
    }
}
