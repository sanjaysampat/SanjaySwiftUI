//
//  LocalNotificationData+CoreDataProperties.swift
//  SanjaySwiftUI
//
//  Created by Sanjay Sampat on 24/11/20.
//  Copyright © 2020 Sanjay Sampat. All rights reserved.
//
//

import Foundation
import CoreData


extension LocalNotificationData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LocalNotificationData> {
        return NSFetchRequest<LocalNotificationData>(entityName: "LocalNotificationData")
    }

    @NSManaged public var title: String?
    @NSManaged public var subtitle: String?
    @NSManaged public var body: String?
    @NSManaged public var datetime: String?

}

extension LocalNotificationData : Identifiable {

}
