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
    @Published var imageLoaded : UIImage?
    
    private let url : URL?
    private var cancellable: AnyCancellable?
    private var cache: ImageCache?
    private(set) var isLoading = false

    private static let imageProcessingQueue = DispatchQueue(label: "image-processing")
    
    init(url:URL?, cache: ImageCache? = nil) {
        self.url = url
        self.cache = cache
    }
    
    deinit {
        cancellable?.cancel()
    }
    
    func load() {
        guard !isLoading else { return }
        
        if let url = self.url, let image = cache?[url] {
            self.imageLoaded = image
            return
        }
        
        // SSCHECK Combine's Publisher example of URLSession with Escaping closure
        if let url = self.url {
            cancellable = URLSession.shared.dataTaskPublisher(for: url)
                 .subscribe(on: Self.imageProcessingQueue)
                // Escaping closure
                .map { UIImage(data: $0.data) }
                .replaceError(with: nil)
                .handleEvents(receiveSubscription: { [weak self] _ in self?.onStart() },
                              receiveOutput: { [weak self] in self?.cache($0) },
                              receiveCompletion: { [weak self] _ in self?.onFinish() },
                              receiveCancel: { [weak self] in self?.onFinish() })
                .receive(on: DispatchQueue.main)
                .assign(to: \.imageLoaded, on: self)
        }
    }
    
    private func onStart() {
        isLoading = true
    }
    
    private func onFinish() {
        isLoading = false
    }

    private func cache(_ image: UIImage?) {
        if let url = self.url {
            image.map { cache?[url] = $0 }
        }
    }
    
    func cancel() {
        cancellable?.cancel()
    }
    
}

