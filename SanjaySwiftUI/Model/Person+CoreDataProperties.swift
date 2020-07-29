//
//  Person+CoreDataProperties.swift
//  SanjaySwiftUI
//
//  Created by Sanjay Sampat on 29/07/20.
//  Copyright © 2020 Sanjay Sampat. All rights reserved.
//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var datetime: String?
    @NSManaged public var name: String?
    @NSManaged public var photo: Data?

}
