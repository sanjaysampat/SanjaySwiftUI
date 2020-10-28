//
//  RecordFloatingMenuView.swift
//  SanjaySwiftUI
//
//  Created by Sanjay Sampat on 15/10/20.
//  Copyright © 2020 Sanjay Sampat. All rights reserved.
//

import SwiftUI

struct RecordFloatingMenuView: View {
    
    enum ButtonImages : String {
        case arrowUpLeft = "arrow.turn.up.left"
        case arrowUpRight = "arrow.turn.up.right"
        case arrowDownLeft = "arrow.turn.down.left"
        case arrowDownRight = "arrow.turn.down.right"
        case record = "dot.square"
    }
    
    // if we need to pass menu buttons and closure from calling view.
    //let buttonArray: [String]
    //let onClick: (String)->()
    
    @State var buttonsPos:UnitPoint = .bottomTrailing
    @State var showButtons = false
    @State var isRecording = false
    @State var recordAlertShown = false
    @State var recordErrorShown = false
    
    @State var animateFrame = false
    
    fileprivate let buttonArray:[ButtonImages] = [ButtonImages.arrowUpLeft, ButtonImages.arrowUpRight, ButtonImages.arrowDownLeft, ButtonImages.arrowDownRight, ButtonImages.record]
    
    private let screenRecorder = ScreenRecorder()
    
    var body: some View {
        HStack {
            if buttonsPos == .bottomTrailing || buttonsPos == .topTrailing {
                Spacer()
            }
            VStack {
                if buttonsPos == .bottomLeading || buttonsPos == .bottomTrailing {
                    Spacer()
                    menuButtonViews
                }
                menuButton
                if buttonsPos == .topLeading || buttonsPos == .topTrailing {
                    menuButtonViews
                    Spacer()
                }
            }
            if buttonsPos == .bottomLeading || buttonsPos == .topLeading {
                Spacer()
            }
        }.padding(.all, 10)
    }
    
    var menuButtonViews: some View {
        Group {
            if showButtons && !isRecording {
                ForEach(buttonArray, id: \.self) { buttonImage in
                    Button(action: {
                        
                        switch buttonImage {
                        case .arrowUpLeft:
                            buttonsPos = .topLeading
                        case .arrowUpRight:
                            buttonsPos = .topTrailing
                        case .arrowDownLeft:
                            buttonsPos = .bottomLeading
                        case .arrowDownRight:
                            buttonsPos = .bottomTrailing
                        case .record:
                            //// SSTODO for test - direct record//// self.toggleScreenRecord()
                            self.recordAlertShown = true
                        }
                        
                    }, label: {
                        Image(systemName: buttonImage.rawValue)
                            .foregroundColor(.white)
                            .font(.body)
                    }).padding(.all, 10)
                    .background(CommonUtils.cu_activity_foreground_color)
                    .opacity(0.75)
                    .clipShape(Circle())
                    .padding(.all, 1)
                    .transition(
                        .move(
                            edge: (buttonsPos == .bottomTrailing || buttonsPos == .topTrailing) ? .trailing : .leading
                        )
                    )
                }
            }
        }
    }
    
    var menuButton: some View {
        Group {
            if isRecording {
                Button(action: {
                    toggleScreenRecord()
                }, label: {
                    Image(systemName: "dot.square.fill")
                        .foregroundColor(.white)
                        .font(.headline)
                        .frame(width: self.animateFrame ? 40 : 30 , height: self.animateFrame ? 40 : 30)
                    
                })
                .background(CommonUtils.cu_activity_foreground_color)
                .clipShape(Circle())
                .padding(5)
                .onAppear {
                    withAnimation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                        self.animateFrame.toggle()
                    }
                }

            } else {
                Button(action: {
                    withAnimation {
                        showButtons.toggle()
                    }
                }, label: {
                    Image(systemName: showButtons ? "minus" : "plus" )
                        .foregroundColor(.white)
                        .font(.headline)
                        .frame(width: 40, height: 40)
                })
                .background(CommonUtils.cu_activity_foreground_color)
                .opacity(0.75)
                .clipShape(Circle())
                .padding(5)
                .alert(isPresented: $recordAlertShown) {
                    Alert(
                        title: Text("Record"), message: Text("Do you want to record the screen video?"),
                        primaryButton: Alert.Button.destructive(Text("Record")) {
                            toggleScreenRecord()
                        }, secondaryButton: .cancel()
                    )
                }/*
                 //// SSTODO we can not call more then one alert in one view.
                 //// we need to use different approach
                .alert(isPresented: $recordErrorShown) {
                    Alert(
                        title: Text("Error"), message: Text("Error recording the screen video."), dismissButton: Alert.Button.default(Text("OK")) {self.isRecording = false}
                    )
                }*/
            }
        }
    }
    
    func toggleScreenRecord() {
        
        if isRecording {
            self.isRecording = false
            
            // SSTODO This does not work in simulator, but works in actual device.
            screenRecorder.stoprecording(errorHandler: { error in
                debugPrint("Error when stop recording \(error)")
            })
            
        } else {
            let formatter3 = DateFormatter()
            formatter3.dateFormat = "yyyyMMddHHmmss"
            let dateTimeString = formatter3.string(from: Date())
            let fileUrl = URL(fileURLWithPath: CommonUtils.cuScreenRecordFolder.stringByAppendingPathComponent(path: "\(dateTimeString).mp4"))
            // SSTODO to save recording in document folder, will show the list in ListView in LazyHStack
            self.isRecording = true
            
            // SSTODO This does not work in simulator, but works in actual device.
            screenRecorder.startRecording(to:fileUrl, saveToCameraRoll: true, errorHandler: { error in
                debugPrint("Error when recording \(error)")
                self.isRecording = false
                self.recordErrorShown = true
            }
            )
            
        }
    }
    
}




struct RecordFloatingMenuView_Previews: PreviewProvider {
    static var previews: some View {
        RecordFloatingMenuView()
        // if we need to pass menu buttons and closure from calling view.
        //RecordFloatingMenuView(buttonArray: [], onClick: { buttonObject in
        //    print("\(buttonObject) Clicked")
        //})
    }
}
