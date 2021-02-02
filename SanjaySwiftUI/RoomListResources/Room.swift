//
//  Room.swift
//  Rooms
//
//  Created by Jan Zavrel on 23.12.2019.
//  Copyright © 2019 Jan Zavrel. All rights reserved.
//

import SwiftUI
import CoreLocation

struct Room: Identifiable {
    var id = UUID()
    var name: String
    var building: String
    var floor: String
    var capacity: Int
    var hasVideo: Bool = false
    var imageName: String
    var coordinates: Coordinates
    var annotaionItemPlaces : [SSAnnotaionItemPlace] = []
    var mapZoomLevel: Double = 0.005      // near 0.0 to wide 1.0

    var locationCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: coordinates.latitude,
            longitude: coordinates.longitude)
    }
    
    
}

let testRoomData = [
    Room(name: "Tree Room", building: "A", floor: "1", capacity: 6, hasVideo: true, imageName: "room01", coordinates: Coordinates(latitude: 19.229497, longitude: 72.864994), annotaionItemPlaces: [
        SSAnnotaionItemPlace(name: "Tree Room", latitude: 19.229497, longitude: 72.864994),
        SSAnnotaionItemPlace(name: "Eat - Paratha Zone", latitude: 19.229932, longitude: 72.864297),
        SSAnnotaionItemPlace(name: "Eat - Saffron", latitude:  19.229750, longitude: 72.864608),
        SSAnnotaionItemPlace(name: "Eat - Greens Veg Restaurant", latitude: 19.230172, longitude: 72.862070)
      ]
    ),
    Room(name: "Yellow Matrix", building: "D", floor: "3", capacity: 1, hasVideo: false, imageName: "room09", coordinates: Coordinates(latitude: 56.948889, longitude: 24.106389), annotaionItemPlaces: [
        SSAnnotaionItemPlace(name: "Yellow Matrix", latitude: 56.948889, longitude: 24.106389),
        SSAnnotaionItemPlace(name: "Eat - Kozy Eats", latitude: 56.951924, longitude: 24.125584),
        SSAnnotaionItemPlace(name: "Eat - Green Pumpkin", latitude:  56.967520, longitude: 24.105760),
        SSAnnotaionItemPlace(name: "Eat - Terapija", latitude: 56.9539906, longitude: 24.1364929)
    ], mapZoomLevel : 0.10
    ),
    Room(name: "Lamp & Pillows", building: "B", floor: "1", capacity: 8, hasVideo: false, imageName: "room02", coordinates: Coordinates(latitude: 19.229497, longitude: 72.864994)),
    Room(name: "Red Looks Great", building: "D", floor: "2", capacity: 16, hasVideo: true, imageName: "room03", coordinates: Coordinates(latitude: 56.948889, longitude: 24.106389)),
    Room(name: "Bug On The Wall", building: "A", floor: "3", capacity: 10, hasVideo: true, imageName: "room04", coordinates: Coordinates(latitude: 56.948889, longitude: 24.106389)),
    Room(name: "Candles", building: "C", floor: "3", capacity: 12, hasVideo: false, imageName: "room05", coordinates: Coordinates(latitude: 56.948889, longitude: 24.106389)),
    Room(name: "Queen Size", building: "F", floor: "1", capacity: 8, hasVideo: false, imageName: "room06", coordinates: Coordinates(latitude: 56.948889, longitude: 24.106389)),
    Room(name: "Small But Sweet", building: "E", floor: "1", capacity: 10, hasVideo: true, imageName: "room07", coordinates: Coordinates(latitude: 56.948889, longitude: 24.106389)),
    Room(name: "Modern Screen", building: "B", floor: "4", capacity: 7, hasVideo: false, imageName: "room08", coordinates: Coordinates(latitude: 56.948889, longitude: 24.106389))
]
