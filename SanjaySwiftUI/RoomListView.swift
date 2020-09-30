//
//  RoomListView.swift
//  SanjaySwiftUI
//
//  Created by Sanjay Sampat on 28/09/20.
//  Copyright © 2020 Sanjay Sampat. All rights reserved.
//

import SwiftUI

struct RoomListView: View {
    //var rooms: [Room] = testData    //[]
    @ObservedObject var store = RoomStore(rooms: testData)
    
    var body: some View {
        NavigationView {
            //List(rooms) { room in
            //    RoomCell(room: room)
            //}
            List {
                Section{
                    Button(action: addRoom) {
                        Text("Add Room")
                    }
                }
                Section{
                    ForEach (store.rooms) { room in
                        RoomCell(room: room)
                    }
                }
            }
        }
        .navigationBarTitle(Text("Rooms"), displayMode: .inline)
        .listStyle(GroupedListStyle())
    }
    
    func addRoom() {
        store.rooms.append(Room(name: "Hall 2", building: "A", floor: "3", capacity: 2000, hasVideo: false, imageName: "room10"))
    }
}

struct RoomListView_Previews: PreviewProvider {
    static var previews: some View {
        //RoomListView(rooms: testData)
        RoomListView(store: RoomStore(rooms: testData))
    }
}

struct RoomCell: View {
    let room: Room
    
    var body: some View {
        NavigationLink(destination: RoomDetailView(room: room)) {
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
