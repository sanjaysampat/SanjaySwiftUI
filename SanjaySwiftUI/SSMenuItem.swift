//
//  SSMenuItem.swift
//  SanjaySwiftUI
//
//  Created by Sanjay Sampat on 02/02/21.
//  Copyright © 2021 Sanjay Sampat. All rights reserved.
//

import Foundation
import SwiftUI

struct SSMenuItem : Identifiable {
    var id = UUID()
    var title:String = ""
    var systemImage1:String = ""
    var systemImage2:String = ""
    var zstackAlignment:Alignment = .center
    var image1ScaleEffect:CGSize = CGSize(width: 1.0, height: 1.0)
    var image2ScaleEffect:CGSize = CGSize(width: 1.0, height: 1.0)
    var isGroupEnd:Bool = false
    var destination:AnyView
}

let mainMenuData = [
    // Not adding first item.
    SSMenuItem( title: "Audio/Video List View", systemImage1: "play.circle", systemImage2: "", isGroupEnd: false, destination: AnyView( AVListView() ) ),

    SSMenuItem( title: "List of conferance rooms", systemImage1: "rectangle", systemImage2: "person.2.fill", image1ScaleEffect: CGSize(width: 1.8, height: 1.8), image2ScaleEffect: CGSize(width: 0.8, height: 0.8), isGroupEnd: false, destination: AnyView( RoomListView() ) ),

    SSMenuItem( title: "Signature List", systemImage1: "signature", systemImage2: "", image1ScaleEffect: CGSize(width: 0.8, height: 1.4), isGroupEnd: true, destination: AnyView( SignatureListView() ) ),

    SSMenuItem( title: "Tab View", systemImage1: "bed.double.fill", systemImage2: "", isGroupEnd: true, destination: AnyView( TabSwiftUiView() ) ),

    SSMenuItem( title: "Apple Pay", systemImage1: "dollarsign.circle", systemImage2: "", isGroupEnd: true, destination: AnyView( PaymentSwiftUIView() ) ),

    SSMenuItem( title: "Play with Shapes", systemImage1: "cube.box", systemImage2: "", isGroupEnd: true, destination: AnyView( CheckShapesView() ) ),

    SSMenuItem( title: "Play with Grids", systemImage1: "square.grid.3x2", systemImage2: "", isGroupEnd: true, destination: AnyView( CheckGridsView() ) ),

    SSMenuItem( title: "Geometry", systemImage1: "sum", systemImage2: "function", zstackAlignment: .leading, image2ScaleEffect: CGSize(width: 0.8, height: 0.8), isGroupEnd: true, destination: AnyView( GeometryOfView() ) ),

    SSMenuItem( title: "Environment", systemImage1: "text.justify", systemImage2: "", isGroupEnd: true, destination: AnyView( EnviornmentView() ) ),

    SSMenuItem( title: "Enumeration Code Samples", systemImage1: "ellipsis.circle", systemImage2: "", isGroupEnd: false, destination: AnyView( EnumerationSampleView() ) ),

    SSMenuItem( title: "Browse web", systemImage1: "cloud", systemImage2: "", isGroupEnd: false, destination: AnyView( SSWebViewBrowse() ) ),

    SSMenuItem( title: "Form with Inline error validation using combine", systemImage1: "rectangle", systemImage2: "text.alignleft", image1ScaleEffect: CGSize(width: 1.2, height: 1.5), isGroupEnd: false, destination: AnyView( CombineFormView() ) ),

    SSMenuItem( title: "Chart Demo", systemImage1: "chart.bar.xaxis", systemImage2: "", isGroupEnd: false, destination: AnyView( ChartDemoView() ) ),

    SSMenuItem( title: "SF Symbols", systemImage1: "square.on.square.squareshape.controlhandles", systemImage2: "", isGroupEnd: false, destination: AnyView( SSSFSymbolSwiftUIView() ) ),

    SSMenuItem( title: "Screen Recording List", systemImage1: "squares.below.rectangle", systemImage2: "", isGroupEnd: false, destination: AnyView( RecordedListView() ) ),

]
