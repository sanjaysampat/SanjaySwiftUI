//
//  MenuView.swift
//  SanjaySwiftUI
//
//  Created by Sanjay Sampat on 26/08/20.
//  Copyright © 2020 Sanjay Sampat. All rights reserved.
//

import SwiftUI

struct MenuView: View {
    @Binding var menuSelection: Int?
    @Binding var currentPos:Int
    
    var body: some View {
        //ZStack {
            NavigationView {
                VStack(alignment: .leading) {
                    HStack {
                    Button(action: {
                        self.menuSelection = 0
                    }) {
                        HStack( alignment: .center) {
                            Image(systemName: "chevron.left")
                            Text("Back")
                                .font(.body)
                                .foregroundColor(CommonUtils.cu_activity_light_text_color)
                                .shadow(radius: 1.5)
                            
                        }
                    }
                    .foregroundColor(CommonUtils.cu_activity_foreground_color)
                    //.padding()
                        
                        Spacer()
                    }

                    NavigationLink(destination:                 ListView(currentPos: $currentPos)
                    ) {
                        VStack( alignment: .leading) {
                            HStack {
                                Image(systemName: "square.stack.3d.down.right")
                                Text("List View")
                                    .font(.caption)
                            }
                            .font(.body)
                            .foregroundColor(CommonUtils.cu_activity_light_text_color)
                            .shadow(radius: 1.5)
                        }
                        
                    }
                    
                    NavigationLink(destination:
                        AVListView()
                    ) {
                        VStack( alignment: .leading) {
                            HStack {
                                Image(systemName: "play.circle")
                                Text("Audio/Video List View")
                                    .font(.caption)
                            }
                            .font(.body)
                            .foregroundColor(CommonUtils.cu_activity_light_text_color)
                            .shadow(radius: 1.5)
                        }
                        
                    }
                    
                    NavigationLink(destination:
                        TabSwiftUiView()
                    ) {
                        VStack( alignment: .leading) {
                            HStack {
                                Image(systemName: "bed.double")
                                Text("Tab View")
                                    .font(.caption)
                            }
                            .font(.body)
                            .foregroundColor(CommonUtils.cu_activity_light_text_color)
                            .shadow(radius: 1.5)
                        }
                        
                    }

                    Spacer()
                }
                .background(CommonUtils.cu_activity_light_theam_color)
                
            }
            
        //}
        //.padding(.top, 20)
        
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView(menuSelection: .constant(1), currentPos: .constant(-1))
    }
}
