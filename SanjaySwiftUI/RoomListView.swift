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
    
    @State private var searchQuery: String = ""
    
    var body: some View {
        NavigationView {
            if #available(iOS 15.0, *) {
                List {
                    Section{
                        Button(action: addRoom) {
                            Text("Add Room")
                                .listItemTint(.green)   // do not work
                        }
                    }.headerProminence(.increased)  // do not work
                    
                    Section{
                        ForEach ($store.rooms) { room in
                            RoomCell(room: room)
                                .listRowSeparatorTint(Color.purple)
                                .listRowSeparator(.visible, edges: .all)
                            /*
                             // if we add .swipeActions then the older '.onDelete' swipe functionality does not work (in Edit mode)
                                .swipeActions(edge: .leading, allowsFullSwipe: false) {
                                    Button("Copy") {
                                        copyRoom(srcRoom: room, newName: "Copied Hall", newCapacity: 1500)
                                    }
                                    .tint(.green)
                                }
                             */
                        }
                        .onDelete( perform: deleteRoom)
                        .onMove(perform: moveRoom)
                    }
                }
                .searchable(text: $searchQuery, placement: .automatic, prompt:"Search term")
                // SSNote : to NOT to autocorrect in search bar, disableAutocorrection(true)
                .disableAutocorrection(true)
                .onChange(of: searchQuery) {
                    //print($0)
                    submitCurrentSearchQuery(passedSearchString: $0)
                }
                .listSectionSeparator(.visible, edges: .all)
                .listSectionSeparatorTint(Color.red)
                .navigationBarTitle(Text("Rooms"), displayMode: .inline)
                .navigationBarItems(trailing: EditButton())
                .onSubmit(of: .search) {
                    submitCurrentSearchQuery()
                }
                
            } else {
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
                        ForEach ($store.rooms) { room in
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
    }
    
    func copyRoom(srcRoom:Room, newName:String = "", newCapacity:Int = 0) {
        let roomName:String = newName.isEmpty ? srcRoom.name : newName
        let roomCapacity:Int = newCapacity<=0 ? srcRoom.capacity : newCapacity
        store.rooms.append(Room(name: roomName, building: srcRoom.building, floor: srcRoom.floor, capacity: roomCapacity, hasVideo: srcRoom.hasVideo, imageName: srcRoom.imageName, coordinates: srcRoom.coordinates))
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
    
    func submitCurrentSearchQuery( passedSearchString:String = "" ) {
        //print("Submitted search query \(searchQuery)")
        let searchedRooms = store.roomArrayFoundFrom(searchQuery: passedSearchString.isEmpty ? searchQuery : passedSearchString)
        
        store.rooms = store.rooms.map { (room:Room) -> Room in
            var mutableRoom = room
            mutableRoom.searched = searchedRooms.contains(room)
            return mutableRoom
        }
    }
}
/*
struct RoomListView_Previews: PreviewProvider {
    static var previews: some View {
        //RoomListView(rooms: testRoomData)
        RoomListView(store: RoomStore(rooms: testRoomData))
    }
}
*/
struct RoomCell: View {
    @Binding var room: Room
    
    var body: some View {
        NavigationLink(destination: RoomDetailView(room: room)) {
            Image(room.imageName)
                .resizable()
                .frame(width: 50.0, height: 50.0)
                .cornerRadius(10)
            VStack(alignment: .leading) {
                Text(room.name)
                    .background(Color.yellow.opacity( room.searched ? 0.3 : 0.0 ))
                Text("\(room.capacity) people")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
        }
    }
}
