//
//  NoCommit.swift
//  SanjaySwiftUI
//
//  Created by Sanjay Sampat on 09/08/20.
//  Copyright © 2020 Sanjay Sampat. All rights reserved.
//

import Foundation
import SwiftUI

struct PublicCommit {
    
    static let nc_email = "sanjaysampat"
    
    static let nc_signinurl = "https://****/services/signin.html"
    
    static let nc_signinDataString : [String: Any] = [
        "Token": "****",
        "TokenType": "2",
        "RegisterId": "POSTMAN",
        "APIKEY": "****",
        "SECRETKEY": "****",
        "CompanyCode": "00013",
        "UserName": "****",
        "Password": "1234"
    ]
    
    static let nc_tonyselectioncategoriesurl = "https://****/****"
    
    static let nc_tonyselectioncategoriesDataString : [String: Any] = [
        "security_key" : "****"
    ]
    
    static let nc_mostlovedcategoriesurl = "https://****/****"
    
    static let nc_mostlovedcategoriesDataString : [String: Any] = [
        "security_key" : "****"
    ]

}
