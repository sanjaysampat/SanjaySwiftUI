//
//  RoomStore.swift
//  SanjaySwiftUI
//
//  Created by Sanjay Sampat on 30/09/20.
//  Copyright © 2020 Sanjay Sampat. All rights reserved.
//

import SwiftUI
import Combine

class RoomStore: ObservableObject {
    var rooms: [Room] {
        willSet { objectWillChange.send() }
    }
    
    init(rooms: [Room] = []) {
        self.rooms = rooms
    }
    
    let objectWillChange = PassthroughSubject<Void, Never>()
    
    func roomArrayFoundFrom(searchQuery query:String) -> [Room] {
        let roomArray = rooms.compactMap {
            $0.name.lowercased().contains(query.lowercased()) ? $0 : nil
        }
        return roomArray
    }
    
}
