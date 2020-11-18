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
                        .frame(minWidth: 100, idealWidth: 200, maxWidth: 400, minHeight: 100, idealHeight: 200, maxHeight: 200)
                    
                    Text(signature.name)
                        .foregroundColor(CommonUtils.cu_activity_background_color)
                        .shadow(radius: 1.5)
                    // SSTODO on gesture open the link in external browser
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
