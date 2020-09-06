//
//  ListView.swift
//  SanjaySwiftUI
//
//  Created by Sanjay Sampat on 07/08/20.
//  Copyright © 2020 Sanjay Sampat. All rights reserved.
//

import SwiftUI

struct ListView: View {
    @EnvironmentObject  var  userAuth: UserAuth
    
    @FetchRequest(
        entity: Person.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Person.datetime, ascending: true)
        ]
    ) var persons: FetchedResults<Person>
    
    @State var photoFrame : (width:CGFloat, height:CGFloat) = (width:400, height:300)
    
    //@Binding var listSelection: Int?  // SSNote: no back button now, as we are calling this from navigation view.
    @Binding var currentPos:Int
    
    let myPaddingSpace:CGFloat = 5
    
    let myCornerRadius = CommonUtils.cu_CornerRadius
    
    @State var viewArray:[(id:String, anyView:AnyView)] = [
        (UUID().uuidString,
        AnyView(
            HStack {Text("1: HStack of"); Spacer(); Text("multiple texts") }
            .padding(5)
            .border(Color.red, width: 1)
        )),
        (UUID().uuidString,
        AnyView(
            Text("2: A text")
            .padding(5)
            .border(Color.blue, width: 1)
        )),
        (UUID().uuidString,
        AnyView(
            VStack {
                Text("3: text and multiple stacks with images")
                HStack {
                    Image(systemName: "suit.spade.fill")
                    Image(systemName: "suit.club")
                }
                HStack {
                    Image(systemName: "suit.heart")
                    Image(systemName: "suit.diamond.fill")
                }
            }
            .padding(5)
            .border(Color.green, width: 1)
        ))
    ]
    
    var body: some View {
        ZStack {
            VStack {
                
                ScrollView(.vertical) {
                    
                    Text("Start")
                        .foregroundColor(CommonUtils.cu_activity_light_text_color)
                        .shadow(radius: 1.5)
                        .padding()
                    
                    Group {
                        // SSTODO array shuffle working
                        // we need to add UUID and views in tuple.
                        Button(action: {
                            // simple animation
                            withAnimation{
                                self.viewArray.shuffle()
                            }
                            //print(self.viewArray)
                        }) {
                            Text("Shuffle views")
                            Text("(Following is array of AnyViews)")
                                .font(.caption)
                        }
                        
                        ForEach(viewArray, id: \.id) { viewTuple in
                            viewTuple.anyView
                        }
                        
                        /*
                        // but following way views are not refreshed
                        ForEach( 0..<viewArray.count ) {
                            index in
                            
                            self.viewArray[index].anyView
                            self.PrintinView(self.viewArray[index].anyView)
                            
                        }
                        */
                        
                        Text("Shuffle views End")
                            .foregroundColor(CommonUtils.cu_activity_light_text_color)
                            .shadow(radius: 1.5)
                            .padding()
                    }
                    
                    Group {
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
                        
                        //SigninViewer(signinFetcher: SigninFetcher(userEmail: userAuth.userEmail), photoFrame: $photoFrame )
                        //.padding(10)
                    }
                    
                    Group {
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
                    }
                    
                    Group {
                        
                        TonySectionViewer(tonySectionFeatcher: TonySectionFeatcher(userEmail: userAuth.userEmail), photoFrame: $photoFrame )
                            .padding(10)
                        
                        TonySectionViewer(tonySectionFeatcher: TonySectionFeatcher(userEmail: userAuth.userEmail, categoryFetchType: .mostLoved), photoFrame: $photoFrame )
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
        ListView(currentPos: .constant(-1))
    }
}
