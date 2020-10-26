//
//  CommonExtensions.swift
//  SanjaySwiftUI
//
//  Created by Sanjay Sampat on 10/08/20.
//  Copyright © 2020 Sanjay Sampat. All rights reserved.
//

import Foundation
import SwiftUI

// Alphabetically kept

extension Collection {
    func choose(_ n: Int) -> ArraySlice<Element> { shuffled().prefix(n) }
}

extension Image {
    // init to create UIImage or show placeholderSystemName image.
    public init(uiImage: UIImage?, placeholderSystemName: String) {
        guard let uiImage = uiImage else {
            self = Image(systemName: placeholderSystemName)

            return
        }
        self = Image(uiImage: uiImage)
    }
}

extension View {
    // useful to print messages in Debug area from SwiftUI View
    func PrintinView(_ vars: Any...) -> some View {
        for v in vars { print(v) }
        return EmptyView()
    }
}
