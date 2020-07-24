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
                    
                    addName(id: 0)
                    
                    Button(action: {
                        //self.showingAlert = 1
                        //self.nameChanged = false
                    }) {
                        VStack( alignment: .center) {
                            Image(systemName: "chevron.left.circle")
                            Text("Previous")
                                .font(.caption)
                        }
                    }
                    .foregroundColor(Color.pink)

                    Button(action: {
                        //self.showingAlert = 1
                        //self.nameChanged = false
                    }) {
                        VStack( alignment: .center) {
                            Image(systemName: "chevron.right.circle")
                            Text("Next")
                                .font(.caption)
                        }
                    }
                    .foregroundColor(Color.pink)
                    
                    Button(action: {
                        //self.showingAlert = 1
                        //self.nameChanged = false
                    }) {
                        VStack( alignment: .center) {
                            Image(systemName: "bin.xmark")
                            Text("Delete")
                                .font(.caption)
                        }
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
    func addName( id : Int = -1 ) -> some View {
        
        Button(action: {
            self.showingAlert = 1
            self.nameChanged = false
            //print( "SSTODO - Button - Showing Alert \(self.showingAlert)" )
        }) {
            if ( id >= 0 ) {
                VStack( alignment: .center) {
                        Image(systemName: "square.and.pencil")
                        Text("Edit")
                            .font(.caption)
                    }
            } else {
                VStack( alignment: .center) {
                    Image(systemName: "plus.square.on.square")
                    Text("Add")
                        .font(.caption)
                }
            }
        }
        .foregroundColor(Color.pink)
        
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
