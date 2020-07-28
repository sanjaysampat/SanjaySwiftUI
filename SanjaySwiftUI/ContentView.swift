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
            NSSortDescriptor(keyPath: \Person.datetime, ascending: true)
        ]
    ) var persons: FetchedResults<Person>
    
    @State private var name = "Name"
    @State private var showingAlert:Int = 0
    @State private var nameChanged = false
    @State private var currentPos:Int = -1
    
    @State private var isEditMode:Bool = false

    @State private var isPresentedStoryboardSanjay: Bool = false
    @State private var personPhoto:UIImage? = nil

    private let paddingSize:CGFloat = 10
    
    //@ObservedObject var viewModel = ViewModel()
    
    var body: some View {
        ZStack() {
            
            // SSTODO to save image in coredata
            // self.persons[self.currentPos].photo = UIImagePNGRepresentation( self.personPhoto )
            
            // hidden control for code modifications.
            Toggle("", isOn:$nameChanged)
                .frame(width: 0, height: 0)
                .clipped()
                .onReceive([self.$nameChanged].publisher.first()) { (value) in
                    //print("New value is: \(value)")
                    print( "SSTODO - Toggle - Showing Alert \(self.showingAlert) and self.nameChanged=\(self.nameChanged)   self.isEditmode=\(self.isEditMode) self.currentPos=\(self.currentPos) self.name=\(self.name)" )
                    if self.currentPos < 0 {
                        self.currentPos = self.persons.count-1
                    }
                    if self.nameChanged {
                        let formatter3 = DateFormatter()
                        formatter3.dateFormat = "yyyyMMddHHmmss"
                        let dateTimeString = formatter3.string(from: Date())
                        if self.persons.count <= 0 || !self.isEditMode {
                            let newPerson = Person(context: self.managedObjectContext)
                            newPerson.name = self.name
                            newPerson.datetime = dateTimeString
                            self.saveContext()
                            self.currentPos = self.persons.count-1
                        } else if self.name != self.persons[self.currentPos].name {
                            self.persons[self.currentPos].name = self.name
                            self.saveContext()
                        }
                        self.nameChanged = false  // SSLASTCHANGE
                    } else {
                        if self.persons.count > 0 {
                            self.name = self.persons[self.currentPos].name ?? "Name"
                            if let data = self.persons[self.currentPos].photo {
                                self.personPhoto = UIImage(data: data )
                            }
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
                PrintinView("SSTODO - ContentView - self.showingAlert \(self.showingAlert) and self.nameChanged=\(self.nameChanged) self.name=\(self.name)")
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
                    Text("(\(self.currentPos+1) of \(self.persons.count))")
                        .font(.footnote)
                        .foregroundColor(Color.pink)
                } else {
                    Text("(No Records)")
                    .font(.footnote)
                    .foregroundColor(Color.pink)
                }
                
                HStack(alignment: .center) {
                    
                    addName(id: self.currentPos, padding: true)
                    
                    Button(action: {
                        self.currentPos = self.currentPos - 1
                        if ( self.currentPos < 0 ) {
                            self.currentPos = self.persons.count-1
                        }
                    }) {
                        VStack( alignment: .center) {
                            Image(systemName: "chevron.left.circle")
                            Text("Previous")
                                .font(.caption)
                        }
                    }
                    .foregroundColor(Color.pink)
                    .padding(paddingSize)
                    
                    Button(action: {
                        self.currentPos = self.currentPos + 1
                        if ( self.currentPos >= self.persons.count ) {
                            self.currentPos = 0
                        }
                    }) {
                        VStack( alignment: .center) {
                            Image(systemName: "chevron.right.circle")
                            Text("Next")
                                .font(.caption)
                        }
                    }
                    .foregroundColor(Color.pink)
                    .padding(paddingSize)

                    Button(action: {
                        _ =
                            self.managedObjectContext.delete(self.persons[self.currentPos])
                        self.saveContext()
                        self.currentPos = self.currentPos - 1
                        if ( self.currentPos < 0 ) {
                            self.currentPos = self.persons.count-1
                        }
                        self.name = self.currentPos >= 0 ? self.persons[self.currentPos].name ?? "Name" : "Name"
                        
                    })
                    {
                        VStack( alignment: .center) {
                            Image(systemName: "bin.xmark")
                            Text("Delete")
                                .font(.caption)
                        }
                    }
                    .foregroundColor(Color.pink)
                    .padding(paddingSize)

                }
                
                HStack(alignment: .center) {
                    
                    addName(id: -1, padding: true)
                
                    Button(action: {
                        if self.currentPos >= 0 {
                            self.isPresentedStoryboardSanjay.toggle()
                        } else {
                            // Show error to add person.
                        }
                    }) {
                        VStack( alignment: .center) {
                            Image(systemName: "photo")
                            Text("Photo")
                                .font(.caption)
                        }
                    }
                    .sheet(isPresented: $isPresentedStoryboardSanjay)
                    {
                        CustomViewController(isPresentedStoryboardSanjay: self.$isPresentedStoryboardSanjay, photo: self.$personPhoto)
                    }
                    .foregroundColor(Color.pink)
                    .padding(paddingSize)
                    .padding(.leading, paddingSize * 4)

                }
                
            }
            .rotationEffect(Angle(degrees: -45), anchor: .center)
            
        }
        .background(Color.blue)
        .edgesIgnoringSafeArea(.all)
        
        
    }
    
    // Pass id to edit existing Person.
    func addName( id : Int = -1, padding : Bool = false ) -> some View {
        
        Button(action: {
            self.showingAlert = 1
            self.nameChanged = false
            self.isEditMode = ( id >= 0 )
            print( "SSTODO - Button - Showing Alert \(self.showingAlert) self.isEditMode=\(self.isEditMode) Id=\(id)" )
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
        .padding(padding ? paddingSize : 0)
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

extension View {
    func PrintinView(_ vars: Any...) -> some View {
        for v in vars { print(v) }
        return EmptyView()
    }
}
