//
//  LocalNotificationCenter.swift
//  SanjaySwiftUI
//
//  Created by Sanjay Sampat on 23/11/20.
//  Copyright © 2020 Sanjay Sampat. All rights reserved.
//

import Foundation
import SwiftUI
import CoreData

class LocalNotificationCenter: NSObject, ObservableObject {

    static let shared = LocalNotificationCenter()
    
    var notificationWillPresent: UNNotification?
    var notificationResponseData: UNNotificationResponse?
    
    private override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
}

extension LocalNotificationCenter: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        notificationWillPresent = notification
        completionHandler([.badge, .sound, .banner])
        // SSNote - the following method is calle din background
        performSelector(inBackground: #selector(saveNewNotificationInBackground(notification:)), with: notificationWillPresent)
        print("SSTODO - Notificaiton willPresent.")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        notificationResponseData = response
        completionHandler()
        print("SSTODO - Notificaiton didReceive.")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) {
        print("SSTODO - Notificaiton openSettingsFor.")
    }
    
    @objc func saveNewNotificationInBackground(notification: UNNotification) -> Void {
        let formatter3 = DateFormatter()
        formatter3.dateFormat = CommonUtils.cu_VideoFileNameDateFormat
        let dateTimeString = formatter3.string(from: Date())
        //save notification using core data
        let persistenceController = PersistenceController.shared
        let managedObjectContext = persistenceController.container.viewContext
        if let notificationEntity = NSEntityDescription.entity(forEntityName: "LocalNotificationData", in: managedObjectContext) {
            let notificationData = NSManagedObject(entity: notificationEntity, insertInto: managedObjectContext)
            notificationData.setValue(notification.request.content.title, forKey: "title")
            notificationData.setValue(notification.request.content.subtitle, forKey: "subtitle")
            notificationData.setValue(notification.request.content.body, forKey: "body")
            notificationData.setValue(dateTimeString, forKey: "datetime")
            do {
                try managedObjectContext.save()
                print("SSTODO - Notificaiton saved to coredata.")
            } catch let error as NSError {
                print("Could not save Notification. \(error), \(error.userInfo)")
            }
        }
    }
    
}
