//
//  SSPhotoEditorMainViewController.swift
//  SanjaySwiftUIAppLibrary
//
//  Created by Sanjay Sampat on 19/01/22.
//  Copyright © 2022 Sanjay Sampat. All rights reserved.
//
//  Based on
//  ViewController.swift
//  Photo Editor
//  Created by Mohamed Hamed on 4/23/17.
//  Copyright © 2017 Mohamed Hamed. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Control
public enum ssPhotoEditorControl {
    case crop
    case sticker
    case draw
    case text
    case save
    case share
    case clear
}

public class SSPhotoEditorCommon {
    
    //public class func packageBundle() -> Bundle {
    //    return Bundle.module
    //}

    public class func loadSSPhotoEditorMainViewController() -> SSPhotoEditorMainViewController {
        
        let storyboardSSPhotoEditor = UIStoryboard(name: "StoryboardSSPhotoEditor", bundle: Bundle.module)
        return storyboardSSPhotoEditor.instantiateViewController(identifier: "SSPhotoEditorMainViewController") as! SSPhotoEditorMainViewController
        
    }

}

@objcMembers public class SSPhotoEditorMainViewController: UIViewController {
    
    let canvasHeightSafeArea:CGFloat = 100
    
    /** holding the 2 imageViews original image and drawing & stickers */
    @IBOutlet weak var canvasView: UIView!
    @IBOutlet var myCanvasWidthConstraint: NSLayoutConstraint!
    @IBOutlet var myCanvasHeightConstraint: NSLayoutConstraint!
    //To hold the image
    @IBOutlet var imageView: UIImageView!
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    //To hold the drawings and stickers
    @IBOutlet weak var canvasImageView: UIImageView!
    
    @IBOutlet weak var topToolbar: UIView!
    @IBOutlet weak var bottomToolbar: UIView!
    
    @IBOutlet weak var topGradient: UIView!
    @IBOutlet weak var bottomGradient: UIView!
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var deleteView: UIView!
    @IBOutlet weak var colorsCollectionView: UICollectionView!
    @IBOutlet weak var colorPickerView: UIView!
    @IBOutlet weak var colorPickerViewBottomConstraint: NSLayoutConstraint!
    
    //Controls
    @IBOutlet weak var cropButton: UIButton!
    @IBOutlet weak var stickerButton: UIButton!
    @IBOutlet weak var drawButton: UIButton!
    @IBOutlet weak var textButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!

    public var image: UIImage?
    /**
     Array of Stickers -UIImage- that the user will choose from
     */
    public var stickers : [UIImage] = []
    /**
     Array of Colors that will show while drawing or typing
     */
    public var colors  : [UIColor] = []
    
    public var ssPhotoEditorMainDelegate: SSPhotoEditorMainDelegate?
    var ssColorsCollectionViewDelegate: SSColorsCollectionViewDelegate!
    
    // list of controls to be hidden
    public var hiddenControls : [ssPhotoEditorControl] = []
    
    var stickersVCIsVisible = false
    var drawColor: UIColor = UIColor.black
    var textColor: UIColor = UIColor.white
    var isDrawing: Bool = false
    var lastPoint: CGPoint!
    var swiped = false
    var lastPanPoint: CGPoint?
    var lastTextViewTransform: CGAffineTransform?
    var lastTextViewTransCenter: CGPoint?
    var lastTextViewFont:UIFont?
    var activeTextView: UITextView?
    var imageViewToPan: UIImageView?
    var isTyping: Bool = false
    
    
    var ssstickersViewController: SSStickersViewController!

    //Register Custom font before we load XIB
    public override func loadView() {
        registerFont()
        super.loadView()
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.doneButton.setTitle(NSLocalizedString("string_done", bundle: Bundle.module, comment: "Done"), for: UIControl.State.normal)
        
        if let alphaBackgroundImage = UIImage(named: "alpha_background") {
            self.view.backgroundColor = UIColor( patternImage: alphaBackgroundImage )
        }
        self.setImageView(image: image!)
        
        deleteView.layer.cornerRadius = deleteView.bounds.height / 2
        deleteView.layer.borderWidth = 2.0
        deleteView.layer.borderColor = UIColor.white.cgColor
        deleteView.clipsToBounds = true
        
        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(screenEdgeSwiped))
        edgePan.edges = .bottom
        edgePan.delegate = self
        self.view.addGestureRecognizer(edgePan)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow),
                                               name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(keyboardWillChangeFrame(_:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        
        configureCollectionView()
        ssstickersViewController = SSStickersViewController(nibName: "SSStickersViewController", bundle: Bundle.module)
            //bundle: Bundle(for: SSStickersViewController.self))
        hideControls()
        
        // SSTODO TEMP
        //// canvasImageView.backgroundColor = .red
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

        super.viewWillDisappear( animated )
    }
    
    func configureCollectionView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 30, height: 30)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        colorsCollectionView.collectionViewLayout = layout
        ssColorsCollectionViewDelegate = SSColorsCollectionViewDelegate()
        ssColorsCollectionViewDelegate.colorDelegate = self
        if !colors.isEmpty {
            ssColorsCollectionViewDelegate.colors = colors
        }
        colorsCollectionView.delegate = ssColorsCollectionViewDelegate
        colorsCollectionView.dataSource = ssColorsCollectionViewDelegate
        
        colorsCollectionView.register(
            UINib(nibName: "SSColorCollectionViewCell", bundle: .module),
                    //Bundle.module(for: SSColorCollectionViewCell.self)),
                    
                    //Bundle(for: ColorCollectionViewCell.self)),
            forCellWithReuseIdentifier: "SSColorCollectionViewCell")
    }
    
    func setImageView(image: UIImage) {
        imageView.image = image
        let size = image.suitableSize(heightLimit: UIScreen.main.bounds.height - canvasHeightSafeArea, widthLimit: UIScreen.main.bounds.width)
        if let height = size?.height, let width = size?.width {
            imageViewHeightConstraint.constant = height
            myCanvasWidthConstraint.constant = width
            myCanvasHeightConstraint.constant = height
        }
    }
    
    func hideToolbar(hide: Bool) {
        topToolbar.isHidden = hide
        topGradient.isHidden = hide
        bottomToolbar.isHidden = hide
        bottomGradient.isHidden = hide
    }
    
    // MARK: - Controls
    
    //MARK: Top Toolbar

    @IBAction func CancelButtonTapped(_ sender: UIButton) {
        ssPhotoEditorMainDelegate?.canceledEditing()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cropButtonTapped(_ sender: UIButton) {
        let controller = SSCropViewController()
        controller.delegate = self
        controller.image = image
        let navController = UINavigationController(rootViewController: controller)
        present(navController, animated: true, completion: nil)
    }
    
    @IBAction func stickersButtonTapped(_ sender: Any) {
        addStickersViewController()
    }
    
    @IBAction func drawButtonTapped(_ sender: Any) {
        isDrawing = true
        canvasImageView.isUserInteractionEnabled = false
        doneButton.isHidden = false
        colorPickerView.isHidden = false
        hideToolbar(hide: true)
    }
    
    @IBAction func textButtonTapped(_ sender: Any) {
        isTyping = true
        //let textView = UITextView(frame: CGRect(x: 0, y: canvasImageView.center.y, width: UIScreen.main.bounds.width, height: 30))
        let textView = UITextView(frame: CGRect(x: 0, y: canvasImageView.center.y,
                                                width: canvasImageView.bounds.width, height: 30))

        textView.textAlignment = .center
        textView.font = UIFont(name: "Helvetica", size: 30)
        textView.textColor = textColor
        textView.layer.shadowColor = UIColor.black.cgColor
        textView.layer.shadowOffset = CGSize(width: 1.0, height: 0.0)
        textView.layer.shadowOpacity = 0.2
        textView.layer.shadowRadius = 1.0
        textView.layer.backgroundColor = UIColor.clear.cgColor
        textView.autocorrectionType = .no
        textView.isScrollEnabled = false
        textView.delegate = self
        self.canvasImageView.addSubview(textView)
        addGestures(view: textView)
        textView.becomeFirstResponder()
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        view.endEditing(true)
        doneButton.isHidden = true
        colorPickerView.isHidden = true
        canvasImageView.isUserInteractionEnabled = true
        hideToolbar(hide: false)
        isDrawing = false
    }
    
    //MARK: Bottom Toolbar
    
    @IBAction func saveButtonTapped(_ sender: AnyObject) {
        let image = canvasView.toImage(isOpaque: false)
        if let data = image.png {
            if let pngImage = UIImage(data: data) {
                UIImageWriteToSavedPhotosAlbum( pngImage ,self, #selector(SSPhotoEditorMainViewController.image(_:withPotentialError:contextInfo:)), nil)
            }
        }
    }
    
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        let image = canvasView.toImage(isOpaque: false)
        if let data = image.png {
            if let pngImage = UIImage(data: data) {
                let vc = UIActivityViewController(activityItems: [pngImage], applicationActivities: nil)
                
                if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone)
                {
                    DispatchQueue.main.async {
                        self.present(vc, animated: true, completion: nil)
                    }
                }
                else
                {
                    vc.popoverPresentationController?.sourceRect = CGRect(x:self.view.frame.size.width/2, y:self.view.frame.size.height/4,width:0,height:0)
                    vc.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
                    DispatchQueue.main.async {
                        self.present(vc, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    @IBAction func clearButtonTapped(_ sender: AnyObject) {
        //clear drawing
        canvasImageView.image = nil
        //clear stickers and textviews
        for subview in canvasImageView.subviews {
            subview.removeFromSuperview()
        }
    }
    
    @IBAction func continueButtonPressed(_ sender: Any) {
        let image = canvasView.toImage(isOpaque: false)
        if let data = image.png {
            if let pngImage = UIImage(data: data) {
                ssPhotoEditorMainDelegate?.doneEditing(image: pngImage)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    //MAKR: helper methods
    
    @objc func image(_ image: UIImage, withPotentialError error: NSErrorPointer, contextInfo: UnsafeRawPointer) {
        let localizedTitle = NSLocalizedString("string_image_saved_title", bundle: Bundle.module, comment: "Image Saved")
        let localizedMessage = NSLocalizedString("string_image_saved_message", bundle: Bundle.module, comment: "Image successfully saved to Photos library")
        let alert = UIAlertController(title: localizedTitle, message: localizedMessage, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("string_ok", bundle: Bundle.module, comment: "OK"), style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        //SCLAlertView().showInfo("Image Saved", subTitle: "Image successfully saved to Photos library", closeButtonTitle: "OK", duration: 0.0, colorStyle: UInt(DgCommonUtils.DgStatic.cu_activity_toolbar_color), colorTextButton: UInt(DgCommonUtils.DgStatic.cu_activity_title_color))
    }
    
    func hideControls() {
        for control in hiddenControls {
            switch control {
                
            case .clear:
                clearButton.isHidden = true
            case .crop:
                cropButton.isHidden = true
            case .draw:
                drawButton.isHidden = true
            case .save:
                saveButton.isHidden = true
            case .share:
                shareButton.isHidden = true
            case .sticker:
                stickerButton.isHidden = true
            case .text:
                stickerButton.isHidden = true
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SSPhotoEditorMainViewController: ColorDelegate {
    func didSelectColor(color: UIColor) {
        if isDrawing {
            self.drawColor = color
        } else if activeTextView != nil {
            activeTextView?.textColor = color
            textColor = color
        }
    }
}
