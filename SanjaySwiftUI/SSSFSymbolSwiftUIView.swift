//
//  SSSFSymbolSwiftUIView.swift
//  SanjaySwiftUI
//
//  Created by Sanjay Sampat on 28/12/21.
//  Copyright © 2021 Sanjay Sampat. All rights reserved.
//

import SwiftUI

struct SSSFSymbolSwiftUIView: View {
    
    @State private var searchQuery: String = ""
    
    @State private var symbolsArray: [String] = ssSFSymbolData
    @State private var confirmationShow = false
    @State private var selectedIndex = -1
    @State private var message1:String = ""
    @State private var message2:String = ""

    init() {
        
    }

    var body: some View {
        VStack {
            Text(" \(message2)")
                .foregroundColor(.gray)
                .font(.system(size: 11))
            HStack {
                Spacer()
                Text("SF Symbols")
                Spacer()
                Button(action: {
                    symbolsArray.shuffle()
                }, label: {
                    Text("Shuffle \(Image(systemName: "shuffle.circle"))")
                        .padding(.vertical, 2)
                })
                Spacer()
            }
            Text(" \(message1)")
                .foregroundColor(.gray)
                .font(.system(size: 11))
            if #available(iOS 15.0, *) {
                List{
                    ForEach(symbolsArray, id: \.self ) { symbolSingle in
                        SSSymbolRow(symbol: symbolSingle)
                            .swipeActions {
                                Button(
                                    role: .destructive,
                                    action: {
                                        selectedIndex = symbolsArray.firstIndex(of: symbolSingle) ?? -1
                                        if selectedIndex >= 0 {
                                            confirmationShow = true
                                            //print("selection : \(selectedIndex) : \(signatureSingle.name)")
                                        }
                                    }
                                ) {
                                    Image(systemName: "trash")
                                }
                            }
                            .confirmationDialog(
                                "Are you sure?",
                                isPresented: $confirmationShow,
                                titleVisibility: .visible // .automatic
                            ) {
                                Button("Yes") {
                                    confirmationShow = false
                                    if selectedIndex >= 0 && symbolsArray.count > selectedIndex {
                                        let symbolRec = symbolsArray[selectedIndex]
                                        //print("delete : \(selectedIndex) : \(signatureRec.name)")
                                        withAnimation {
                                            symbolsArray.remove(at: selectedIndex)
                                            selectedIndex = -1
                                            message1 = "\(symbolsArray.count) items"
                                        }
                                    }
                                }
                                Button("No", role: .cancel) {
                                    confirmationShow = false
                                    selectedIndex = -1
                                }
                            } message: {
                                Text("you want to delete symbol of \(selectedIndex >= 0 && symbolsArray.count > selectedIndex ? symbolsArray[selectedIndex] : "(no record)")")
                            }
                    }
                    .listRowSeparatorTint(Color.green)
                    .listRowSeparator(.visible, edges: .all)
                }
                .searchable(text: $searchQuery, placement: .automatic, prompt:"Search term")
                // SSNote : to NOT to autocorrect in search bar, disableAutocorrection(true)
                .disableAutocorrection(true)
                .onChange(of: searchQuery) {
                    //print($0)
                    submitCurrentSearchQuery(passedSearchString: $0)
                }
                .onSubmit(of: .search) {
                    submitCurrentSearchQuery()
                }
                .listStyle(.grouped)
                .refreshable {
                    // SSNote : Pull to Refresh funtionality of List
                    submitCurrentSearchQuery()
                    
                }
                .onAppear() {
                    message1 = "\(symbolsArray.count) items"
                    message2 = "Pull to Refresh"
                }
                
            } else {
                ScrollView(.vertical) {
                    ForEach(symbolsArray, id: \.self ) { symbolSingle in
                        SSSymbolRow(symbol: symbolSingle)
                    }
                }
            }
        }
    }
    
    func submitCurrentSearchQuery( passedSearchString:String = "" ) {
        if passedSearchString.isEmpty {
            symbolsArray = ssSFSymbolData
        } else {
            //print("Submitted search query \(searchQuery)")
            let searchedSymbols = symbolArrayFoundFrom(searchQuery: passedSearchString.isEmpty ? searchQuery : passedSearchString)
            
            symbolsArray = searchedSymbols
        }
        message1 = "\(symbolsArray.count) items"
    }

}

struct SSSymbolRow: View {
    @State var symbol:String
    
    var body: some View {
        //if #available(iOS 15.0, *) {
            
        //} else {
        VStack(alignment: .leading) {
            Image(systemName: symbol)
                .resizable()
                .scaledToFit()
                .font(Font.title.weight(.ultraLight))
                .frame(minWidth: 50, idealWidth: 100, maxWidth: 200, minHeight: 50, idealHeight: 100, maxHeight: 100)
                .padding()
                .background(ColorScheme.text)
                .cornerRadius(20)
            Text("\(symbol)")
                .font(.footnote)
        }
        //}
    }
}

struct SSSFSymbolSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SSSFSymbolSwiftUIView()
    }
}
