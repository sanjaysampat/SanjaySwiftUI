//
//  ListView.swift
//  SanjaySwiftUI
//
//  Created by Sanjay Sampat on 07/08/20.
//  Copyright © 2020 Sanjay Sampat. All rights reserved.
//

import SwiftUI

enum ViewNames: String {
    case shuffle = "Shuffle"
    case person = "Persons in Heart"
    case allpersons = "All persons in Heart"
    case signinFeatcher = "Demo signin user"
    case lakes = "Landmark lakes"
    case featured = "Landmark featured (single)"
    case rivers = "Landmark revers"
}

let allViews: [MultiSelectorGoal] = [MultiSelectorGoal(name: ViewNames.shuffle.rawValue), MultiSelectorGoal(name: ViewNames.person.rawValue), MultiSelectorGoal(name: ViewNames.allpersons.rawValue), MultiSelectorGoal(name: ViewNames.signinFeatcher.rawValue), MultiSelectorGoal(name: ViewNames.lakes.rawValue), MultiSelectorGoal(name: ViewNames.featured.rawValue), MultiSelectorGoal(name: ViewNames.rivers.rawValue), MultiSelectorGoal(name: "Selection error check")]

struct ListView: View {
    @EnvironmentObject  var  userAuth: UserAuth
    
    @FetchRequest(
        entity: Person.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Person.datetime, ascending: true)
        ]
    ) var persons: FetchedResults<Person>
    
    @State var photoFrame : (width:CGFloat, height:CGFloat) = (width:300, height:200)
    
    //@Binding var listSelection: Int?  // SSNote: no back button now, as we are calling this from navigation view.
    @Binding var currentPos:Int
    
    let myPaddingSpace:CGFloat = 5
    
    let myCornerRadius = CommonUtils.cu_CornerRadius
    
    @State var multiSelecterTask = MultiSelectorTask(name: "", servingGoals: [allViews[0], allViews[1], allViews[4], allViews[5], allViews[6]])
    
    @State var showMultiSelector: Bool = false
    
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
            if showMultiSelector {
                Form {
                    Section(header: Text("Multiselect Views")) {
                        MultiSelector(
                            label: Text("Selected"),
                            options: allViews,
                            optionToString: { $0.name },
                            selected: $multiSelecterTask.servingGoals
                        )
                    }
                }
                Button(action: {
                    // simple animation
                    withAnimation{
                        self.showMultiSelector.toggle()
                    }
                }) {
                    Text("Refresh")
                }
            } else {
                VStack {
                    ScrollView(.vertical) {
                        Button(action: {
                            // simple animation
                            withAnimation{
                                self.showMultiSelector.toggle()
                            }
                        }) {
                            Text("Click to Multiselect Views to display below.")
                        }
                        
                        Text("Start")
                            .foregroundColor(CommonUtils.cu_activity_light_text_color)
                            .shadow(radius: 1.5)
                            .padding()
                        
                        if multiSelecterTask.servingGoals.contains( MultiSelectorGoal(name: ViewNames.shuffle.rawValue) ) {
                            Group {
                                // SSNote array shuffle working
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
                        } else {
                            MultiselectorOptionTextMessageView(selectionText: ViewNames.shuffle.rawValue)
                        }
                        
                        if multiSelecterTask.servingGoals.contains( MultiSelectorGoal(name: ViewNames.person.rawValue) ) {
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
                            }
                        } else {
                            MultiselectorOptionTextMessageView(selectionText: ViewNames.person.rawValue)
                        }
                        
                        Group {
                            ScrollView(.horizontal) {
                                HStack(spacing: myPaddingSpace) {
                                    
                                    if multiSelecterTask.servingGoals.contains( MultiSelectorGoal(name: ViewNames.allpersons.rawValue) ) {
                                        
                                        ForEach(persons, id: \.datetime) { person in
                                            ZStack {
                                                Image(uiImage: UIImage(data: person.photo ?? Data()), placeholderSystemName: "person")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 250, height: 250)
                                                    .font(Font.title.weight(.ultraLight))
                                                    .foregroundColor(CommonUtils.cu_activity_light_text_color)
                                                    .cornerRadius(self.myCornerRadius)

                                                Text("\(person.name ?? "")")
                                                    .foregroundColor(CommonUtils.cu_activity_background_color)
                                                    .shadow(radius: 1.5)
                                                    .frame(width: 250, height: 250, alignment: .bottom)
                                            }
                                        }
                                        
                                    } else {
                                        
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
                                }
                                .padding(10)
                                
                            }
                            
                            
                            if multiSelecterTask.servingGoals.contains( MultiSelectorGoal(name: ViewNames.lakes.rawValue) ) {
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
                            } else {
                                MultiselectorOptionTextMessageView(selectionText: ViewNames.lakes.rawValue)
                            }
                            
                            if multiSelecterTask.servingGoals.contains( MultiSelectorGoal(name: ViewNames.featured.rawValue) ) {
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
                            } else {
                                MultiselectorOptionTextMessageView(selectionText: ViewNames.featured.rawValue)
                            }
                            
                            if multiSelecterTask.servingGoals.contains( MultiSelectorGoal(name: ViewNames.rivers.rawValue) ) {
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
                            } else {
                                MultiselectorOptionTextMessageView(selectionText: ViewNames.rivers.rawValue)
                            }
                            
                        }
                        
                        
                        if multiSelecterTask.servingGoals.contains( MultiSelectorGoal(name: ViewNames.signinFeatcher.rawValue) ) {
                            Group {
                                
                                SigninViewer(signinFetcher: SigninFetcher(userEmail: userAuth.userEmail), photoFrame: $photoFrame )
                                    .padding(10)
                                
                            }
                            .layoutPriority(1)  // SSNote : high priority for this layout by Parent, specially in case of multiline text.

                        } else {
                            
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
        }
        .background(CommonUtils.cu_activity_background_color)
        //.edgesIgnoringSafeArea(.all)
    }
}

struct MultiselectorOptionTextMessageView: View {
    var selectionText:String = ""
    
    var body: some View {
        Text("Select '\(selectionText)' from Multiselector")
            .foregroundColor(CommonUtils.cu_activity_light_text_color)
            .shadow(radius: 1.5)
            .padding()
    }
    
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView(currentPos: .constant(-1))
    }
}
