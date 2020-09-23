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
                    /*
                    NavigationLink(destination: Shape2(), label: {
                        Text("Effects on Standard Types")
                    })
                    
                    NavigationLink(destination: Shape3(), label: {
                        Text("Effects with CGAffineTransform")
                    })
                    
                    NavigationLink(destination: Shape4(), label: {
                        Text("Gradient Rectangle")
                    })
                 */
                }
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
        //.navigationBarTitle("Play with Grids")
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
        .navigationBarTitle("Regular Grids").padding(.bottom, 10)
    }
}

@available(iOS 14.0, *)
struct RegularGrid: View {
    let cols: Int = 6
    let spacing: CGFloat = 10
    let imgsize = CGSize(width: 150, height: 150)
        
    var body: some View {
        let gridItems = Array(repeating: GridItem(.fixed(imgsize.width), spacing: spacing), count: cols)

        ScrollView(.vertical) {
            LazyVGrid(columns: gridItems, spacing: spacing) {
                ForEach(0..<200) { idx in
                    Image("image-\(idx % 15)")
                        .resizable()
                        .frame(width: imgsize.width, height: imgsize.height)
                }
            }
        }
    }
}

struct CheckGridsView_Previews: PreviewProvider {
    static var previews: some View {
        CheckGridsView()
    }
}
