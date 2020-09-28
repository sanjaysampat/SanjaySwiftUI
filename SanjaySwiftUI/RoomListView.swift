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
        List(rooms) { room in
            Image(systemName: "photo")
            VStack(alignment: .leading) {
                Text(room.name)
                Text("20 people")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct RoomListView_Previews: PreviewProvider {
    static var previews: some View {
        RoomListView(rooms: testData)
    }
}
