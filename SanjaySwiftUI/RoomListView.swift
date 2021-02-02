//
//  RoomListView.swift
//  SanjaySwiftUI
//
//  Created by Sanjay Sampat on 28/09/20.
//  Copyright © 2020 Sanjay Sampat. All rights reserved.
//

import SwiftUI

struct RoomListView: View {
    //var rooms: [Room] = testRoomData    //[]
    @ObservedObject var store = RoomStore(rooms: testRoomData)
    
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
                    .onDelete( perform: deleteRoom)
                    .onMove(perform: moveRoom)
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle(Text("Rooms"), displayMode: .inline)
            .navigationBarItems(trailing: EditButton()) // SSTODO this does not work.
        }
    }
    
    func addRoom() {
        store.rooms.append(Room(name: "Hall 2", building: "A", floor: "3", capacity: 2000, hasVideo: false, imageName: "room10", coordinates: Coordinates(latitude: 56.948889, longitude: 24.106389)))
    }
    
    func deleteRoom(at offsets: IndexSet) {
        store.rooms.remove(atOffsets: offsets)
    }

    func moveRoom(from source: IndexSet, to destination: Int) {
        store.rooms.move(fromOffsets: source, toOffset: destination)
    }
}

struct RoomListView_Previews: PreviewProvider {
    static var previews: some View {
        //RoomListView(rooms: testRoomData)
        RoomListView(store: RoomStore(rooms: testRoomData))
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
