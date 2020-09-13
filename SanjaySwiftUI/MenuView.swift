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
        //VStack {
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
                    
                    Divider()
                    
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
                    
                    Divider()

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
                    
                    Divider()

                    Group {
                        NavigationLink(destination:
                            AnimatableSwiftUIViewEx()
                        ) {
                            VStack( alignment: .leading) {
                                HStack {
                                    Image(systemName: "wand.and.stars")
                                    Text("Animatable")
                                        .font(.caption)
                                }
                                .font(.body)
                                .foregroundColor(CommonUtils.cu_activity_light_text_color)
                                .shadow(radius: 1.5)
                            }
                            
                        }

                        NavigationLink(destination:
                            AnimatablePairSwiftUIViewEx()
                        ) {
                            VStack( alignment: .leading) {
                                HStack {
                                    Image(systemName: "wand.and.stars.inverse")
                                    Text("AnimatablePair")
                                        .font(.caption)
                                }
                                .font(.body)
                                .foregroundColor(CommonUtils.cu_activity_light_text_color)
                                .shadow(radius: 1.5)
                            }
                            
                        }
                        
                        NavigationLink(destination:
                            AnimArcInsettableShapeViewEx()
                        ) {
                            VStack( alignment: .leading) {
                                HStack {
                                    Image(systemName: "wand.and.rays")
                                    Text("AnimArcInsettable")
                                        .font(.caption)
                                }
                                .font(.body)
                                .foregroundColor(CommonUtils.cu_activity_light_text_color)
                                .shadow(radius: 1.5)
                            }
                            
                        }
                    }
                    Spacer()
                }
                .background(CommonUtils.cu_activity_light_theam_color)
                
            }
            .navigationBarTitle("Select your choice")
        
        //}
        //.padding(.top, 20)
        
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView(menuSelection: .constant(1), currentPos: .constant(-1))
    }
}
