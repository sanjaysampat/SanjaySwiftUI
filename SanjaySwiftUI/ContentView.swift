//
//  ContentView.swift
//  SanjaySwiftUI
//
//  Created by Sanjay Sampat on 20/07/20.
//  Copyright © 2020 Sanjay Sampat. All rights reserved.
//

import SwiftUI

class ViewModel: ObservableObject {
    @State var name = "Name"
    
    @FetchRequest(
        entity: Person.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Person.name, ascending: true)
        ]
    ) var persons: FetchedResults<Person>
    
    @Published var showingAlert = 0 {
        didSet {
            if showingAlert == 2 {
                if name != persons[0].name {
                    persons[0].name = name
                }
            }
        }
    }
}

struct ContentView: View {
    
    /*
    @State private var name = "Name"
    @State private var showingAlert:Int = 0
    
    @FetchRequest(
        entity: Person.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Person.name, ascending: true)
        ]
    ) var persons: FetchedResults<Person>
    */
    
    @Environment(\.managedObjectContext) var managedObjectContext

    @ObservedObject var viewModel = ViewModel()
    
    var body: some View {
        ZStack() {
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

            if viewModel.showingAlert == 1 {
                
                AlertControlView(textString: $viewModel.name,
                                 showAlert: $viewModel.showingAlert,
                                 title: "Lover",
                                 message: "What's name ?")
                
            }

            VStack(alignment: .center) {
                Text("\(viewModel.name)")
                    .font(.largeTitle)
                    .foregroundColor(Color.pink)
                
                Text("in my Heart")
                    .font(.title)
                    .fontWeight(.thin)
                    .foregroundColor(Color.pink)
                    .padding(.bottom)
                                
                Button(action: {
                    self.viewModel.showingAlert = 1
                }) {
                    Text("Click to write '\(viewModel.name)'")
                }
                    .foregroundColor(Color.pink)

            }
            .rotationEffect(Angle(degrees: -45), anchor: .center)

        }
        .background(Color.blue)
        .edgesIgnoringSafeArea(.all)

    
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
