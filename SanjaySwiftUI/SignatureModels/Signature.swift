//
//  Signature.swift
//  SanjaySwiftUI
//
//  Created by Sanjay Sampat on 18/11/20.
//  Copyright © 2020 Sanjay Sampat. All rights reserved.
//
//   let signature = try? newJSONDecoder().decode(Signature.self, from: jsonData)

import SwiftUI

struct Signature: Hashable, Codable, Identifiable {
    
    let id: UUID = UUID()
    let name, signatureDescription, signatureName: String
    let wikipedia: String
    let imageName: String

    enum CodingKeys: String, CodingKey {
        //case id
        case name
        case signatureDescription = "description"
        case signatureName, wikipedia, imageName
    }
    /*
    init( from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        signatureDescription = try container.decode(String.self, forKey: .signatureDescription)
        signatureName = try container.decode(String.self, forKey: .signatureName)
        wikipedia = try container.decode(String.self, forKey: .wikipedia)
        imageName = try container.decode(String.self, forKey: .imageName)
    }
    */
}

extension Signature {
    var signatureImage: Image {
        if signatureName.isEmpty {
            return Image(systemName: "signature")
        } else {
            return Image(signatureName)
        }
    }
    var photoImage: Image {
        if imageName.isEmpty {
            return Image(systemName: "person")
        } else {
            return Image(imageName)
        }
    }
}
