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
    
    @State var selectedAnimationPos:Int = 0
    var animateOptions = ["animatable"]
    
    var body: some View {
        //ZStack {
            NavigationView {
                VStack(alignment: .leading) {
                    HStack {
                    Button(action: {
                        withAnimation(.linear(duration:2)){
                            self.menuSelection = 0
                        }
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

                    NavigationLink(destination:
                        ListView(currentPos: $currentPos)
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
                    
                    NavigationLink(destination:
                        PaymentSwiftUIView()
                    ) {
                        VStack( alignment: .leading) {
                            HStack {
                                Image(systemName: "dollarsign.circle")
                                Text("Apple Pay")
                                    .font(.caption)
                            }
                            .font(.body)
                            .foregroundColor(CommonUtils.cu_activity_light_text_color)
                            .shadow(radius: 1.5)
                        }
                        
                    }
                    /*
                    Picker(selection: $selectedAnimationPos, label: Text("Select Ani")) {
                        // SSTODO to display different animations
                        
                    }
                    */

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
