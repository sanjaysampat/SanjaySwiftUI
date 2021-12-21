//
//  AVListView.swift
//  SanjaySwiftUI
//
//  Created by Sanjay Sampat on 28/08/20.
//  Copyright © 2020 Sanjay Sampat. All rights reserved.
//

import SwiftUI

struct AVListView: View {
    var body: some View {
        ZStack {
            VStack {
                
                ScrollView(.vertical) {
                    
                    Text("Start")
                        //.foregroundColor(CommonUtils.cu_activity_light_text_color)
                        .foregroundColor(ColorScheme.text)
                        .shadow(radius: 1.5)
                        .padding()
                    
                    
                    AudioView()
                    
                    VideoView()
                        .layoutPriority(1)  // SSNote : high priority for this layout by Parent.

                    Text("End")
                        //.foregroundColor(CommonUtils.cu_activity_light_text_color)
                        .foregroundColor(ColorScheme.text)
                        .shadow(radius: 1.5)
                        .padding()
                    
                    Spacer()

                }
            }
        }
    }
}

struct AVListView_Previews: PreviewProvider {
    static var previews: some View {
        AVListView()
    }
}
