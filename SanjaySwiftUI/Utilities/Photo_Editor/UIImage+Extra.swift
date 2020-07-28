//
//  UIImage+Extra.swift
//  Prasadik
//
//  Created by kiran hande on 18/03/16.
//  Copyright © 2016 DgFlick Solutions Pvt. Ltd. All rights reserved.
//

import UIKit

extension UIImage {
    
    // to convert a UIview to a image
    // eg. let image = UIImage(view: myView)
    convenience init(view: UIView) {
        /*
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: (image?.cgImage)!)
        */
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let snapshotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: (snapshotImage?.cgImage)!)
        
    }
    
    var jpeg: Data? {
        return self.jpegData(compressionQuality: 1)   // QUALITY min = 0 / max = 1
    }
    var png: Data? {
        return self.pngData()
    }
    
    // Returns true if the image has an alpha layer
    func hasAlpha() -> Bool {
        let alpha = cgImage?.alphaInfo
        let retVal = (alpha == .first || alpha == .last || alpha == .premultipliedFirst || alpha == .premultipliedLast)
        return retVal
    }
    
    func normalizedImage() -> UIImage {
        if (self.imageOrientation == .up) {
            return self
        }
        UIGraphicsBeginImageContextWithOptions(self.size, !self.hasAlpha(), self.scale)
        var rect = CGRect.zero
        rect.size = self.size
        self.draw(in: rect)
        let retVal = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return retVal!
    }
    
    //From here Resize image code
    func RBSquareImageTo(size: CGSize) -> UIImage? {
        return self.RBSquareImage(theCenterTop: false)?.RBResizeImage(targetSize: size)
    }
    //Pradeep create this method date 04/04/2016
    func PYImageTo(size: CGSize) -> UIImage? {
        return self.RBResizeImage(targetSize: size)
    }
    
    
    //Pradeep create this method date 01/Jan/2016
    func PYSquareImageToCenterTop(size: CGSize) -> UIImage? {
        return self.RBSquareImage(theCenterTop: true)?.RBResizeImage(targetSize: size)
    }
    
    func PYCropImageWithRatio(theCropRatioWidth:Float, theCropRatioHeight:Float, theHeightFromTop:Bool) -> UIImage? {
        
        var isOK = false
        let calculatedRatioWidth:CGFloat = CGFloat(theCropRatioWidth)
        let calculatedRatioHeight:CGFloat = CGFloat(theCropRatioHeight)
        var possibleHeight = self.size.height
        var possibleWidth = self.size.width
        var cropX = CGFloat(0)
        var cropY = CGFloat(0)
        if (self.size.width / calculatedRatioWidth >  self.size.height / calculatedRatioHeight)
        {
            let calculatedWidth  = calculatedRatioWidth * self.size.height / calculatedRatioHeight;
            
            let diff = abs(possibleWidth - calculatedWidth)
            if ( diff < 5)
            {
                isOK = true
            }
            else {
                // If we want to keep 'Centered' width crop then do cropX = ( diff / 2 );. Else use cropX = 0;
                cropX = ( diff / 2);
                possibleWidth = calculatedWidth;
            }
            
        }
        else
        {
            let calculatedHeight  = calculatedRatioHeight * self.size.width / calculatedRatioWidth
            let diff = abs(possibleHeight - calculatedHeight)
            if ( diff < 5 )
            {
                isOK = true
            }
            else
            {
                // if we want to keep 'Top' height crop then do cropY = 0;. Else use cropY = ( diff / 2 );
                if ( theHeightFromTop )
                {
                    cropY = 0
                }
                else
                {
                    cropY = ( diff / 2 )
                }
                possibleHeight = calculatedHeight
            }
        }
        if ( isOK == false)
        {
            let cropRect = CGRect(x:cropX, y:cropY, width:possibleWidth, height:possibleHeight)
            
            return PYCropImage(therect: cropRect)
            
            //let imageRef = CGImageCreateWithImageInRect(self.CGImage, cropRect);
            //return UIImage(CGImage: imageRef!, scale: UIScreen.mainScreen().scale, orientation: self.imageOrientation)
        }
        else{
            return self
        }
        
        
        //-----------------------------------------------------------------------------
    }
    
    
    
    func PYCheckRatioOfImage(theCropRatioWidth:Float, theCropRatioHeight:Float) -> Bool {
        
        var isOK = false
        let calculatedRatioWidth:CGFloat = CGFloat(theCropRatioWidth)
        let calculatedRatioHeight:CGFloat = CGFloat(theCropRatioHeight)
        let possibleHeight = self.size.height
        let possibleWidth = self.size.width
        if (self.size.width / calculatedRatioWidth >  self.size.height / calculatedRatioHeight)
        {
            let calculatedWidth  = calculatedRatioWidth * self.size.height / calculatedRatioHeight;
            
            let diff = abs(possibleWidth - calculatedWidth)
            if ( diff < 5)
            {
                isOK = true
            }
            
            
        }
        else
        {
            let calculatedHeight  = calculatedRatioHeight * self.size.width / calculatedRatioWidth
            let diff = abs(possibleHeight - calculatedHeight)
            if ( diff < 5 )
            {
                isOK = true
            }
            
        }
        
        
        return isOK
        //-----------------------------------------------------------------------------
    }
    
    
    
    func PYCropImage(therect:CGRect) ->UIImage? {
        
        var rectTransform = CGAffineTransform()
        switch (self.imageOrientation) {
        case UIImage.Orientation.left:
            rectTransform = CGAffineTransform(rotationAngle: CGFloat.pi/2).translatedBy(x: 0, y: -self.size.height)
            break
        case UIImage.Orientation.right:
            rectTransform = CGAffineTransform(rotationAngle: -CGFloat.pi/2).translatedBy(x: -self.size.width, y: 0)
            break
        case UIImage.Orientation.down:
            rectTransform = CGAffineTransform(rotationAngle: -CGFloat.pi).translatedBy(x: -self.size.width, y: -self.size.height)
            break
            
        default:
            rectTransform = CGAffineTransform.identity
        }
        rectTransform = rectTransform.scaledBy(x: self.scale, y: self.scale)
        let imageRef = self.cgImage!.cropping(to: therect.applying(rectTransform))
        return UIImage(cgImage: imageRef!, scale: self.scale, orientation: self.imageOrientation)
    }
    
    
    
    func RBSquareImage(theCenterTop:Bool) -> UIImage? {
        let originalWidth  = self.size.width
        let originalHeight = self.size.height
        var posY:CGFloat = 0
        
        var edge: CGFloat
        if originalWidth > originalHeight {
            edge = originalHeight
        } else {
            edge = originalWidth
        }
        
        let posX = (originalWidth  - edge) / 2.0
        if theCenterTop == false {
            posY = (originalHeight - edge) / 2.0
        }
        
        let cropSquare = CGRect(x:posX, y:posY, width:edge, height:edge)
        
        return PYCropImage(therect: cropSquare)
        
        //let imageRef = CGImageCreateWithImageInRect(self.CGImage, cropSquare);
        //return UIImage(CGImage: imageRef!, scale: UIScreen.mainScreen().scale, orientation: self.imageOrientation)
    }
    
    func RBResizeImage(targetSize: CGSize) -> UIImage? {
        let size = self.size
        
        let widthRatio  = targetSize.width  / self.size.width
        let heightRatio = targetSize.height / self.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width:size.width * heightRatio, height:size.height * heightRatio)
        } else {
            newSize = CGSize(width:size.width * widthRatio,  height:size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x:0, y:0, width:newSize.width, height:newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, UIScreen.main.scale)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    //End here for resize image
    
}
