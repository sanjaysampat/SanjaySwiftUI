//
//  SanjaySwiftUIOptions.swift
//  SanjaySwiftUI
//
//  Created by Sanjay Sampat on 27/10/20.
//  Copyright © 2020 Sanjay Sampat. All rights reserved.
//

import SwiftUI


/*
enum CardsSpreadView:Double {
    case fullFixed = 140
    case closedFixed = 10
    case compactMultiply = 6
}
*/

struct SanjaySwiftUIOptions: View {
    @EnvironmentObject  var  userSettings : UserSettings
    
    let showModeOptions = ["Fixed", "Compact"]
    
    var body: some View {
        Form {
            Section(header: Text("Example 21 (playing cards)")) {
                Button(action:{
                    withAnimation(.default, {
                        userSettings.setDefaultValues()
                    })
                }) {
                    Text("Reset to Default")
                }.padding(.bottom, 10)
                
                HStack {
                    Text("Players :")
                    Picker("", selection: $userSettings.e21TotalPlayers) {
                        ForEach((1...2), id: \.self) { index in
                            Text("\(index)")
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Group {
                    HStack {
                        Spacer()
                        Text("Player 1").bold()
                        Spacer()
                    }
                    HStack {
                        Text("Show cards :")
                        Toggle("", isOn: $userSettings.e21P1ShowCards)
                    }
                    HStack {
                        Text("Show mode :")
                        Picker("", selection: $userSettings.e21P1ShowMode) {
                            ForEach(self.showModeOptions, id: \.self) {
                                Text($0)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    HStack {
                        if userSettings.e21P1ShowMode.elementsEqual("Fixed")  {
                            Slider(value: $userSettings.e21P1FixedModeDegree, in: 10...160, step:0.5, minimumValueLabel: Text("10"), maximumValueLabel: Text("160") ) {}
                            Text("(\(String( format: "%1.1f", userSettings.e21P1FixedModeDegree)))")
                        } else {
                            Slider(value: $userSettings.e21P1CompactModeDegree, in: 2...12, step:0.01, minimumValueLabel: Text("2"), maximumValueLabel: Text("12") ) {}
                            Text("(\(String( format: "%1.2f", userSettings.e21P1CompactModeDegree)))")
                        }
                    }
                }.padding(.bottom, 5)
                
                if userSettings.e21TotalPlayers > 1 {
                    Group {
                        HStack {
                            Spacer()
                            Text("Player 2").bold()
                            Spacer()
                        }
                        HStack {
                            Text("Show cards :")
                            Toggle("", isOn: $userSettings.e21P2ShowCards)
                        }
                        HStack {
                            Text("Show mode :")
                            Picker("", selection: $userSettings.e21P2ShowMode) {
                                ForEach(self.showModeOptions, id: \.self) {
                                    Text($0)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                        }
                        HStack {
                            if userSettings.e21P2ShowMode.elementsEqual("Fixed")  {
                                Slider(value: $userSettings.e21P2FixedModeDegree, in: 10...160, step:0.5, minimumValueLabel: Text("10"), maximumValueLabel: Text("160") ) {}
                                Text("(\(String( format: "%1.1f", userSettings.e21P2FixedModeDegree)))")
                            } else {
                                Slider(value: $userSettings.e21P2CompactModeDegree, in: 2...12, step:0.01, minimumValueLabel: Text("2"), maximumValueLabel: Text("12") ) {}
                                Text("(\(String( format: "%1.2f", userSettings.e21P2CompactModeDegree)))")
                            }
                        }
                    }.padding(.bottom, 10)
                }
                
                HStack {
                    Text("Total cards to deal to all players:")
                    Picker("",selection: $userSettings.e21PickCardsCount) {
                        ForEach((1...52), id: \.self) { index in
                            Text("\(index)")
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(width: 100)
                    .clipped(antialiased: true)
                }.frame(height: 100)
            }
            
             Section(header: Text("Wait for next episode ...")) {
             
             }
            
        }.navigationBarTitle(Text("User Settings"), displayMode: .inline)
    }
}

struct SanjaySwiftUIOptions_Previews: PreviewProvider {
    static var previews: some View {
        SanjaySwiftUIOptions()
    }
}
