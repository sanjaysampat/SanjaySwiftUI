//
//  SigninUser.swift
//  SanjaySwiftUI
//
//  Created by Sanjay Sampat on 08/08/20.
//  Copyright © 2020 Sanjay Sampat. All rights reserved.
//

struct SigninUser: Codable, Identifiable {
    public var id: String = ""
    public var token: String = ""
    public var profileData : ProfileData = ProfileData()
    //public var companyData : CompanyData
    
    enum CodingKeys: String, CodingKey {
        case id = "UserId"
        case token = "UserToken"
        case profileData = "Profile_Data"
        //case copmanyData = "Company_Data"
    }
    
}

struct CompanyData: Codable {
    public var abc: String
}

struct ProfileData: Codable {
    public var UserFirstName : String = ""
    public var UserLastName : String = ""
    public var UserEmail : String = ""
    public var UserMobile : String = ""
    public var UserDateOfBirth : String = ""
    public var UserRoleId : String = ""
    public var UserRole : String = ""
    public var UserIsPrimaryUser : String = ""
    public var UserProfileImagePathActual : String = ""
    
}

struct Users: Codable {
    public var users : [SigninUser] = []
}
