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
    public var companyData : UserCompanyData = UserCompanyData()
    public var profileData : UserProfileData = UserProfileData()

    enum CodingKeys: String, CodingKey {
        case id = "UserId"
        case token = "UserToken"
        case companyData = "Company_Data"
        case profileData = "Profile_Data"
    }
    
}

struct UserCompanyData: Codable {
    public var UserCompanyEmail: String = ""
    public var UserCompanyWebsite: String = ""
    public var UserCompanyLogo: String = ""
    public var UserCompanyAddress: String = ""
    public var UserCompanyDescription: String = ""
}

struct UserProfileData: Codable {
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
