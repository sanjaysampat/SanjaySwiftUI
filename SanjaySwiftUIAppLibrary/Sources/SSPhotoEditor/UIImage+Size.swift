//
//  UIImage+Size.swift
//  Photo Editor
//
//  Created by Mohamed Hamed on 5/2/17.
//  Copyright © 2017 Mohamed Hamed. All rights reserved.
//

import UIKit

public extension UIImage {
    
    /**
     Suitable size for specific height or width to keep same image ratio
     */
    func suitableSize(heightLimit: CGFloat? = nil,
                             widthLimit: CGFloat? = nil )-> CGSize? {
        var widthRatio:CGFloat = 0.0
        var heightRatio:CGFloat = 0.0
        var height:CGFloat = 0
        var width:CGFloat = 0
        if let heightFixed = heightLimit {
            if heightFixed > 0 {
                height = heightFixed
                heightRatio = height / self.size.height
            }
        }
        if let widthFixed = widthLimit {
            if widthFixed > 0 {
                width = widthFixed
                widthRatio = width / self.size.width
            }
        }
        if height > 0 && width > 0 {
            if widthRatio < heightRatio {
                height = widthRatio * self.size.height
            } else {
                width = heightRatio * self.size.width
            }
        } else if height > 0 {
            width = heightRatio * self.size.width
        } else if width > 0 {
            height = widthRatio * self.size.height
        } else {
            return nil
        }
        return CGSize(width: width, height: height)
    }
}
