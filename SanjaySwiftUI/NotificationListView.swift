//
//  NotificationListView.swift
//  SanjaySwiftUI
//
//  Created by Sanjay Sampat on 23/11/20.
//  Copyright © 2020 Sanjay Sampat. All rights reserved.
//

import SwiftUI

struct NotificationListView: View {
    @Binding var showNotification:Bool

    @StateObject var localNotificationCenter = LocalNotificationCenter.shared

    var body: some View {
        VStack {
            //if self.showNotification {
            Text("Last Notification:")
                .padding(.bottom, 5)

            if let notificationWillPresent = localNotificationCenter.notificationWillPresent  {
                Text("Presented")
                    .underline()
                Text(verbatim: notificationWillPresent.request.content.title)
                    .font(.title)
                Text(verbatim: notificationWillPresent.request.content.subtitle)
                    .font(.title2)
                Text(verbatim: notificationWillPresent.request.content.body)
                    .font(.body)
                    .padding(.bottom, 5)
            } else {
                Text("You have to create Local Notification.")
                    .padding(.bottom, 5)
            }
            
            if let notificationResponseData = localNotificationCenter.notificationResponseData  {
                Text("Received")
                    .underline()
                //Text(verbatim: notificationResponseData.actionIdentifier)
                Text(verbatim: notificationResponseData.notification.request.content.title)
                    .font(.title)
                Text(verbatim: notificationResponseData.notification.request.content.subtitle)
                    .font(.title2)
                Text(verbatim: notificationResponseData.notification.request.content.body)
                    .font(.body)
                    .padding(.bottom, 5)
            }
            
            //}
            Button(action: {
                withAnimation{
                    self.showNotification.toggle()
                }
            }) {
                Text("Close")
            }
        }
    }
}

struct NotificationListView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationListView(showNotification: .constant(true))
    }
}
