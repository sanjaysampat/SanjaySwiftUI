//
//  RoomListView.swift
//  SanjaySwiftUI
//
//  Created by Sanjay Sampat on 28/09/20.
//  Copyright © 2020 Sanjay Sampat. All rights reserved.
//

import SwiftUI

struct RoomListView: View {
    var rooms: [Room] = testData    //[]
    
    var body: some View {
        NavigationView {
            List(rooms) { room in
                NavigationLink(destination: Text(room.name)) {
                    Image(room.imageName)
                        .resizable()
                        .frame(width: 50.0, height: 50.0)
                        .cornerRadius(10)
                    VStack(alignment: .leading) {
                        Text(room.name)
                        Text("\(room.capacity) people")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .navigationBarTitle("Rooms")
    }
}

struct RoomListView_Previews: PreviewProvider {
    static var previews: some View {
        RoomListView(rooms: testData)
    }
}
