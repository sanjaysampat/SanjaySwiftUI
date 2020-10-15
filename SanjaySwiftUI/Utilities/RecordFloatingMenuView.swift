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
    
    //let buttonArray: [String]
    //let onClick: (String)->()
    @State var buttonsPos:UnitPoint = .bottomTrailing
    @State var showButtons = false
    @State var isRecording = false
    
    fileprivate let buttonArray:[ButtonImages] = [ButtonImages.arrowUpLeft, ButtonImages.arrowUpRight, ButtonImages.arrowDownLeft, ButtonImages.arrowDownRight, ButtonImages.record]

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
                            askToStartScreenRecord()
                        }

                    }, label: {
                        Image(systemName: buttonImage.rawValue)
                            .foregroundColor(.white)
                            .font(.body)
                    }).padding(.all, 10)
                    .background(CommonUtils.cu_activity_foreground_color)
                    .opacity(0.75)
                    .clipShape(Circle())
                    .padding(.all, 2.5)
                    .transition(
                        .move(
                            edge: (buttonsPos == .bottomTrailing || buttonsPos == .topTrailing) ? .trailing : .leading
                        )
                    )
                }
            }
            //else {
                //EmptyView()
            //}
        }
    }
    
    var menuButton: some View {
        /* SSTODO
         when recording start continuing transation of .scale for the button
         change the button color to Red
        */
        
        Button(action: {
            if isRecording {
                isRecording.toggle()
            } else
            {
                withAnimation {
                    showButtons.toggle()
                }
            }
        }, label: {
            Image(systemName: isRecording ? "dot.square.fill" : ( showButtons ? "minus" : "plus" ) )
                .foregroundColor(.white)
                .font(.headline)
                .frame(width: 40, height: 40)
        })
        .background(CommonUtils.cu_activity_foreground_color)
        .opacity(0.75)
        .clipShape(Circle())
        .padding(10)
    }
    
    func askToStartScreenRecord() {
        isRecording.toggle()
        
        /*  SSTODO
        screenRecorder.stoprecording(errorHandler: { error in
          debugPrint("Error when stop recording \(error)")
        })

         // SSTODO to save recording in document folder, will show the list in ListView in LazyHStack
        screenRecorder.startRecording(saveToCameraRoll: false, errorHandler: { error in
          debugPrint("Error when recording \(error)")
        })
        */
    }

}




struct RecordFloatingMenuView_Previews: PreviewProvider {
    static var previews: some View {
        RecordFloatingMenuView()
        //RecordFloatingMenuView(buttonArray: [], onClick: { buttonObject in
        //    print("\(buttonObject) Clicked")
        //})
    }
}
