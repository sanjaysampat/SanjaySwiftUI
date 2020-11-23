//
//  LocalNotification.swift
//  SanjaySwiftUI
//
//  Created by Sanjay Sampat on 23/11/20.
//  Copyright © 2020 Sanjay Sampat. All rights reserved.
//

import SwiftUI
import os

class LocalNotification: ObservableObject {
    
    init() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound])  { (allowed, error) in
            //This callback does not trigger on main loop be careful
            if allowed {
                os_log(.debug, "Allowed")
            } else {
                os_log(.debug, "Error")
            }
            if error == nil{
                // Register for Remote Notifications.
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                    // on success of above we will get the device token at didRegisterForRemoteNotificationsWithDeviceToken in AppDelegate
                }
            }
        }
    }
    
    // when - timeInterval in seconds.
    func setLocalNotification(title: String, subtitle: String, body: String, when: Double) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.body = body
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: when, repeats: false)
        let request = UNNotificationRequest.init(identifier: "localNotificatoin", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
    }
}
