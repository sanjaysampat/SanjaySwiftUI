//
//  ContentView.swift
//  SanjaySwiftUI
//
//  Created by Sanjay Sampat on 20/07/20.
//  Copyright © 2020 Sanjay Sampat. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(
        entity: Person.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Person.name, ascending: true)
        ]
    ) var persons: FetchedResults<Person>
    
    @State private var name = "Name"
    @State private var showingAlert:Int = 0
    
    @State private var nameChanged = false
    
    //@ObservedObject var viewModel = ViewModel()
    
    var body: some View {
        ZStack() {
            // hidden control for code modifications.
            Toggle("", isOn:$nameChanged)
                .frame(width: 0, height: 0)
                .clipped()
                .onReceive([self.$nameChanged].publisher.first()) { (value) in
                    //print("New value is: \(value)")
                    //print( "SSTODO - Toggle - Showing Alert \(self.showingAlert) and self.nameChanged=\(self.nameChanged)" )
                    if self.nameChanged {
                        if self.persons.count <= 0 {
                            let newPerson = Person(context: self.managedObjectContext)
                            newPerson.name = self.name
                            self.saveContext()
                        } else if self.name != self.persons[0].name {
                            self.persons[0].name = self.name
                            self.saveContext()
                        }
                    } else {
                        if self.persons.count > 0 {
                            self.name = self.persons[self.persons.count-1].name ?? "Name"
                        }
                    }
            }
            
            Rectangle()
                .scale(1.25)
                .rotation(Angle(degrees: -45), anchor: .center)
                .edgesIgnoringSafeArea(.all)
                .opacity(0.15)
            
            Image(systemName: "heart")
                .resizable(resizingMode: .stretch)
                .rotationEffect(Angle(degrees: -45), anchor: .center)
                .scaledToFit()
                .foregroundColor(Color.pink)
                .opacity(0.75)
            
            if self.showingAlert == 1 {
                
                AlertControlView(textChanged: $nameChanged,
                                 textString: $name,
                                 showAlert: $showingAlert,
                                 title: "Lover",
                                 message: "What's name ?")
                
            }
            
            VStack(alignment: .center) {
                Text("\(self.name)")
                    .font(.largeTitle)
                    .foregroundColor(Color.pink)
                
                Text("in my Heart")
                    .font(.title)
                    .fontWeight(.thin)
                    .foregroundColor(Color.pink)
                
                if self.persons.count > 0 {
                    Text("(1 of \(self.persons.count))")
                        .font(.footnote)
                        .foregroundColor(Color.pink)
                }
                
                HStack(alignment: .center) {
                    Button(action: {
                        //self.showingAlert = 1
                        //self.nameChanged = false
                    }) {
                        Image(systemName: "chevron.left.circle")
                    }
                    .foregroundColor(Color.pink)
                    .padding(.trailing)
 
                    Button(action: {
                        //self.showingAlert = 1
                        //self.nameChanged = false
                    }) {
                        Image(systemName: "bin.xmark")
                    }
                    .foregroundColor(Color.pink)
                    .padding(.trailing)

                    Button(action: {
                        //self.showingAlert = 1
                        //self.nameChanged = false
                    }) {
                        Image(systemName: "chevron.right.circle")
                    }
                    .foregroundColor(Color.pink)
                }
                
                addName()

            }
            .rotationEffect(Angle(degrees: -45), anchor: .center)
            
        }
        .background(Color.blue)
        .edgesIgnoringSafeArea(.all)
        
        
    }
    
    // Pass id to edit existing Person.
    func addName( id : Int = 0 ) -> some View {
        
        Button(action: {
            self.showingAlert = 1
            self.nameChanged = false
            //print( "SSTODO - Button - Showing Alert \(self.showingAlert)" )
        }) {
            Text("Click to edit '\(self.name)'")
        }
        .foregroundColor(Color.pink)
        .padding(.top, 40)
        
    }
    
    func saveContext() {
        do {
            try managedObjectContext.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
    }
    
    
}

/*
 struct ContentView_Previews: PreviewProvider {
 static var previews: some View {
 ContentView(person: <#T##Person#>)
 }
 }
 */
