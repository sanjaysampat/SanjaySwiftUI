//
//  SigninSuccess.swift
//  SanjaySwiftUI
//
//  Created by Sanjay Sampat on 08/08/20.
//  Copyright © 2020 Sanjay Sampat. All rights reserved.
//

struct SigninSuccess: Codable {
    //public var users: Users = Users()
    public var users: [SigninUser] = []
    // In case of Error
    public var ErrorCode: String = ""
    public var ErrorMessage: String = ""
    public var AccessToken: String = ""
    public var CompanyUserId: String = ""
    
    enum CodingKeys: String, CodingKey {
        case users = "Success"
        case ErrorCode
        case ErrorMessage
        case AccessToken
        case CompanyUserId
    }
    
    // SSNote how to decode signInUsers or "Success" or Users()
    // take help of "https://matteomanferdini.com/codable/"
    
    init( from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            //users = try container.decodeIfPresent(Users.self, forKey: .users) ?? Users()
            users = try container.decodeIfPresent([SigninUser].self, forKey: .users)!
        } catch {
            print("Error: SignIn decoder : \(error).")
        }
        ErrorCode = try container.decodeIfPresent(String.self, forKey: .ErrorCode) ?? ""
        ErrorMessage = try container.decodeIfPresent(String.self, forKey: .ErrorMessage) ?? ""
        AccessToken = try container.decodeIfPresent(String.self, forKey: .AccessToken) ?? ""
        CompanyUserId = try container.decodeIfPresent(String.self, forKey: .CompanyUserId) ?? ""

    }
    
    init() {
        
    }
}
