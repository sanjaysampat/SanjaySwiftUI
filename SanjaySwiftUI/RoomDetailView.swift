//
//  RoomDetailView.swift
//  SanjaySwiftUI
//
//  Created by Sanjay Sampat on 28/09/20.
//  Copyright © 2020 Sanjay Sampat. All rights reserved.
//

import SwiftUI

struct RoomDetailView: View {
    let room: Room
    @State private var zoomed = false

    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack{
                Text("Building: \(room.building)")
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Text("Floor: \(room.floor)")
                    .italic()
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .padding(.all)
            
            Image(room.imageName)
                .resizable()
                .aspectRatio(contentMode: zoomed ? .fill : .fit)
                .navigationBarTitle(Text(room.name), displayMode: .inline)
                .onTapGesture {
                    withAnimation(.linear(duration: 1.5)) { self.zoomed.toggle() }
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            if room.hasVideo && !zoomed {
                Image(systemName: "video.fill")
                    .font(.title)
                    .padding(.all)
                    .transition(.move(edge: .leading))
            }
        }
    }
}

struct RoomDetailView_Previews: PreviewProvider {
    static var previews: some View {
        RoomDetailView(room: testData[0])
    }
}
