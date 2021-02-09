//
//  SSMenuListView.swift
//  SanjaySwiftUI
//
//  Created by Sanjay Sampat on 02/02/21.
//  Copyright © 2021 Sanjay Sampat. All rights reserved.
//

import SwiftUI

struct SSMenuListView: View {
    
    @EnvironmentObject  var  userSettings : UserSettings
    
    @Binding var menuSelection: Int?
    
    @ObservedObject var store = SSMenuItemStore(ssMenuItems: mainMenuData)
    
    @State private var presentedSettings:Bool = false
    
    private let whoAmI:CallingViews = CallingViews.main
    
    var body: some View {
        NavigationView {
            List {
                Section{
                    ForEach (store.ssMenuItems) { ssMenuItem in
                        SSMenuCell(ssMenuItem: ssMenuItem)
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle(Text("Menu"), displayMode: .inline)
            .navigationBarItems(leading:
                                    Button(action: {
                                        withAnimation(.linear){
                                            self.menuSelection = 0
                                        }
                                    }, label: {
                                        Image(systemName: "chevron.left")
                                            .padding(.vertical, 5)
                                    })
                                /*
                                , trailing:
                                    Button(action: {
                                        presentedSettings.toggle()
                                    }, label: {
                                        Image(systemName: "text.justify")
                                            .padding(.vertical,5)
                                    })
                                */
            )
        }
        //.sheet(isPresented: $presentedSettings, content: {SanjaySwiftUIOptions(self.whoAmI)})
    }
    
}

struct SSMenuListView_Previews: PreviewProvider {
    static var previews: some View {
        SSMenuListView(menuSelection: .constant(2))
    }
}

struct SSMenuCell: View {
    let ssMenuItem: SSMenuItem
    
    var body: some View {
        NavigationLink(destination: ssMenuItem.destination ) {
            HStack {
                ZStack(alignment:ssMenuItem.zstackAlignment) {
                    Group {
                        Image(systemName: ssMenuItem.systemImage1)
                            .scaleEffect(ssMenuItem.image1ScaleEffect)
                        Image(systemName: ssMenuItem.systemImage2)
                            .scaleEffect(ssMenuItem.image2ScaleEffect)
                    }
                }
                .frame(width: 45.0, height: 45.0)
                .background(Color.blue)
                .cornerRadius(7)
                .foregroundColor(.white)
                
                Text(ssMenuItem.title)
                    .font(.body)
                    .lineLimit(nil)
                    .multilineTextAlignment(.leading)
            }
        }
    }
}
