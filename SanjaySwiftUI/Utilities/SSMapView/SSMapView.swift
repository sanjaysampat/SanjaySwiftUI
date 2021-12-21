//
//  SSMapView.swift
//  SanjaySwiftUI
//
//  Created by Sanjay Sampat on 01/10/20.
//  Copyright © 2020 Sanjay Sampat. All rights reserved.
//

import MapKit
import SwiftUI

struct SSMapView: View {
    @Binding var isPresentedSSMap: Bool
    @Binding var coordinateRegion: MKCoordinateRegion
    var annotaionItemPlaces : [SSAnnotaionItemPlace] = []
    
    @State private var itemDescription: String = ""

    var body: some View {
        ZStack(alignment: .topLeading) {
            
            if #available(iOS 14.0, *) {
                if annotaionItemPlaces.count <= 0  {
                    Map(coordinateRegion: $coordinateRegion)
                } else {
                    
                    Map(coordinateRegion: $coordinateRegion,
                        annotationItems: annotaionItemPlaces) { place in
                        
                        MapAnnotation(coordinate: place.coordinate) {
                            VStack {
                                Group {
                                    Image(systemName: "mappin.circle.fill")
                                        .resizable()
                                        .frame(width: 25.0, height: 25.0)
                                    Circle()
                                        .frame(width: 8.0, height: 8.0)
                                }
                                .foregroundColor(.red)
                                .onTapGesture {
                                    self.itemDescription = "Any extra information of \(place.name) in multi line."
                                }
                                
                                Text(place.name)
                                    .font(.subheadline)
                                    //.foregroundColor(CommonUtils.cu_activity_light_text_color)
                                    .foregroundColor(ColorScheme.text)
                                    .shadow(radius: 1.5)
                            }
                        }
                        /*
                         MapMarker(coordinate: place.coordinate, tint: .green)
                         MapPin(coordinate: location.coordinate)
                         */
                    }
                    //.onTapGesture {
                    //    self.itemDescription = ""
                    //}

                    if !self.itemDescription.isEmpty {
                        HStack(alignment: .center) {
                            Spacer()
                            Text(self.itemDescription)
                                .font(.caption2)
                                .lineLimit(nil)
                                .multilineTextAlignment(.center)
                                .padding(5)
                            Spacer()
                        }
                        //.background(CommonUtils.cu_activity_light_theam_color)
                        .background(ColorScheme.theam)                        .cornerRadius(10).opacity(0.6)
                        .padding(30)
                    }
                }
            } else {
                Text("The example will work only on and above iOS 14.")
                    .padding()
            }
            
            Button(action: {
                withAnimation(.linear(duration:2)){
                    self.isPresentedSSMap = false
                }
            }) {
                HStack( alignment: .center) {
                    Image(systemName: "chevron.left")
                    Text("Back")
                        .font(.body)
                        //.foregroundColor(CommonUtils.cu_activity_light_text_color)
                        .foregroundColor(ColorScheme.text)
                        .shadow(radius: 1.5)
                    
                }
            }
            //.foregroundColor(CommonUtils.cu_activity_foreground_color)
            .foregroundColor(ColorScheme.foreground)
            .padding()
            
        }
        .edgesIgnoringSafeArea(.all)
        
    }
}

struct SSMapView_Previews: PreviewProvider {
    static var previews: some View {
        SSMapView(isPresentedSSMap: .constant(true), coordinateRegion: .constant(MKCoordinateRegion(
                                center: CLLocationCoordinate2D(latitude: 19.229497, longitude: 72.864994),
                                span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))), annotaionItemPlaces: [
                                    SSAnnotaionItemPlace(name: "Paratha Zone", latitude: 19.229932, longitude: 72.864297),
                                    SSAnnotaionItemPlace(name: "Saffron", latitude:  19.229750, longitude: 72.864608),
                                    SSAnnotaionItemPlace(name: "Greens Veg Restaurant", latitude: 19.230172, longitude: 72.862070)
                                  ])
    }
}

struct SSAnnotaionItemPlace: Identifiable {
    var id = UUID()
    let name: String
    let latitude: Double
    let longitude: Double
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
