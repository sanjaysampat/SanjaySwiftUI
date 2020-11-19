//
//  CheckGridsView.swift
//  SanjaySwiftUI
//
//  Created by Sanjay Sampat on 23/09/20.
//  Copyright © 2020 Sanjay Sampat. All rights reserved.
//

import SwiftUI

struct CheckGridsView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: Grid1(), label: {
                    Text("Regular Grids")
                })
                
                NavigationLink(destination: Grid2(), label: {
                    Text("Honeycomb Grid")
                })
                
                NavigationLink(destination: Grid3(), label: {
                    Text("Resizable Grid")
                })
                
                /*
                 NavigationLink(destination: Shape4(), label: {
                 Text("Gradient Rectangle")
                 })
                 */
            }
        }
        //.navigationBarTitle("")
        //.navigationBarHidden(true)
        .navigationBarTitle(Text("Play with Grids"), displayMode: .inline)
        // for navigationbar hide issue, please see the FULL answer
        // https://stackoverflow.com/a/57518324/2641380
        
    }
}

struct Grid1: View {
    var body: some View {
        VStack {
            if #available(iOS 14.0, *) {
                RegularGrid()
            } else {
                Text("The example will work only on and above iOS 14.")
            }
        }
        .navigationBarTitle(Text("Regular Grids"), displayMode: .inline)
        //.padding(.bottom, 10)
    }
}

struct Grid2: View {
    var body: some View {
        VStack {
            if #available(iOS 14.0, *) {
                HoneycombGrid()
            } else {
                Text("The example will work only on and above iOS 14.")
            }
        }
        .navigationBarTitle(Text("Honeycomb Grid"), displayMode: .inline)
        //.padding(.bottom, 10)
    }
}

struct Grid3: View {
    var body: some View {
        VStack {
            if #available(iOS 14.0, *) {
                ResizableGrid()
            } else {
                Text("The example will work only on and above iOS 14.")
            }
        }
        .navigationBarTitle(Text("Resizable Grid"), displayMode: .inline)
        //.padding(.bottom, 10)
    }
}

// MARK:- Grid1

@available(iOS 14.0, *)
struct RegularGrid: View {
    let cols: Int = 3
    let spacing: CGFloat = 4
    let imgsize = CGSize(width: 150, height: 150)
    
    var body: some View {
        let gridItems = Array(repeating: GridItem(.fixed(imgsize.width), spacing: spacing), count: cols)
        
        ScrollView(.vertical) {
            LazyVGrid(columns: gridItems, spacing: spacing) {
                ForEach(0..<200) { idx in
                    Image("img-\(idx % 42)")
                        .resizable()
                        .scaledToFit()
                        .frame(width: imgsize.width, height: imgsize.height)
                }
            }
        }
    }
}

// MARK:- Grid2
fileprivate let honeycombGridCols: Int = 4

@available(iOS 14.0, *)
struct HoneycombGrid: View {
    let spacing: CGFloat = 4
    let imgsize = CGSize(width: 140, height: 140)
    var hexagonWidth: CGFloat { (imgsize.width / 2) * cos(.pi / 6) * 2 }
    
    // global function gMemoize defined in 'CommonUtils.swift'
    let memoizedisToAddDummy = gMemoize( isToAddDummy )
    let memoizedIsOddRow = gMemoize( isOddRow )

    var body: some View {
        let gridItems = Array(repeating: GridItem(.fixed(hexagonWidth), spacing: spacing), count: honeycombGridCols)
        
        ScrollView(.vertical) {
            LazyVGrid(columns: gridItems, spacing: spacing) {
                ForEach(0..<200) { idx in
                    
                    VStack(spacing: 0) {
                        Image("img-\(idx % 41)")
                            .resizable()
                            .scaledToFit()
                            .frame(width: imgsize.width, height: imgsize.height)
                            .clipShape(PolygonShape(sides: 6).rotation(Angle.degrees(90)))
                            .offset(x: memoizedIsOddRow(idx) ? 0 : hexagonWidth / 2 + (spacing/2))
                    }
                    .frame(width: hexagonWidth, height: imgsize.height * 0.75)
                    
                    if memoizedisToAddDummy(idx) {
                        // TO add one dummy image here to skip hidden image in even row.
                        VStack(spacing: 0) {
                            EmptyView()
                                .frame(width: imgsize.width, height: imgsize.height)
                                .clipShape(PolygonShape(sides: 6).rotation(Angle.degrees(90)))
                                .offset(x: memoizedIsOddRow(idx) ? 0 : hexagonWidth / 2 + (spacing/2))
                        }
                        .frame(width: hexagonWidth, height: imgsize.height * 0.75)
                        
                    }
                    
                }
            }
            .frame(width: (hexagonWidth + spacing) * CGFloat(honeycombGridCols-1))
        }
    }
    
}

func isOddRow(_ idx: Int) -> Bool {
    for i in idx ... idx + (honeycombGridCols-2)  {
        if isToAddDummy(i) {
            //print("isEVENRow id=\(idx) ")
            return false
        }
    }
    return true
}

func isToAddDummy(_ idx: Int) -> Bool {
    let ireturn = (idx > 0) && (idx+1) % ((honeycombGridCols*2)-1) == 0
    if ireturn {
        //print("isToAddDummy id=\(idx)")
    }
    return ireturn
}


struct PolygonShape: Shape {
    var sides: Int
    
    func path(in rect: CGRect) -> Path {
        let h = Double(min(rect.size.width, rect.size.height)) / 2.0
        let c = CGPoint(x: rect.size.width / 2.0, y: rect.size.height / 2.0)
        var path = Path()
        
        for i in 0..<sides {
            let angle = (Double(i) * (360.0 / Double(sides))) * Double.pi / 180
            
            let pt = CGPoint(x: c.x + CGFloat(cos(angle) * h), y: c.y + CGFloat(sin(angle) * h))
            
            if i == 0 {
                path.move(to: pt) // move to first vertex
            } else {
                path.addLine(to: pt) // draw line to next vertex
            }
        }
        
        path.closeSubpath()
        
        return path
    }
}

// MARK:- Grid3

@available(iOS 14.0, *)
struct ResizableGrid: View {
    @State private var gridWidth: CGFloat = 400
    @State private var info: GridInfo = GridInfo()
    
    let spacing: CGFloat = 4
    
    var body: some View {
        let gridItems = [GridItem(.adaptive(minimum: 100, maximum: .infinity), spacing: spacing)]
        
        VStack {
            ScrollView(.vertical) {
                LazyVGrid(columns: gridItems, spacing: spacing, pinnedViews: .sectionHeaders) {
                    Section(header: HeaderView(info: self.info)) {
                        ForEach(0..<200) { idx in
                            Image("img-\(idx % 42)")
                                .resizable()
                                //.scaledToFit() // Not working here TODO
                                .frame(height: info.cellWidth(idx))
                                .gridInfoId(idx)
                        }
                    }
                }
                .frame(width: gridWidth)
                .gridInfo($info)
            }
            
            Slider(value: $gridWidth, in: 0...1500)
        }
    }
    
    struct HeaderView: View {
        let info: GridInfo
        
        var body: some View {
            HStack(spacing: 0) {
                ForEach(0..<info.columnCount) { colIdx in
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.7))
                        .frame(width: info.columnWidth(colIdx))
                        .overlay(Text("Column \(colIdx + 1)"))
                        .padding(.trailing, info.spacing(colIdx))
                }
                // Force ForEach to redraw when columnCount changes.
                // Not best solution, but good enough for this example.
                .id(info.columnCount)
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .frame(height: 40)
        }
    }
    
}

struct GridInfoPreference {
    let id: Int
    let bounds: Anchor<CGRect>
}

struct GridPreferenceKey: PreferenceKey {
    static var defaultValue: [GridInfoPreference] = []
    
    static func reduce(value: inout [GridInfoPreference], nextValue: () -> [GridInfoPreference]) {
        return value.append(contentsOf: nextValue())
    }
}

struct GridInfo: Equatable {
    // A array of all rendered cells's bounds
    var cells: [Item] = []
    
    // a computed property that returns the number of columns
    var columnCount: Int {
        guard cells.count > 1 else { return cells.count }
        
        var k = 1
        
        for i in 1..<cells.count {
            if cells[i].bounds.origin.x > cells[i-1].bounds.origin.x {
                k += 1
            } else {
                break
            }
        }
        
        return k
    }
    
    // a computed property that returns the range of cells being rendered
    var cellRange: ClosedRange<Int>? {
        guard let lower = cells.first?.id, let upper = cells.last?.id else { return nil }
        
        return lower...upper
    }
    
    // returns the width of a rendered cell
    func cellWidth(_ id: Int) -> CGFloat {
        columnCount > 0 ? columnWidth(id % columnCount) : 0
    }
    
    // returns the width of a column
    func columnWidth(_ col: Int) -> CGFloat {
        columnCount > 0 && col < columnCount ? cells[col].bounds.width : 0
    }
    
    // returns the spacing between columns col and col+1
    func spacing(_ col: Int) -> CGFloat {
        guard columnCount > 0 else { return 0 }
        let left = col < columnCount ? cells[col].bounds.maxX : 0
        let right = col+1 < columnCount ? cells[col+1].bounds.minX : left
        
        return right - left
    }
    
    // Do not forget the "Equatable", as it prevent redrawing loops
    struct Item: Equatable {
        let id: Int
        let bounds: CGRect
    }
}

extension View {
    func gridInfoId(_ id: Int) -> some View {
        self.anchorPreference(key: GridPreferenceKey.self, value: .bounds) {
            [GridInfoPreference(id: id, bounds: $0)]
        }
    }
    
    func gridInfo(_ info: Binding<GridInfo>) -> some View {
        self.backgroundPreferenceValue(GridPreferenceKey.self) { prefs in
            GeometryReader { proxy -> Color in
                DispatchQueue.main.async {
                    info.wrappedValue.cells = prefs.compactMap {
                        GridInfo.Item(id: $0.id, bounds: proxy[$0.bounds])
                    }
                }
                
                return Color.clear
            }
        }
    }
}


// MARK:- CheckGridsView_Previews

struct CheckGridsView_Previews: PreviewProvider {
    static var previews: some View {
        CheckGridsView()
    }
}
