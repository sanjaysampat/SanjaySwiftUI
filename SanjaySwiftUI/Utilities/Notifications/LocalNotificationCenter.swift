//
//  SSNotificationCenter.swift
//  SanjaySwiftUI
//
//  Created by Sanjay Sampat on 23/11/20.
//  Copyright © 2020 Sanjay Sampat. All rights reserved.
//

import Foundation
import SwiftUI

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
        print("Notificaiton willPresent.")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        notificationResponseData = response
        completionHandler()
        print("Notificaiton didReceive.")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) {
        print("Notificaiton openSettingsFor.")
    }
}
