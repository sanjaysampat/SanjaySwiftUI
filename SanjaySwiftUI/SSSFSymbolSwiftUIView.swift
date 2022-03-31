//
//  SSSFSymbolSwiftUIView.swift
//  SanjaySwiftUI
//
//  Created by Sanjay Sampat on 03/01/22.
//  Copyright © 2022 Sanjay Sampat. All rights reserved.
//

import SwiftUI

enum SSSymbolRenderingMode: String, CaseIterable, Identifiable {
    case hierarchical, monochrome, multicolor, pallete
    
    var id: String { self.rawValue }
    
    @available(iOS 15.0, *)
    public var renderingMode: SymbolRenderingMode {
        switch self {
        case .multicolor:
            return .multicolor
        case .pallete:
            return .palette
        case .monochrome:
            return .monochrome
        default:
            return .hierarchical
        }
    }
}

struct SSSFSymbolSwiftUIView: View {
    
    @State private var symbolsArray: [String] = ssSFSymbolData
    @State private var message1:String = ""
    @State private var message2:String = ""
    @State private var symbolRenderingMode : SSSymbolRenderingMode = .hierarchical
    
    init() {
        
    }
    
    var body: some View {
        
        VStack {
            Text(" \(message2) [\(message1)]")
                .foregroundColor(.gray)
                .font(.system(size: 11))
            
            // ScrollViewReader provide is 'proxy' in list
            // this helps us to 'scrollTo' particular ID of item in List.
            //ScrollViewReader { proxy in
            // I am still unable to make it working on 'SSSymbolList' - pending to check
                
                HStack {
                    Spacer()
                    Text("SF Symbols")
                    Spacer()
                    Button(action: {
                        //proxy.scrollTo(symbolsArray.first)
                        //withAnimation {
                            symbolsArray.shuffle()
                        //}
                    }, label: {
                        Text("Shuffle \(Image(systemName: "shuffle.circle"))")
                            .padding(.vertical, 2)
                    })
                    Spacer()
                }
                
                if #available(iOS 15.0, *) {
                    Text("Symbol Rendering Mode : \(symbolRenderingMode.rawValue)")
                        .padding(.bottom, 0)
                    Picker("", selection: $symbolRenderingMode) {
                        ForEach(SSSymbolRenderingMode.allCases, id: \.self) {
                            Text($0.rawValue)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    SSSymbolList(symbolsArray: $symbolsArray, symbolRenderingMode: $symbolRenderingMode, message1: $message1, message2: $message2)
                } else {
                    ScrollView(.vertical) {
                        ForEach(symbolsArray, id: \.self ) { symbolSingle in
                            SSSymbolRow(symbol: symbolSingle)
                        }
                    }
                }
            //} // ScrollViewReader
            
        }
    }
}

@available(iOS 15.0, *)
struct SSSymbolList: View {
    
    @Binding var symbolsArray: [String]
    @Binding var symbolRenderingMode : SSSymbolRenderingMode
    @Binding var message1:String
    @Binding var message2:String
    
    @State private var searchQuery: String = ""
    @State private var confirmationShow = false
    @State private var selectedIndex = -1
    
    var body: some View {
        
        VStack {
            List{
                ForEach(symbolsArray, id: \.self ) { symbolSingle in
                    SSSymbolRow(symbol: symbolSingle)
                        .symbolRenderingMode(symbolRenderingMode.renderingMode)
                    //.foregroundStyle(.red, .green, .blue)
                        .swipeActions {
                            Button(
                                role: .destructive,
                                action: {
                                    selectedIndex = symbolsArray.firstIndex(of: symbolSingle) ?? -1
                                    if selectedIndex >= 0 {
                                        confirmationShow = true
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
                submitCurrentSearchQuery( passedSearchString: searchQuery, dismissKeyboard:true )
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
        }
    }
    
    func submitCurrentSearchQuery( passedSearchString:String = "", dismissKeyboard:Bool = false ) {
        if passedSearchString.isEmpty {
            symbolsArray = ssSFSymbolData
        } else {
            //print("Submitted search query \(searchQuery)")
            let searchedSymbols = symbolArrayFoundFrom(searchQuery: passedSearchString.isEmpty ? searchQuery : passedSearchString)
            
            symbolsArray = searchedSymbols
        }
        message1 = "\(symbolsArray.count) items"
        if dismissKeyboard {
            self.endEditing()
        }
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
