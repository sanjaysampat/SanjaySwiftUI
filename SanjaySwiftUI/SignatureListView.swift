//
//  SignatureListView.swift
//  SanjaySwiftUI
//
//  Created by Sanjay Sampat on 18/11/20.
//  Copyright © 2020 Sanjay Sampat. All rights reserved.
//

import SwiftUI

struct SignatureListView: View {
    @State private var confirmationShow = false
    @State private var message1:String = ""
    @State private var message2:String = ""
    @State private var deleteState = 0
    @State private var nextTic = false
    @State private var selectedIndex = -1
    
    // SSNote : 1 - The method is more time accurate. This is continus calling.
    let timer = Timer.publish(every: 30, on: .main, in: .common).autoconnect()  // SSNote : 1
    
    // SSNote : 2 - The method is less time accurate. This is for one time calling only.
    //@State private var timerAsync: ()  // SSNote : 2
    
    init() {
        reloadSignaturesDataWithShuffle()
    }
    
    var body: some View {
        VStack {
            Text("Signatures are SVG files from assets")
            Text("\(message1)")
                .foregroundColor(deleteState > 0 ? .red : ColorScheme.text)
                .font(.system(size: 11)) +
            Text(" \(message2)")
                .foregroundColor(.gray)
                .font(.system(size: 11))
            if #available(iOS 15.0, *) {
                List{
                    ForEach(signaturesData, id: \.self) { signatureSingle in
                        SignatureRow(signature: signatureSingle)
                            .swipeActions {
                                Button(
                                    role: .destructive,
                                    action: {
                                        selectedIndex = signaturesData.firstIndex(of: signatureSingle) ?? -1
                                        if selectedIndex >= 0 {
                                            confirmationShow = true
                                            //print("selection : \(selectedIndex) : \(signatureSingle.name)")
                                        }
                                    }
                                ) {
                                    Image(systemName: "trash")
                                }
                            }
                            .confirmationDialog(
                                "Are you sure?",
                                isPresented: $confirmationShow,
                                titleVisibility: .visible // .automatic
                            ) {
                                Button("Yes") {
                                    confirmationShow = false
                                    if selectedIndex >= 0 && signaturesData.count > selectedIndex {
                                        let signatureRec = signaturesData[selectedIndex]
                                        //print("delete : \(selectedIndex) : \(signatureRec.name)")
                                        withAnimation {
                                            signaturesData.remove(at: selectedIndex)
                                            // SSNote : required the following change to message1 - for refresh of list,
                                            message1 = "\(signaturesData.count) total signatures after deletion"
                                            deleteState = 1
                                            nextTic = false    // SSNote : 1
                                            selectedIndex = -1
                                            
                                            // SSNote : 2
                                            /*timerAsync = DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(30)) {
                                                message1 = ""
                                                print("deleted")
                                            }*/
                                        }
                                    }
                                }
                                Button("No", role: .cancel) {
                                    confirmationShow = false
                                    selectedIndex = -1
                                }
                            } message: {
                                Text("you want to delete signature of \(selectedIndex >= 0 && signaturesData.count > selectedIndex ? signaturesData[selectedIndex].name : "(no record)")")
                            }
                    }
                    .listRowSeparatorTint(Color.green)
                    .listRowSeparator(.visible, edges: .all)
                }
                .listStyle(.grouped)
                .refreshable {
                    // SSNote : Pull to Refresh funtionality of List
                    reloadSignaturesDataWithShuffle()
                    message1 = "\(signaturesData.count) total signatures"
                    deleteState = 0
                    nextTic = false    // SSNote : 1
                    
                    // SSNote : 2
                    /*timerAsync = DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(30)) {
                        message1 = ""
                        print("deleted")
                    }*/
                    
                }
                .onAppear() {
                    message2 = "Pull to Refresh"
                }
                // SSNote : 1
                .onReceive(timer) { _ in
                    //print("tic.")
                    if !message1.isEmpty {
                        if nextTic {
                            message1 = ""
                            nextTic = false
                        } else {
                            nextTic = true
                        }
                    }
                }
                
            } else {
                ScrollView(.vertical) {
                    ForEach(signaturesData) { signature in
                        SignatureRow(signature: signature)
                    }
                }
            }
        }
    }
}

struct SignatureRow: View {
    @State var signature:Signature
    
    var body: some View {
        VStack {
            signature.signatureImage
                .resizable()
                .scaledToFit()
                .font(Font.title.weight(.ultraLight))
                .frame(minWidth: 100, idealWidth: 200, maxWidth: 400, minHeight: 100, idealHeight: 200, maxHeight: 200)
                .background(ColorScheme.text)
                .cornerRadius(20)
            
            HStack {
                signature.photoImage
                    .resizable()
                    .scaledToFit()
                    .font(Font.title.weight(.ultraLight))
                    .frame(minWidth: 30, idealWidth: 50, maxWidth: 50, minHeight: 30, idealHeight: 50, maxHeight: 50)
                Group {
                    // Open Url - On click open the link in Safari
                    if let url = URL(string: signature.wikipedia) {
                        Link(signature.name, destination: url)
                    } else {
                        Text(signature.name)
                    }
                }
                //.foregroundColor(CommonUtils.cu_activity_background_color)
                .foregroundColor(ColorScheme.text)   //(ColorScheme.background)
                .shadow(radius: 1.5)
            }
        }
    }
}

struct SignatureListView_Previews: PreviewProvider {
    static var previews: some View {
        SignatureListView()
    }
}
