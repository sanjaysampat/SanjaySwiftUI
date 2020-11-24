//
//  NotificationListView.swift
//  SanjaySwiftUI
//
//  Created by Sanjay Sampat on 23/11/20.
//  Copyright © 2020 Sanjay Sampat. All rights reserved.
//

import SwiftUI

struct NotificationListView: View {
    @Environment(\.managedObjectContext) var managedObjectContext

    @FetchRequest(
        entity: LocalNotificationData.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \LocalNotificationData.datetime, ascending: false)
        ]
    ) var localNotifications: FetchedResults<LocalNotificationData>

    @Binding var showNotification:Bool

    @StateObject var localNotificationCenter = LocalNotificationCenter.shared

    var body: some View {
        VStack {
            if let notificationResponseData = localNotificationCenter.notificationResponseData  {
                Text("Last notification received")
                    .underline()
                Text(verbatim: notificationResponseData.notification.request.content.title)
                    .font(.title)
                Text(verbatim: notificationResponseData.notification.request.content.subtitle)
                    .font(.title2)
                Text(verbatim: notificationResponseData.notification.request.content.body)
                    .font(.body)
                    .padding(.bottom, 5)
            }
            
            HStack {
                Button(action: {
                    withAnimation{
                        self.showNotification.toggle()
                    }
                }) {
                    Text("Close")
                }
                Spacer()
                
                EditButton()
            }
            .padding()
            
            List {
                ForEach(localNotifications, id: \.datetime) { notificationData in
                    VStack(alignment:.leading) {
                        if let title = notificationData.title, !title.isEmpty {
                            Text(title).font(.title2).bold()
                        }
                        if let subtitle = notificationData.subtitle, !subtitle.isEmpty {
                            Text(subtitle).font(.title2)
                        }
                        if let body = notificationData.body, !body.isEmpty {
                            Text(body)
                        }
                    }
                }
                .onDelete(perform: delete)
                //.onMove(perform: move)
            }
            
        }
    }
    
    func delete(at offsets: IndexSet) {
        offsets.forEach { index in
            let notificationData = self.localNotifications[index]
            self.managedObjectContext.delete(notificationData)
        }
        self.saveContext()
    }

    func saveContext() {
        do {
            try managedObjectContext.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
    }
    
}

struct NotificationListView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationListView(showNotification: .constant(true))
    }
}
