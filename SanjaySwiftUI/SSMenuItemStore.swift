//
//  SSMenuItemStore.swift
//  SanjaySwiftUI
//
//  Created by Sanjay Sampat on 02/02/21.
//  Copyright © 2021 Sanjay Sampat. All rights reserved.
//

import SwiftUI
import Combine

class SSMenuItemStore: ObservableObject {
    var ssMenuItems: [SSMenuItem] {
        willSet { objectWillChange.send() }
    }
    
    init(ssMenuItems: [SSMenuItem] = []) {
        self.ssMenuItems = ssMenuItems
    }
    
    let objectWillChange = PassthroughSubject<Void, Never>()
    
}

