//
//  ListView.swift
//  SanjaySwiftUI
//
//  Created by Sanjay Sampat on 07/08/20.
//  Copyright © 2020 Sanjay Sampat. All rights reserved.
//

import SwiftUI

struct ListView: View {

    @FetchRequest(
        entity: Person.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Person.datetime, ascending: true)
        ]
    ) var persons: FetchedResults<Person>

    @State var photoFrame : (width:CGFloat, height:CGFloat) = (width:400, height:400)

    @Binding var listSelection: Int?
    @Binding var currentPos:Int
    
    let myPaddingSpace:CGFloat = 5
    
    let myCornerRadius = CommonUtils.cu_CornerRadius

    var body: some View {
        ZStack {
            VStack {
                HStack {
                    
                    Button(action: {
                        self.listSelection = 0
                    }) {
                        HStack( alignment: .center) {
                            Image(systemName: "chevron.left")
                            Text("Back")
                                .font(.body)
                                .foregroundColor(CommonUtils.cu_activity_light_text_color)
                                .shadow(radius: 1.5)
                            
                        }
                    }
                    .foregroundColor(CommonUtils.cu_activity_foreground_color)
                    .padding()
                    
                    Spacer()
                }
                .padding()
                
                ScrollView(.vertical) {
                    
                    Text("Start")
                        .foregroundColor(CommonUtils.cu_activity_light_text_color)
                        .shadow(radius: 1.5)
                        .padding()
                    
                    SigninViewer(photoFrame: $photoFrame)
                        .padding(10)

                ScrollView(.horizontal) {
                    HStack(spacing: myPaddingSpace) {
                        /*
                        ForEach(persons, id: \.datetime) { person in
                            ZStack {
                                Image(uiImage: self.personPhoto, placeholderSystemName: "person")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 400, height: 200)
                                
                                Text("Name is \(person.name ?? "")")
                                .foregroundColor(CommonUtils.cu_activity_background_color)
                                .shadow(radius: 1.5)
                                .frame(width: 400, height: 200, alignment: .bottom)
                            }
                        
                        }
                        */
                        ForEach(landmarkData) { landmark in
                            ZStack {
                                landmark.image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(minWidth: 100, idealWidth: 200, maxWidth: 400, minHeight: 100, idealHeight: 200, maxHeight: 200, alignment: .center)
                                    .cornerRadius(self.myCornerRadius)
                                
                                Text(landmark.name)
                                    .foregroundColor(CommonUtils.cu_activity_background_color)
                                    .shadow(radius: 1.5)
                                    .frame(minWidth: 100, idealWidth: 200, maxWidth: 400, minHeight: 200, idealHeight: 200, maxHeight: 200, alignment: .bottom)
                            }
                        }
                    }
                    .padding(10)
                    
                    }
                    ScrollView(.horizontal) {
                        HStack(spacing: myPaddingSpace) {
                            ForEach(landmarkData.filter {$0.category == .lakes }) { landmark in
                                ZStack {
                                    landmark.image
                                        .resizable(resizingMode: .stretch)
                                        .scaledToFit()
                                        .frame(width: 400, height: 400, alignment: .center)
                                    .cornerRadius(self.myCornerRadius)

                                    Text(landmark.name)
                                        .foregroundColor(CommonUtils.cu_activity_background_color)
                                        .shadow(radius: 1.5)
                                        .frame(width: 400, height: 400, alignment: .bottom)
                                }
                            }
                        }
                        .padding(10)

                    }
                    ForEach(landmarkData.filter {$0.category == .featured }) { landmark in
                    ZStack {
                        landmark.image
                            .resizable(resizingMode: .stretch)
                            .scaledToFit()
                            .cornerRadius(self.myCornerRadius)

                        Text(landmark.name)
                            .foregroundColor(CommonUtils.cu_activity_background_color)
                            .shadow(radius: 1.5)
                    }
                    .padding(10)
                        
                    }
                    
                    ScrollView(.horizontal) {
                        HStack(spacing: myPaddingSpace) {
                            ForEach(landmarkData.filter {$0.category == .rivers }) { landmark in
                                ZStack {
                                    landmark.image
                                        .resizable(resizingMode: .stretch)
                                        .scaledToFit()
                                        .frame(width: 400, height: 400, alignment: .center)
                                        .cornerRadius(self.myCornerRadius)

                                    Text(landmark.name)
                                        .foregroundColor(CommonUtils.cu_activity_background_color)
                                        .shadow(radius: 1.5)
                                        .frame(width: 400, height: 400, alignment: .bottom)
                                }
                            }
                        }
                        .padding(10)

                    }
                    
                    if self.persons.count > 0 && self.currentPos >= 0 && self.currentPos < self.persons.count {
                    ZStack {
                        Image( uiImage: UIImage(data: self.persons[self.currentPos].photo ?? Data()), placeholderSystemName: "person")
                            .resizable(resizingMode: .stretch)
                            .scaledToFit()
                            .font(Font.title.weight(.ultraLight))
                            .foregroundColor(CommonUtils.cu_activity_light_text_color)
                            .cornerRadius(self.myCornerRadius)

                        Text(self.persons[self.currentPos].name ?? "")
                            .foregroundColor(CommonUtils.cu_activity_background_color)
                            .shadow(radius: 1.5)
                    }
                    .padding(10)
                        
                    }
                    
                    Text("End")
                        .foregroundColor(CommonUtils.cu_activity_light_text_color)
                        .shadow(radius: 1.5)
                        .padding()
                    
                    Spacer()
                }
            }
        }
        .background(CommonUtils.cu_activity_background_color)
        //.edgesIgnoringSafeArea(.all)
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView(listSelection: .constant(1), currentPos: .constant(-1))
    }
}
