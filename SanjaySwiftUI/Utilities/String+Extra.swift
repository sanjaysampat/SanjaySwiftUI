//
//  String+Extra.swift
//  Brand Xpress
//
//  Created by kiran hande on 16/10/15.
//  Copyright © 2015 DgFlick Solutions Pvt. Ltd. All rights reserved.
//

import Foundation

extension String {
    var ns: NSString {
        return self as NSString
    }
    var pathExtension: String {
        return ns.pathExtension 
    }
    var lastPathComponent: String {
        if ns.lastPathComponent.isEmpty {
            return self
        }
        return ns.lastPathComponent
    }
    var stringByDeletingPathExtension: String {
        if ns.deletingPathExtension.isEmpty {
            return self
        }
        return ns.deletingPathExtension 
    }
    var stringByDeletingLastPathComponent: String {
        if ns.deletingLastPathComponent.isEmpty {
            return self
        }
        return ns.deletingLastPathComponent 
    }
    
    func stringByAppendingPathComponent(path: String) -> String {
        
        return ns.appendingPathComponent(path)
    }
    
    func indexOf(target: String) -> Int? {
        if let range = self.range(of: target) {
            return distance(from: startIndex, to: range.lowerBound)
        } else {
            return nil
        }
    }
    
    func lastIndexOf(s: String) -> Int? {
        if let r: Range<Index> = self.range(of: s, options: .backwards) {
            return distance(from: startIndex, to: r.lowerBound)
        }
        
        return Optional.none
    }
    
    //"".isAlphanumeric()         == false
    //"Hello".isAlphanumeric()    == true
    //"Hello 2".isAlphanumeric()  == false
    //"Hello3".isAlphanumeric()   == true
    func isAlphanumeric() -> Bool {
        return self.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) == nil && self != ""
    }
    
    //"Français".isAlphanumeric() == true
    //"Français".isAlphanumeric(ignoreDiacritics: true) == false
    
    //This works with languages other than English, allowing diacritic characters like è and á, etc. If you'd like to ignore these, use the flag "ignoreDiacritics: true".
    func isAlphanumeric(ignoreDiacritics: Bool = false) -> Bool {
        if ignoreDiacritics {
            return self.range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil && self != ""
        }
        else {
            return self.isAlphanumeric()
        }
    }
    
    func isNumber() -> Bool {
        return self.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil && self != ""
    }
    
    func stringByDeletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
    
    // find array of words from String.
    func words() -> [String] {
        var words = [String]()
        self.enumerateSubstrings(in: self.startIndex..<self.endIndex , options: .byWords) {w,_,_,_ in
            guard let word = w else {return}
            words.append(word)
        }
        return words
    }
    
}
