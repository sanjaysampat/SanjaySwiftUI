//
//  UserAuth.swift
//  SanjaySwiftUI
//
//  Created by Sanjay Sampat on 07/08/20.
//  Copyright © 2020 Sanjay Sampat. All rights reserved.
//

import Foundation

class UserAuth: ObservableObject {
    
    @Published var isLoggedin:Bool = false

    func login() {
        self.isLoggedin = true
    }

}
