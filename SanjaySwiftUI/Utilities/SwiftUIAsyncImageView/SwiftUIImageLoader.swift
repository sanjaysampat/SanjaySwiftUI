//
//  SwiftUIViewImageLoader.swift
//  SanjaySwiftUI
//
//  Created by Sanjay Sampat on 09/08/20.
//  Copyright © 2020 Sanjay Sampat. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

class SwiftUIImageLoader: ObservableObject {
    @Published var image : UIImage?
    private let url : URL?
    private var cancellable: AnyCancellable?

    init(url:URL?) {
        self.url = url
    }
    
    deinit {
        cancellable?.cancel()
    }

    func load() {
        if let url = self.url {
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .assign(to: \.image, on: self)
        }
    }

    func cancel() {
        cancellable?.cancel()
    }
    
}

