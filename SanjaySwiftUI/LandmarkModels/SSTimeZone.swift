//
//  SSTimeZone.swift
//  SanjaySwiftUI
//
//  Created by Sanjay Sampat on 09/10/21.
//  Copyright © 2021 Sanjay Sampat. All rights reserved.
//

import Foundation

struct SSTimeZone : Identifiable {
    
    let id: UUID = UUID()
    let city, continent, abbreviation, localizedName: String
    let secondsFromGMT: Int
}
