//
//  TonySectionCat.swift
//  SanjaySwiftUI
//
//  Created by Sanjay Sampat on 13/08/20.
//  Copyright © 2020 Sanjay Sampat. All rights reserved.
//

struct TonySectionCat: Codable, Hashable {
    public var id: String = ""
    public var parentCat: String = ""
    public var catFirstTitle: String = ""
    public var catSecondTitle: String = ""
    public var catplayerpagename: String = ""
    public var catDesc: String = ""
    public var catImage: String = ""
    public var catStatus: String = ""
    public var createdDate: String = ""
    public var modifiedDate: String = ""
    public var catDuration: String = ""
    public var tag: String = ""
    public var singletag: String = ""
    public var otherimage: String = ""
    public var newimage: String = ""
    public var lockplay: String = ""
    public var sharecontent: String = ""
    public var searchkeyword: String = ""
    public var showSlider: String = ""
    public var is_tonysage: String = ""
    public var tony_7dayhead: String = ""
    public var tony_21dayhead: String = ""
    public var mostlovedcatorder: String = ""
    public var playListName: String = ""
    public var mediaid: String = ""
    public var mediaPath: String = ""
    public var imgPath: String = ""
    public var playvalue: Int = 0
    public var homeorder: String? = nil
    
    /*
    enum CodingKeys: String, CodingKey {
        case id = "UserId"
        case token = "UserToken"
        case profileData = "Profile_Data"
        //case copmanyData = "Company_Data"
    }
    */
}

// unused
struct TonySectionCatagories: Codable {
    public var catagories : [TonySectionCat] = []

    /*
    init( from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            //users = try container.decodeIfPresent(Users.self, forKey: .users) ?? Users()
            catagories = try container.decodeIfPresent([TonySectionCat].self, forKey: .users)!
        } catch {
            print("Error: SignIn decoder : \(error).")
        }
    }
    */

}
