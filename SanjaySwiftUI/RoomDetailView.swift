//
//  RoomDetailView.swift
//  SanjaySwiftUI
//
//  Created by Sanjay Sampat on 28/09/20.
//  Copyright © 2020 Sanjay Sampat. All rights reserved.
//

import MapKit
import SwiftUI

struct RoomDetailView: View {
    let room: Room
    let mapZoomLevel = 0.005      // near 0.0 to wide 1.0
    @State private var zoomed = false
    @State private var isPresentedSSMap: Bool = false
    @State private var coordinateRegion: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 19.229497, longitude: 72.864994),
        span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    @State private var annotaionItemPlaces : [SSAnnotaionItemPlace] = []

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
            
            HStack{
                Button(action: {
                    coordinateRegion = MKCoordinateRegion(
                        center: room.locationCoordinate ,
                        span: MKCoordinateSpan(latitudeDelta: room.mapZoomLevel, longitudeDelta: room.mapZoomLevel))
                    self.isPresentedSSMap.toggle()
                }) {
                    Image(systemName: "location.fill")
                        .font(.title)
                        .padding(.all)
                        .foregroundColor(CommonUtils.cu_activity_foreground_color)
                }
                .sheet(isPresented: $isPresentedSSMap)
                {
                    // As we want to display the following view on top of the current view, so we are using .sheet to load this view.
                    SSMapView(isPresentedSSMap: $isPresentedSSMap, coordinateRegion: $coordinateRegion, annotaionItemPlaces: room.annotaionItemPlaces)
               }
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            
        }
    }
}

struct RoomDetailView_Previews: PreviewProvider {
    static var previews: some View {
        RoomDetailView(room: testData[0])
    }
}
