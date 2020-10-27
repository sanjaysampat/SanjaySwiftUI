//
//  UserSettings.swift
//  SanjaySwiftUI
//
//  Created by Sanjay Sampat on 27/10/20.
//  Copyright © 2020 Sanjay Sampat. All rights reserved.
//

import Foundation

class UserSettings: ObservableObject {
    
    // e21
    @Published var e21PickCardsCount:Int = 26 // 1 to 52 divided between total players
    @Published var e21TotalPlayers:Int = 2
    // e21 - Player 1
    @Published var e21P1ShowCards:Bool = true
    @Published var e21P1ShowMode:String = "Fixed"
    @Published var e21P1FixedModeDegree:Double = 140.0
    @Published var e21P1CompactModeDegree:Double = 12
    // e21 - Player 2
    @Published var e21P2ShowCards:Bool = true
    @Published var e21P2ShowMode:String = "Compact"
    @Published var e21P2FixedModeDegree:Double = 100.0
    @Published var e21P2CompactModeDegree:Double = 6

    func setDefaultValues() {
        // e21
        self.e21TotalPlayers = 2
        self.e21P1ShowCards = true
        self.e21P1ShowMode = "Fixed"
        self.e21P1FixedModeDegree = 140.0
        self.e21P1CompactModeDegree = 12
        self.e21P2ShowCards = true
        self.e21P2ShowMode = "Compact"
        self.e21P2FixedModeDegree = 100.0
        self.e21P2CompactModeDegree = 6
        self.e21PickCardsCount = 26
        //
    }
    
}
