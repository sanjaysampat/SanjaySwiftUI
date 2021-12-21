//
//  MenuView.swift
//  SanjaySwiftUI
//
//  Created by Sanjay Sampat on 26/08/20.
//  Copyright © 2020 Sanjay Sampat. All rights reserved.
//

import SwiftUI

struct MenuView: View {
    @EnvironmentObject  var  userSettings : UserSettings
    
    @Binding var menuSelection: Int?
    @Binding var currentPos:Int
    
    @StateObject var localNotification = LocalNotification()
    @StateObject var localNotificationCenter = LocalNotificationCenter.shared
    
    @State var showNotification:Bool = false
    
    @State private var presentedSettings:Bool = false
    
    private let whoAmI:CallingViews = CallingViews.main
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    
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
                            //.foregroundColor(CommonUtils.cu_activity_light_text_color)
                            .foregroundColor(ColorScheme.text)
                            .shadow(radius: 1.5)
                        }
                        .padding(.vertical, 5)
                    }
                    Divider()
                    
                    /*
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
                            //.foregroundColor(CommonUtils.cu_activity_light_text_color)
                            .foregroundColor(ColorScheme.text)
                            .shadow(radius: 1.5)
                        }
                        .padding(.bottom, 5)
                        
                    }
                    
                    NavigationLink(destination:
                                    RoomListView()
                    ) {
                        VStack( alignment: .leading) {
                            HStack {
                                ZStack {
                                    Image(systemName: "rectangle")
                                        .scaleEffect(CGSize(width: 1.2, height: 1.2))
                                    Image(systemName: "person.2.fill")
                                        .scaleEffect(CGSize(width: 0.8, height: 0.8))
                                }
                                Text("List of conferance rooms")
                                    .font(.caption)
                            }
                            .font(.body)
                            //.foregroundColor(CommonUtils.cu_activity_light_text_color)
                            .foregroundColor(ColorScheme.text)
                            .shadow(radius: 1.5)
                        }
                        .padding(.bottom, 5)
                        
                    }
                    
                    NavigationLink(destination:
                                    SignatureListView()
                    ) {
                        VStack( alignment: .leading) {
                            HStack {
                                ZStack {
                                    Image(systemName: "signature")
                                }
                                Text("Signature List")
                                    .font(.caption)
                            }
                            .font(.body)
                            //.foregroundColor(CommonUtils.cu_activity_light_text_color)
                            .foregroundColor(ColorScheme.text)
                            .shadow(radius: 1.5)
                        }
                    }
                    
                    Divider()
                    
                    NavigationLink(destination:
                                    TabSwiftUiView()
                    ) {
                        VStack( alignment: .leading) {
                            HStack {
                                Image(systemName: "bed.double.fill")
                                    .scaleEffect(CGSize(width: 0.8, height: 1.4))
                                Text("Tab View")
                                    .font(.caption)
                            }
                            .font(.body)
                            //.foregroundColor(CommonUtils.cu_activity_light_text_color)
                            .foregroundColor(ColorScheme.text)
                            .shadow(radius: 1.5)
                            Divider()
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
                            //.foregroundColor(CommonUtils.cu_activity_light_text_color)
                            .foregroundColor(ColorScheme.text)
                            .shadow(radius: 1.5)
                            Divider()
                        }
                        
                    }
                    
                    NavigationLink(destination:
                                    CheckShapesView()
                    ) {
                        VStack( alignment: .leading) {
                            HStack {
                                Image(systemName: "cube.box")
                                Text("Play with Shapes")
                                    .font(.caption)
                            }
                            .font(.body)
                            //.foregroundColor(CommonUtils.cu_activity_light_text_color)
                            .foregroundColor(ColorScheme.text)
                            .shadow(radius: 1.5)
                            Divider()
                        }
                        
                    }
                    
                    NavigationLink(destination:
                                    CheckGridsView()
                    ) {
                        VStack( alignment: .leading) {
                            HStack {
                                Image(systemName: "square.grid.3x2")
                                Text("Play with Grids")
                                    .font(.caption)
                            }
                            .font(.body)
                            //.foregroundColor(CommonUtils.cu_activity_light_text_color)
                            .foregroundColor(ColorScheme.text)
                            .shadow(radius: 1.5)
                            Divider()
                        }
                        
                    }
                    
                    NavigationLink(destination:
                                    GeometryOfView()
                    ) {
                        VStack( alignment: .leading) {
                            HStack {
                                ZStack(alignment: .leading) {
                                    Image(systemName: "sum")
                                    Image(systemName: "function")
                                        .scaleEffect(CGSize(width: 0.8, height: 0.8))
                                }
                                Text("Geometry")
                                    .font(.caption)
                            }
                            .font(.body)
                            //.foregroundColor(CommonUtils.cu_activity_light_text_color)
                            .foregroundColor(ColorScheme.text)
                            .shadow(radius: 1.5)
                            Divider()
                        }
                        
                    }
                    
                    NavigationLink(destination:
                                    EnviornmentView()
                    ) {
                        VStack( alignment: .leading) {
                            HStack {
                                ZStack {
                                    Image(systemName: "text.justify")
                                    //Image(systemName: "globe")
                                }
                                Text("Environment")
                                    .font(.caption)
                            }
                            .font(.body)
                            //.foregroundColor(CommonUtils.cu_activity_light_text_color)
                            .foregroundColor(ColorScheme.text)
                            .shadow(radius: 1.5)
                        }
                        
                    }
                    .padding(.bottom, 5)
                    */
                    
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
                                //.foregroundColor(CommonUtils.cu_activity_light_text_color)
                                .foregroundColor(ColorScheme.text)
                                .shadow(radius: 1.5)
                            }
                            .padding(.bottom, 5)
                            
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
                                //.foregroundColor(CommonUtils.cu_activity_light_text_color)
                                .foregroundColor(ColorScheme.text)
                                .shadow(radius: 1.5)
                            }
                            .padding(.bottom, 5)
                            
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
                                //.foregroundColor(CommonUtils.cu_activity_light_text_color)
                                .foregroundColor(ColorScheme.text)
                                .shadow(radius: 1.5)
                            }
                            .padding(.bottom, 5)
                            
                        }
                        
                        NavigationLink(destination:
                                        AdvancedSwiftuiAnimations()
                        ) {
                            VStack( alignment: .leading) {
                                HStack {
                                    Image(systemName: "wand.and.rays.inverse")
                                    Text("AdvancedSwiftuiAnimations by SwiftUI Lab")
                                        .font(.caption)
                                }
                                .font(.body)
                                //.foregroundColor(CommonUtils.cu_activity_light_text_color)
                                .foregroundColor(ColorScheme.text)
                                .shadow(radius: 1.5)
                            }
                            .padding(.bottom, 5)
                            
                        }
                        
                        NavigationLink(destination:
                                        SanjaySwiftuiAnimations()
                        ) {
                            VStack( alignment: .leading) {
                                HStack {
                                    ZStack {
                                        Image(systemName: "square")
                                            .scaleEffect(CGSize(width: 1.2, height: 1.2))
                                        Image(systemName: "staroflife")
                                            .scaleEffect(CGSize(width: 1.0, height: 1.0))
                                    }
                                    Text("Sanjay Animation Experiments")
                                        .font(.caption)
                                }
                                .font(.body)
                                //.foregroundColor(CommonUtils.cu_activity_light_text_color)
                                .foregroundColor(ColorScheme.text)
                                .shadow(radius: 1.5)
                            }
                            
                        }
                        Divider()
                    }
                    /*
                    NavigationLink(destination:
                                    EnumerationSampleView()
                    ) {
                        VStack( alignment: .leading) {
                            HStack {
                                ZStack {
                                    Image(systemName: "ellipsis.circle")
                                }
                                Text("Enumeration Code Samples")
                                    .font(.caption)
                            }
                            .font(.body)
                            //.foregroundColor(CommonUtils.cu_activity_light_text_color)
                            .foregroundColor(ColorScheme.text)
                            .shadow(radius: 1.5)
                        }
                    }
                    Divider()
                    */
                    
                    Group {
                        /*
                         Button(action: {
                         let formatter3 = DateFormatter()
                         formatter3.dateFormat = CommonUtils.cu_VideoFileNameDateFormat
                         let dateTimeString = formatter3.string(from: Date())
                         localNotification.setLocalNotification(title: "Local",
                         subtitle: "Notification",
                         body: "Created on \(dateTimeString)",
                         when: 10)
                         }) {
                         VStack( alignment: .leading) {
                         HStack {
                         ZStack {
                         //Image(systemName: "square.stack")
                         //    .scaleEffect(CGSize(width: 1.2, height: 1.2))
                         Image(systemName: "bell")
                         .scaleEffect(CGSize(width: 1.0, height: 1.0))
                         }
                         Text("Create Local Notificaiton in 10 seconds")
                         .font(.caption)
                         }
                         .font(.body)
                         //.foregroundColor(CommonUtils.cu_activity_light_text_color)
                         .foregroundColor(ColorScheme.text)
                         .shadow(radius: 1.5)
                         }
                         }
                         */
                        NavigationLink(destination:
                                        CreateLocalNotificaitonView()
                        ) {
                            VStack( alignment: .leading) {
                                HStack {
                                    ZStack {
                                        Image(systemName: "bell")
                                            .scaleEffect(CGSize(width: 1.0, height: 1.0))
                                    }
                                    Text("Create Local Notificaiton")
                                        .font(.caption)
                                }
                                .font(.body)
                                //.foregroundColor(CommonUtils.cu_activity_light_text_color)
                                .foregroundColor(ColorScheme.text)
                                .shadow(radius: 1.5)
                            }
                            
                        }
                        
                        Button(action: {
                            withAnimation{
                                self.showNotification.toggle()
                            }
                        }) {
                            VStack( alignment: .leading) {
                                HStack {
                                    ZStack( alignment: .bottom ) {
                                        Image(systemName: "square.stack")
                                            .scaleEffect(CGSize(width: 1.0, height: 1.0))
                                        Image(systemName: "bell")
                                            .scaleEffect(CGSize(width: 0.7, height: 0.7))
                                    }
                                    Text("Show Notification List")
                                        .font(.caption)
                                }
                                .font(.body)
                                //.foregroundColor(CommonUtils.cu_activity_light_text_color)
                                .foregroundColor(ColorScheme.text)
                                .shadow(radius: 1.5)
                            }
                        }
                        .sheet(isPresented: $showNotification, content:
                                {NotificationListView(showNotification: $showNotification)})
                        
                        Divider()
                        
                    }
                    
                    /*
                    NavigationLink(destination:
                                    SSWebViewBrowse()
                    ) {
                        VStack( alignment: .leading) {
                            HStack {
                                ZStack {
                                    Image(systemName: "cloud")
                                        .scaleEffect(CGSize(width: 1.0, height: 1.0))
                                }
                                Text("Browse web")
                                    .font(.caption)
                            }
                            .font(.body)
                            //.foregroundColor(CommonUtils.cu_activity_light_text_color)
                            .foregroundColor(ColorScheme.text)
                            .shadow(radius: 1.5)
                        }
                        
                    }
                    Divider()
                    
                    NavigationLink(destination:
                                    CombineFormView()
                    ) {
                        VStack( alignment: .leading) {
                            HStack {
                                ZStack {
                                    Image(systemName: "rectangle")
                                        .scaleEffect(CGSize(width: 1.2, height: 1.5))
                                    Image(systemName: "text.alignleft")
                                        .scaleEffect(CGSize(width: 1.0, height: 1.0))
                                }
                                Text("Form with Inline error validation using combine")
                                    .font(.caption)
                            }
                            .font(.body)
                            //.foregroundColor(CommonUtils.cu_activity_light_text_color)
                            .foregroundColor(ColorScheme.text)
                            .shadow(radius: 1.5)
                        }
                        
                    }
                    Divider()
                    
                    NavigationLink(destination:
                                    ChartDemoView()
                    ) {
                        VStack( alignment: .leading) {
                            HStack {
                                ZStack {
                                    Image(systemName: "chart.bar.xaxis")
                                        .scaleEffect(CGSize(width: 1.0, height: 1.0))
                                }
                                Text("Chart Demo ( using Swift Package ) - WIP")
                                    .font(.caption)
                            }
                            .font(.body)
                            //.foregroundColor(CommonUtils.cu_activity_light_text_color)
                            .foregroundColor(ColorScheme.text)
                            .shadow(radius: 1.5)
                        }
                        
                    }
                    Divider()
                    
                    NavigationLink(destination:
                                    RecordedListView()
                    ) {
                        VStack( alignment: .leading) {
                            HStack {
                                ZStack {
                                    Image(systemName: "squares.below.rectangle")
                                }
                                Text("Screen Recording List")
                                    .font(.caption)
                            }
                            .font(.body)
                            //.foregroundColor(CommonUtils.cu_activity_light_text_color)
                            .foregroundColor(ColorScheme.text)
                            .shadow(radius: 1.5)
                        }
                    }
                    Divider()
                    */
                    
                    Spacer()
                }
                .padding(5)
                //.background(ColorScheme.theam)
                //.navigationBarTitle("")
                //.navigationBarHidden(true)
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
                                    , trailing:
                                        Button(action: {
                                            presentedSettings.toggle()
                                        }, label: {
                                            Image(systemName: "text.justify")
                                                .padding(.vertical,5)
                                        })
                )
            }
        }
        .sheet(isPresented: $presentedSettings, content: {SanjaySwiftUIOptions(self.whoAmI)})
        // multiple sheets can be presented on different Views
        // for eg. check $presentedSettings and $showNotification
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView(menuSelection: .constant(1), currentPos: .constant(-1))
    }
}
