//
//  SwiftUIAsyncImageView.swift
//  SanjaySwiftUI
//
//  Created by Sanjay Sampat on 09/08/20.
//  Copyright © 2020 Sanjay Sampat. All rights reserved.
//

import SwiftUI

struct SwiftUIAsyncImageView<Placeholder: View>: View {
    @ObservedObject private var loader: SwiftUIImageLoader
    private let placeholder: Placeholder?
    
    init(url: URL?, placeholder: Placeholder? = nil) {
        loader = SwiftUIImageLoader(url: url)
        self.placeholder = placeholder
    }

    var body: some View {
        image
            .onAppear(perform: loader.load)
            .onDisappear(perform: loader.cancel)
    }
    
    private var image: some View {
        Group {
            if loader.image != nil {
                Image(uiImage: loader.image!)
                    .resizable()
                    .scaledToFit()
            } else {
                placeholder
            }
        }
    }
    
}

/*
struct SwiftUIAsyncImageView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIAsyncImageView()
    }
}
*/
