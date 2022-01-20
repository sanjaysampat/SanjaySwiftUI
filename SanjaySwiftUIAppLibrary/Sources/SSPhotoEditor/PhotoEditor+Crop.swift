//
//  PhotoEditor+Crop.swift
//  Pods
//
//  Created by Mohamed Hamed on 6/16/17.
//
//

import Foundation
import UIKit

// MARK: - SSCropView
extension SSPhotoEditorMainViewController: SSCropViewControllerDelegate {
    
    public func cropViewController(_ controller: SSCropViewController, didFinishCroppingImage image: UIImage, transform: CGAffineTransform, cropRect: CGRect) {
        controller.dismiss(animated: true, completion: nil)
        self.setImageView(image: image)
    }
    
    public func cropViewControllerDidCancel(_ controller: SSCropViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}
