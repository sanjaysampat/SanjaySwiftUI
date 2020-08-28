//
//  Audio+CoreDataProperties.swift
//  SanjaySwiftUI
//
//  Created by Sanjay Sampat on 27/08/20.
//  Copyright © 2020 Sanjay Sampat. All rights reserved.
//
//

import Foundation
import CoreData


extension Audio {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Audio> {
        return NSFetchRequest<Audio>(entityName: "Audio")
    }

    @NSManaged public var name: String?
    @NSManaged public var url: String?
    @NSManaged public var datetime: String?

}
