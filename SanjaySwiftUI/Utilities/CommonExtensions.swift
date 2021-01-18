//
//  CommonExtensions.swift
//  SanjaySwiftUI
//
//  Created by Sanjay Sampat on 10/08/20.
//  Copyright © 2020 Sanjay Sampat. All rights reserved.
//

import Foundation
import SwiftUI

// Alphabetically kept

extension Collection {
    func choose(_ n: Int) -> ArraySlice<Element> { shuffled().prefix(n) }
}

extension Image {
    // init to create UIImage or show placeholderSystemName image.
    public init(uiImage: UIImage?, placeholderSystemName: String) {
        guard let uiImage = uiImage else {
            self = Image(systemName: placeholderSystemName)

            return
        }
        self = Image(uiImage: uiImage)
    }
}

extension View {
    // useful to print messages in Debug area from SwiftUI View
    func PrintinView(_ vars: Any...) -> some View {
        for v in vars { print(v) }
        return EmptyView()
    }
    
    // useful to dismiss keyboard from view.
    func endEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    // to round specific corners. ( eg. .cornerRadius(topLeft, corners: .topLeft) )
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
    
    /*
    func flippedUpsideDown() -> some View{
        self.modifier(FlippedUpsideDown())
        
    }
     */
}

// used in cornerRadius, to round specific corners. ( eg. .cornerRadius(topLeft, corners: .topLeft) )
struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

/*
struct FlippedUpsideDown: ViewModifier {
    func body(content: Content) -> some View {
        content
            .rotationEffect(Angle(degrees: .pi))
            .scaleEffect(x: -1, y: 1, anchor: .center)
    }}
*/

// 
