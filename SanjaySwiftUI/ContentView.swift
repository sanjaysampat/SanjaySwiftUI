//
//  ContentView.swift
//  SanjaySwiftUI
//
//  Created by Sanjay Sampat on 20/07/20.
//  Copyright © 2020 Sanjay Sampat. All rights reserved.
//

import SwiftUI

// SSTODO
//1) SCLAlertView using UIKit implementation
//2) Actual signin implementation


struct ContentView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject  var  userAuth: UserAuth
    
    @FetchRequest(
        entity: Person.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Person.datetime, ascending: true)
        ]
    ) var persons: FetchedResults<Person>

    @State private var currentPos:Int = -1

    @State private var name = "Name"
    @State private var showingAlert:Int = 0
    @State var showsAlert = false

    @State private var nameChanged = false
    
    @State private var isEditMode:Bool = false

    @State private var isPresentedStoryboardSanjay: Bool = false
    @State private var photoChanged = false
    @State private var personPhoto:UIImage? = nil

    private let paddingSize:CGFloat = 10
    
    @State private var lastPos:Int = -1

    @State var listSelection: Int? = 0
    
    //@ObservedObject var viewModel = ViewModel()
    
    var body: some View {
        ZStack() {
            
            if listSelection == 0 {
            
            // hidden control for code modifications.
            Toggle("", isOn:$nameChanged)
                .frame(width: 0, height: 0)
                .clipped()
                .onReceive([self.$nameChanged].publisher.first()) { (value) in
                    //print("New value nameChanged is: \(value)")
                    //print( "SSTODO - Toggle - Showing Alert \(self.showingAlert) and self.nameChanged=\(self.nameChanged)   self.isEditmode=\(self.isEditMode) self.currentPos=\(self.currentPos) self.name=\(self.name)" )
                    if self.currentPos < 0 {
                        print( "SSTODO - persons.count = \(self.persons.count)" )
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
                        self.nameChanged = false 
                    } else {
                        if self.persons.count > 0 {
                            self.name = self.persons[self.currentPos].name ?? "Name"
                        }
                    }
            }
            
            Rectangle()
                .scale(1.25)
                .rotation(Angle(degrees: -45), anchor: .center)
                .edgesIgnoringSafeArea(.all)
                //.opacity(0.15)
                .foregroundColor(CommonUtils.cu_activity_light_theam_color)

            
            Image(uiImage: self.personPhoto, placeholderSystemName: "person")
                .resizable(resizingMode: .stretch)
                .mask(LinearGradient(gradient: Gradient(stops: [
                    .init(color: .clear, location: 0),
                    .init(color: .black, location: 0.25),
                    .init(color: .black, location: 0.75),
                    .init(color: .clear, location: 1)
                ]), startPoint: .top, endPoint: .bottom))
                .mask(LinearGradient(gradient: Gradient(stops: [
                    .init(color: .clear, location: 0),
                    .init(color: .black, location: 0.25),
                    .init(color: .black, location: 0.75),
                    .init(color: .clear, location: 1)
                ]), startPoint: .leading, endPoint: .trailing))
                .rotationEffect(Angle(degrees: -45), anchor: .center)
                .scaledToFit()
                .scaleEffect(0.55)
                .opacity(0.45)
                .font(Font.title.weight(.ultraLight))
                .foregroundColor(CommonUtils.cu_activity_light_text_color)
                .onReceive([self.$photoChanged].publisher.first()) { (value) in
                    //print("New value photoChanged is: \(value)")
                    //print( "SSTODO - Toggle - self.photoChanged \(self.photoChanged) and self.nameChanged=\(self.nameChanged)   self.isEditmode=\(self.isEditMode) self.currentPos=\(self.currentPos) self.name=\(self.name)" )
                    if self.currentPos >= 0 {
                        if self.photoChanged {
                            if let photo = self.personPhoto {
                                // to save image in coredata
                                self.persons[self.currentPos].photo = photo.pngData()
                                self.saveContext()
                            }
                            self.photoChanged = false
                        } else if ( self.lastPos != self.currentPos) {
                            if let data = self.persons[self.currentPos].photo {
                                self.personPhoto = UIImage(data: data )
                            } else {
                                self.personPhoto = nil
                            }
                            self.lastPos = self.currentPos
                        }
                    }
            }
                
                
            Image(systemName: "heart")
                .resizable(resizingMode: .stretch)
                .rotationEffect(Angle(degrees: -45), anchor: .center)
                .scaledToFit()
                .foregroundColor(CommonUtils.cu_activity_foreground_color)
                .opacity(0.75)
            
                /*
                VStack {
                    Text("Hello, Alert!")
                }
                .alert(isPresented: $showsAlert, TextAlert(title: "What's name", action: {
                    print("Callback \($0 ?? "<cancel>")")
                }))
                */
                
            if self.showingAlert == 1 {
                PrintinView("SSTODO - PrintinView - ContentView - self.showingAlert \(self.showingAlert) and self.nameChanged=\(self.nameChanged) self.name=\(self.name)")
                AlertControlView(textChanged: $nameChanged,
                                 textString: $name,
                                 showAlert: $showingAlert,
                                 title: "in your Heart",
                                 message: "What's name ?")
                
            }
                
            
            VStack(alignment: .center) {
                Text("\(self.name)")
                    .font(.largeTitle)
                    .foregroundColor(CommonUtils.cu_activity_foreground_color)
                
                Text("in my Heart")
                    .font(.title)
                    .fontWeight(.thin)
                    .foregroundColor(CommonUtils.cu_activity_foreground_color)
                
                if self.persons.count > 0 {
                    Text("(\(self.currentPos+1) of \(self.persons.count))")
                        .font(.footnote)
                        .foregroundColor(CommonUtils.cu_activity_foreground_color)
                } else {
                    Text("(No Records)")
                    .font(.footnote)
                    .foregroundColor(CommonUtils.cu_activity_foreground_color)
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
                    .foregroundColor(CommonUtils.cu_activity_foreground_color)
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
                    .foregroundColor(CommonUtils.cu_activity_foreground_color)
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
                    .foregroundColor(CommonUtils.cu_activity_foreground_color)
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
                        CustomPersonPhotoImagePickerViewController(isPresentedStoryboardSanjay: self.$isPresentedStoryboardSanjay, photoChanged: self.$photoChanged,  photo: self.$personPhoto)
                   }
                    .foregroundColor(CommonUtils.cu_activity_foreground_color)
                    .padding(paddingSize)
                    .padding(.leading, paddingSize)
                
                    Button(action: {
                        if self.currentPos >= 0 {
                            self.listSelection = 1
                            
                        }
                    }) {
                        VStack( alignment: .center) {
                            Image(systemName: "square.stack.3d.down.right")
                            Text("List")
                                .font(.caption)
                        }
                    }
                    .foregroundColor(CommonUtils.cu_activity_foreground_color)
                    .padding(paddingSize)
                    .padding(.leading, paddingSize)
                    

                }
                
            }
            .rotationEffect(Angle(degrees: -45), anchor: .center)

        } else {
                ListView(listSelection: $listSelection, currentPos: $currentPos)
        }
            
        }
        .background(CommonUtils.cu_activity_background_color)
        .edgesIgnoringSafeArea(.all)
        
    }
    
    // Pass id to edit existing Person.
    func addName( id : Int = -1, padding : Bool = false ) -> some View {
        
        Button(action: {
            self.showingAlert = 1
            self.showsAlert = true
            self.nameChanged = false
            self.isEditMode = ( id >= 0 )
            //print( "SSTODO - Button - Showing Alert \(self.showingAlert) self.isEditMode=\(self.isEditMode) Id=\(id)" )
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
        .foregroundColor(CommonUtils.cu_activity_foreground_color)
        
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

extension Image {
    public init(uiImage: UIImage?, placeholderSystemName: String) {
        guard let uiImage = uiImage else {
            self = Image(systemName: placeholderSystemName)

            return
        }
        self = Image(uiImage: uiImage)
    }
}

/*
 //.mask(RadialGradient(gradient: Gradient(colors:[.blue, .white]), center: .center, startRadius: 2, endRadius: 1200))
 //.mask(AngularGradient(gradient: Gradient(colors:[.blue, .white]), center: .center))
 //.mask(LinearGradient(gradient: Gradient(colors: [
 //    .clear,
 //    .black
 //]), startPoint: .top, endPoint: .bottom))

 */
