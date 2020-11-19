//
//  SignatureListView.swift
//  SanjaySwiftUI
//
//  Created by Sanjay Sampat on 18/11/20.
//  Copyright © 2020 Sanjay Sampat. All rights reserved.
//

import SwiftUI

struct SignatureListView: View {
    
    init() {
        reloadSignaturesDataWithShuffle()
    }
    
    var body: some View {
        VStack {
            Text("Signatures are SVG files from assets")
            ScrollView(.vertical) {
                ForEach(signaturesData) { signature in
                    VStack {
                        signature.signatureImage
                            .resizable()
                            .scaledToFit()
                            .font(Font.title.weight(.ultraLight))
                            .frame(minWidth: 100, idealWidth: 200, maxWidth: 400, minHeight: 100, idealHeight: 200, maxHeight: 200)
                        
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
                            .foregroundColor(CommonUtils.cu_activity_background_color)
                            .shadow(radius: 1.5)
                        }
                    }
                }
            }
        }
    }
}

struct SignatureListView_Previews: PreviewProvider {
    static var previews: some View {
        SignatureListView()
    }
}
