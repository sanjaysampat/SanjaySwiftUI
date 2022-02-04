//
//  SSCropViewController.swift
//  SSCropViewController
//
//  Created by Guilherme Moura on 2/25/16.
//  Copyright © 2016 Reefactor, Inc. All rights reserved.
// Credit https://github.com/sprint84/PhotoCropEditor

import UIKit

@objc public protocol SSCropViewControllerDelegate: class {
    func cropViewController(_ controller: SSCropViewController, didFinishCroppingImage image: UIImage, transform: CGAffineTransform, cropRect: CGRect)
    func cropViewControllerDidCancel(_ controller: SSCropViewController)
}

@objcMembers open class SSCropViewController: UIViewController {
    open weak var delegate: SSCropViewControllerDelegate?
    open var image: UIImage? {
        didSet {
            sscropView?.image = image
        }
    }
    open var keepAspectRatio = false {
        didSet {
            sscropView?.keepAspectRatio = keepAspectRatio
        }
    }
    open var cropAspectRatio: CGFloat = 0.0 {
        didSet {
            sscropView?.cropAspectRatio = cropAspectRatio
        }
    }
    open var cropRect = CGRect.zero {
        didSet {
            adjustCropRect()
        }
    }
    open var imageCropRect = CGRect.zero {
        didSet {
            sscropView?.imageCropRect = imageCropRect
        }
    }
    open var toolbarHidden = false
    open var rotationEnabled = false {
        didSet {
            sscropView?.rotationGestureRecognizer.isEnabled = rotationEnabled
        }
    }
    open var rotationTransform: CGAffineTransform {
        return sscropView!.rotation
    }
    open var zoomedCropRect: CGRect {
        return sscropView!.zoomedCropRect()
    }

    fileprivate var sscropView: SSCropView?
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        initialize()
    }
    
    fileprivate func initialize() {
        rotationEnabled = true
    }
    
    open override func loadView() {
        let contentView = UIView()
        contentView.autoresizingMask = .flexibleWidth
        contentView.backgroundColor = UIColor.black
        view = contentView
        
        // Add sscropView
        sscropView = SSCropView(frame: contentView.bounds)
        contentView.addSubview(sscropView!)
        
    }

    open override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.isTranslucent = false
        navigationController?.toolbar.isTranslucent = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(SSCropViewController.cancel(_:)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(SSCropViewController.done(_:)))
        
        if self.toolbarItems == nil {
            let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let constrainButton = UIBarButtonItem(title: NSLocalizedString("string_constrain", bundle: Bundle.module, comment: "Constrain"), style: .plain, target: self, action: #selector(SSCropViewController.constrain(_:)))
            toolbarItems = [flexibleSpace, constrainButton, flexibleSpace]
        }
        
        navigationController?.isToolbarHidden = toolbarHidden
        
        sscropView?.image = image
        sscropView?.rotationGestureRecognizer.isEnabled = rotationEnabled
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if cropAspectRatio != 0 {
            sscropView?.cropAspectRatio = cropAspectRatio
        }
        
        if !cropRect.equalTo(CGRect.zero) {
            adjustCropRect()
        }
        
        if !imageCropRect.equalTo(CGRect.zero) {
            sscropView?.imageCropRect = imageCropRect
        }
        
        sscropView?.keepAspectRatio = keepAspectRatio
    }
    
    open func resetCropRect() {
        sscropView?.resetCropRect()
    }
    
    open func resetCropRectAnimated(_ animated: Bool) {
        sscropView?.resetCropRectAnimated(animated)
    }
    
    @objc func cancel(_ sender: UIBarButtonItem) {
        delegate?.cropViewControllerDidCancel(self)
    }
    
    @objc func done(_ sender: UIBarButtonItem) {
        if let image = sscropView?.croppedImage {
            guard let rotation = sscropView?.rotation else {
                return
            }
            guard let rect = sscropView?.zoomedCropRect() else {
                return
            }
            delegate?.cropViewController(self, didFinishCroppingImage: image, transform: rotation, cropRect: rect)
        }
    }
    
    @objc func constrain(_ sender: UIBarButtonItem) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let original = UIAlertAction(title: NSLocalizedString("string_original", bundle: Bundle.module, comment: "Original"), style: .default) { [unowned self] action in
            guard let image = self.sscropView?.image else {
                return
            }
            guard var cropRect = self.sscropView?.cropRect else {
                return
            }
            let width = image.size.width
            let height = image.size.height
            let ratio: CGFloat
            if width < height {
                ratio = width / height
                cropRect.size = CGSize(width: cropRect.height * ratio, height: cropRect.height)
            } else {
                ratio = height / width
                cropRect.size = CGSize(width: cropRect.width, height: cropRect.width * ratio)
            }
            self.sscropView?.cropRect = cropRect
        }
        actionSheet.addAction(original)
        let square = UIAlertAction(title: NSLocalizedString("string_square", bundle: Bundle.module, comment: "Square"), style: .default) { [unowned self] action in
            let ratio: CGFloat = 1.0
//            self.cropView?.cropAspectRatio = ratio
            if var cropRect = self.sscropView?.cropRect {
                let width = cropRect.width
                cropRect.size = CGSize(width: width, height: width * ratio)
                self.sscropView?.cropRect = cropRect
            }
        }
        actionSheet.addAction(square)
        let threeByTwo = UIAlertAction(title: "3 x 2", style: .default) { [unowned self] action in
            self.sscropView?.cropAspectRatio = 2.0 / 3.0
        }
        actionSheet.addAction(threeByTwo)
        let threeByFive = UIAlertAction(title: "3 x 5", style: .default) { [unowned self] action in
            self.sscropView?.cropAspectRatio = 3.0 / 5.0
        }
        actionSheet.addAction(threeByFive)
        let fourByThree = UIAlertAction(title: "4 x 3", style: .default) { [unowned self] action in
            let ratio: CGFloat = 3.0 / 4.0
            if var cropRect = self.sscropView?.cropRect {
                let width = cropRect.width
                cropRect.size = CGSize(width: width, height: width * ratio)
                self.sscropView?.cropRect = cropRect
            }
        }
        actionSheet.addAction(fourByThree)
        let fourBySix = UIAlertAction(title: "4 x 6", style: .default) { [unowned self] action in
            self.sscropView?.cropAspectRatio = 4.0 / 6.0
        }
        actionSheet.addAction(fourBySix)
        let fiveBySeven = UIAlertAction(title: "5 x 7", style: .default) { [unowned self] action in
            self.sscropView?.cropAspectRatio = 5.0 / 7.0
        }
        actionSheet.addAction(fiveBySeven)
        let eightByTen = UIAlertAction(title: "8 x 10", style: .default) { [unowned self] action in
            self.sscropView?.cropAspectRatio = 8.0 / 10.0
        }
        actionSheet.addAction(eightByTen)
        let widescreen = UIAlertAction(title: "16 x 9", style: .default) { [unowned self] action in
            let ratio: CGFloat = 9.0 / 16.0
            if var cropRect = self.sscropView?.cropRect {
                let width = cropRect.width
                cropRect.size = CGSize(width: width, height: width * ratio)
                self.sscropView?.cropRect = cropRect
            }
        }
        actionSheet.addAction(widescreen)
        let cancel = UIAlertAction(title: NSLocalizedString("string_cancel", bundle: Bundle.module, comment: "Cancel"), style: .default) { [unowned self] action in
            self.dismiss(animated: true, completion: nil)
        }
        actionSheet.addAction(cancel)
        
        if let popoverController = actionSheet.popoverPresentationController {
            popoverController.barButtonItem = sender
        }
        
        present(actionSheet, animated: true, completion: nil)
    }

    // MARK: - Private methods
    fileprivate func adjustCropRect() {
        imageCropRect = CGRect.zero
        
        guard var cropViewCropRect = sscropView?.cropRect else {
            return
        }
        cropViewCropRect.origin.x += cropRect.origin.x
        cropViewCropRect.origin.y += cropRect.origin.y
        
        let minWidth = min(cropViewCropRect.maxX - cropViewCropRect.minX, cropRect.width)
        let minHeight = min(cropViewCropRect.maxY - cropViewCropRect.minY, cropRect.height)
        let size = CGSize(width: minWidth, height: minHeight)
        cropViewCropRect.size = size
        sscropView?.cropRect = cropViewCropRect
    }
    
    

}
