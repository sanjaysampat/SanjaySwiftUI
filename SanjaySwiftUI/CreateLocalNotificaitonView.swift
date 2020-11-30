//
//  CreateLocalNotificaitonView.swift
//  SanjaySwiftUI
//
//  Created by Sanjay Sampat on 30/11/20.
//  Copyright © 2020 Sanjay Sampat. All rights reserved.
//

import SwiftUI

struct CreateLocalNotificaitonView: View {
    
    @StateObject var localNotification = LocalNotification()

    @State private var notetitle: String = ""
    @State private var noteSubtitle: String = ""
    @State private var noteBody: String = ""

    //@State private var setTime: ClockTime = ClockTime(0, 0, 0)
    @State private var setHours: Int = 0
    @State private var setMinutes: Int = 0
    @State private var setSeconds: Int = 10
    
    //@State private var currentTime: ClockTime = ClockTime(0, 0, 0)
    @State private var currentHours: Int = 0
    @State private var currentMinutes: Int = 0
    @State private var currentSeconds: Int = 0
    
    @State private var duration: Double = 2.0

    @State private var alertPresented: Bool = false

    private let timer = Timer.publish(
        every: 15, // second
        on: .main,
        in: .common
    ).autoconnect()

    var body: some View {
        
        ScrollView {
            
            editNotificationText(noteHead: "Title:", noteText: $notetitle)
            
            editNotificationText(noteHead: "Subtitle:", noteText: $noteSubtitle)
            
            editNotificationText(noteHead: "Body:", noteText: $noteBody)
            
            Button(action: {
                self.endEditing()
                alertPresented = true
            }) {
                VStack( alignment: .center) {
                    Text("Create")
                        .font(.title)
                }
                .foregroundColor(CommonUtils.cu_activity_light_text_color)
            }
            .alert(isPresented: $alertPresented) {
                if notetitle.isEmpty &&
                    noteSubtitle.isEmpty &&
                    noteBody.isEmpty
                    {
                    return Alert(title: Text("Local Notification"), message: Text("Currently we can not generate empty notification. Please set title, subtitle and body of notification.") )
                } else if (self.setHours * 3600 + self.setMinutes * 60 + self.setSeconds) < 10 {
                    return Alert(title: Text("Local Notification"), message: Text("Currently notification can be sent after 10 seconds only. Set the timer with minimum 10 seconds.") )
                } else {
                return Alert(
                    title: Text("Local Notification"), message: Text("Do you want to create the local notifiation which will appear approximately after \(setHours) hours, \(setMinutes) minutes and \(setSeconds) seconds ?"),
                    primaryButton: Alert.Button.destructive(Text("Create")) {
                        let formatter3 = DateFormatter()
                        formatter3.dateFormat = CommonUtils.cu_VideoFileNameDateFormat
                        let dateTimeString = formatter3.string(from: Date())
                        localNotification.setLocalNotification(title: notetitle,
                                                               subtitle: noteSubtitle,
                                                               body: """
                                                                            \(noteBody)
                                                                            Created on \(dateTimeString)
                                                                        """,
                                                               when: Double(self.setHours * 3600 + self.setMinutes * 60 + self.setSeconds))
                    }, secondaryButton: .cancel()
                )
                }
                
            }
            
            Text("[after \(setHours) hours, \(setMinutes) minutes and \(setSeconds) seconds]")
            
            ZStack {
                ClockShape(clockTime: ClockTime(currentHours, currentMinutes, Double(currentSeconds)) + ClockTime(setHours, setMinutes, Double(setSeconds)))
                    .stroke(Color.pink, lineWidth: 2)
                    .frame(minWidth: 200, idealWidth: 200, minHeight: 200, idealHeight: 200, alignment: .center)
                    .padding(20)
                    .animation(.easeInOut(duration: duration))
                    .layoutPriority(1)
                    .opacity(0.10)
                
                HStack {
                    VStack {
                        Text("Hours")
                        Picker("", selection: $setHours) {
                            ForEach((0...11), id: \.self) { index in
                                Text("\(index)")
                            }
                        }
                        .pickerStyle(InlinePickerStyle())
                        .frame(width: 100, height:100)
                        .clipped(antialiased: true)
                    }
                    .padding(.vertical, 10)
                    .background(Color.yellow.opacity(0.1))
                    
                    VStack {
                        Text("Minutes")
                        Picker("", selection: $setMinutes) {
                            ForEach((0...59), id: \.self) { index in
                                Text("\(index)")
                            }
                        }
                        .pickerStyle(InlinePickerStyle())
                        .frame(width: 100, height:100)
                        .clipped(antialiased: true)
                    }
                    .padding(.vertical, 10)
                    .background(Color.yellow.opacity(0.1))
                    
                    VStack {
                        Text("Seconds")
                        Picker("", selection: $setSeconds) {
                            ForEach((0...59), id: \.self) { index in
                                Text("\(index)")
                            }
                        }
                        .onChange(of: setSeconds, perform: { (value) in
                            //setTime = ClockTime(setTime.hours, setTime.minutes, Double(value))
                        })
                        .pickerStyle(InlinePickerStyle())
                        .frame(width: 100, height:100)
                        .clipped(antialiased: true)
                    }
                    .padding(.vertical, 10)
                    .background(Color.yellow.opacity(0.1))
                    
                }
            }
            .onReceive(timer) { (_) in
                updateCurrentTime()
            }
        }
        .navigationBarTitle(Text("Create Local Notificaiton"), displayMode: .inline)
        .onAppear() {
            updateCurrentTime()
        }
    }
    
    func updateCurrentTime() {
        let date = Date()
        let calendar = Calendar.current

        //if let timeZone = TimeZone(identifier: "EST") {
        //   calendar.timeZone = timeZone
        //}

        self.currentHours = calendar.component(.hour, from: date)
        self.currentMinutes = calendar.component(.minute, from: date)
        self.currentSeconds = calendar.component(.second, from: date)
        //self.currentTime = ClockTime(hour, minute, Double(second)) + ClockTime(setHours, setMinutes, Double(setSeconds))
    }
}

struct editNotificationText: View {

    var noteHead:String = ""
    @Binding var noteText:String
    
    var body: some View {
        HStack {
        Text("\(noteHead)")
            
        TextEditor(text: $noteText)
            .padding(.all, 2)
            .background(Color.yellow.opacity(0.1))
            
        }
        .padding(.horizontal)
        .padding(.vertical, 3)
    }
}

struct CreateLocalNotificaitonView_Previews: PreviewProvider {
    static var previews: some View {
        CreateLocalNotificaitonView()
    }
}
