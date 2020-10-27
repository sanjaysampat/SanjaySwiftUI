//
//  EnviornmentView.swift
//  SanjaySwiftUI
//
//  Created by Sanjay Sampat on 21/09/20.
//  Copyright © 2020 Sanjay Sampat. All rights reserved.
//

import SwiftUI

struct EnviornmentView: View {
    @Environment(\.colorScheme) var colorScheme
    //.dark or .light
    @Environment(\.colorSchemeContrast) var colorSchemeContrast
    //.increased or .standard
    @Environment(\.legibilityWeight) var legibilityWeight
    //.bold or .standard
    @Environment(\.presentationMode) var presentationMode
    //.isPresented = true or false
    //.dismiss() ends presentation of View
    @Environment(\.editMode) var editMode
    //.active when content can be edited
    //.inactive when content cannot be edited
    //.transient
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    //.compact or .regular
    @Environment(\.verticalSizeClass) var verticalSizeClass
    //.compact or .regular
    @Environment(\.disableAutocorrection) var disableAutocorrection
    //If autocorrection is enabled (false) or disabled (true)
    @Environment(\.sizeCategory) var sizeCategory
    //Font size
    //.extraSmall, .small, .medium, .large, .extraLarge, .extraExtraLarge, .extraExtraExtraLarge, .accessibilityMedium, .accessibilityLarge, .accessibilityExtraLarge, .accessibilityExtraExtraLarge, .accessibilityExtraExtraExtraLarge
    @Environment(\.managedObjectContext) var managedObjectContext
    //Management for persistent data storage
    @Environment(\.undoManager) var undoManager
    //nil if undo/redo disabled, otherwise manages undo/redo
    @Environment(\.layoutDirection) var layoutDirection
    //.leftToRight or .rightToLeft
    @Environment(\.defaultMinListRowHeight) var defaultMinListRowHeight
    //Minimum height of a List row (system default if nil)
    @Environment(\.defaultMinListHeaderHeight) var defaultMinListHeaderHeight
    //Minimum height of a List header (system default if nil)
    @Environment(\.isEnabled) var isEnabled
    //Whether user interaction is enabled (true) or disabled (false)
    @Environment(\.font) var font
    //The font for the View
    @Environment(\.displayScale) var displayScale
    //Amount that text size is increased to, maximum is 2
    @Environment(\.pixelLength) var pixelLength
    //Equal to 1 divided by display scale
    @Environment(\.locale) var locale
    //.isRegionCodes, isoLanguageCodes, isoCurrencyCodes
    @Environment(\.calendar) var calendar
    //The current calendar type
    //.buddhist, .chinese, .coptic, .ethiopicAmeteAlem, .ethiopicAmeteMihret, .gregorian, .hebrew, .indian, .islamic, .islamicCivil, .islamicTabular, .islamicUmmAlQura, .iso8601, .japanese, .persian, .republicOfChina
    //The type of calenar
    @Environment(\.timeZone) var timeZone
    //The current time zone
    @Environment(\.accessibilityEnabled) var accessibilityEnabled
    //Whether one or more accessibility features is enabled (true) or disabled (false)
    @Environment(\.accessibilityDifferentiateWithoutColor) var accessibilityDifferentiateWithoutColor
    //Whether differentiate colour is enabled (true) or disabled (false) in Accessibility settings
    @Environment(\.accessibilityReduceTransparency) var accessibilityReduceTransparency
    //Whether reduce transparency is enabled (true) or disabled (false) in Accessibility settings
    @Environment(\.accessibilityReduceMotion) var accessibilityReduceMotion
    //Whether reduce motion is enabled (true) or disabled (false) in Accessibility settings
    @Environment(\.accessibilityInvertColors) var accessibilityInvertColors
    //Whether invert colours is enabled (true) or disabled (false) in Accessibility settings
    @Environment(\.multilineTextAlignment) var multilineTextAlignment
    //How Text is aligned when it has an explicit width
    //.center, .leading or .trailing
    @Environment(\.truncationMode) var truncationMode
    //Which part of the text that becomes '...' when out of space
    //.head, .middle or .tail
    @Environment(\.lineSpacing) var lineSpacing
    //Spacing between lines of a Text
    @Environment(\.allowsTightening) var allowsTightening
    //Whether letter spacing will be tightened on a Text
    @Environment(\.lineLimit) var lineLimit
    //The maximum number of lines of a Text, default is nil (no limit)
    @Environment(\.minimumScaleFactor) var minimumScaleFactor
    //The smallest a View can be scaled between 0 and 1
    //MacOS only
    //@Environment(\.controlActiveState) var controlActiveState
    
    @State var keys: [Any] = [""]
    @State var presented = false
    
    let names = ["colorScheme", "colorSchemeContrast", "legibilityWeight", "presentationMode", "editMode", "horizontalSizeClass", "verticalSizeClass", "disableAutocorrection", "sizeCategory", "managedObjectContext", "undoManager", "layoutDirection", "defaultMinListRowHeight", "defaultMinListHeaderHeight", "isEnabled", "font", "displayScale", "pixelLength", "locale", "calendar", "timeZone", "accessibilityEnabled", "accessibilityDifferentiateWithoutColor", "accessibilityReduceTransparency", "accessibilityReduceMotion", "accessibilityInvertColors", "multilineTextAlignment", "truncationMode", "lineSpacing", "allowsTightening", "lineLimit", "minimumScaleFactor"]
    
    func setArray() {
        if keys.count == 1 {
            self.keys = [self.colorScheme, self.colorSchemeContrast, self.legibilityWeight ?? .regular, self.presentationMode, self.editMode?.wrappedValue ?? EditMode.inactive, self.horizontalSizeClass ?? .regular, self.verticalSizeClass ?? .regular, self.disableAutocorrection ?? false, self.sizeCategory, self.managedObjectContext, self.undoManager ?? UndoManager(), self.layoutDirection, self.defaultMinListRowHeight, self.defaultMinListHeaderHeight ?? 0, self.isEnabled, self.font ?? Font.body, self.displayScale, self.pixelLength, self.locale, self.calendar, self.timeZone, self.accessibilityEnabled, self.accessibilityDifferentiateWithoutColor, self.accessibilityReduceTransparency, self.accessibilityReduceMotion, self.accessibilityInvertColors, self.multilineTextAlignment, self.truncationMode, self.lineSpacing, self.allowsTightening, self.lineLimit as Any, self.minimumScaleFactor]
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                EditButton()    // SSTODO this does not work, to check. To check if FORM is required here.
                Button(action: {self.presented.toggle()}) {
                    Text("Present")
                }
                
            }
            List {
                ForEach(0..<keys.count, id: \.self) { index in
                    VStack(alignment: .leading) {
                        Text("\(self.names[index])")
                            .font(.title)
                        Text("\(String(describing: self.keys[index]))")
                        
                    }
                    .onAppear(perform: {self.setArray()})
                }
                
            }
            
        }
        .sheet(isPresented: $presented, content: {PresentedView()})    }
}

struct PresentedView : View {
    @Environment(\.presentationMode) var presentationMode
    //.isPresented = true or false
    //.dismiss() ends presentation of View
    var body : some View {
        VStack {
            Text("presentationMode")
                .font(.title)
            Text(String(describing: presentationMode))
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("Dismiss")
            }
        }
    }
}

struct EnviornmentView_Previews: PreviewProvider {
    static var previews: some View {
        EnviornmentView()
    }
}
