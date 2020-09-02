/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The model for an individual landmark.
*/

import SwiftUI
import CoreLocation

struct Landmark: Hashable, Codable, Identifiable {
    var id: Int
    var name: String
    fileprivate var imageName: String
    fileprivate var coordinates: Coordinates
    var state: String
    var park: String
    var category: Category

    var locationCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: coordinates.latitude,
            longitude: coordinates.longitude)
    }

    enum Category: String, CaseIterable, Codable, Hashable {
        case featured = "Featured"
        case lakes = "Lakes"
        case rivers = "Rivers"
        case ebook = "EBook"
    }

    var bought:Bool = false
    
    var Amount:String
    var Tax:String
    var Total:String
        
    init( from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        imageName = try container.decode(String.self, forKey: .imageName)
        state = try container.decode(String.self, forKey: .state)
        park = try container.decode(String.self, forKey: .park)
        Amount = try container.decode(String.self, forKey: .Amount)
        Tax = try container.decode(String.self, forKey: .Tax)
        Total = try container.decode(String.self, forKey: .Total)
        coordinates = try container.decode(Coordinates.self, forKey: .coordinates)
        category = try container.decode(Category.self, forKey: .category)
        // optional json item
        bought = ( try? container.decodeIfPresent(Bool.self, forKey: .bought) ) ?? false
    }
}

extension Landmark {
    var image: Image {
        ImageStore.shared.image(name: imageName)
    }
}

struct Coordinates: Hashable, Codable {
    var latitude: Double
    var longitude: Double
}
