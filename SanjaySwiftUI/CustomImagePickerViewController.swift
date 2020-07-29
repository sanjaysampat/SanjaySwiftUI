//
//  CustomPersonPhotoImagePickerViewController.swift
//  SanjaySwiftUI
//
//  Created by Sanjay Sampat on 28/07/20.
//  Copyright © 2020 Sanjay Sampat. All rights reserved.
//

import SwiftUI

struct CustomPersonPhotoImagePickerViewController: UIViewControllerRepresentable {

    @Binding var isPresentedStoryboardSanjay: Bool
    @Binding var photoChanged: Bool
    @Binding var photo: UIImage?

    // SSTODO to add photo selection for add/edit photo
    
    func makeUIViewController(context: Context) -> UIViewController {
        /*
        let storyboardSanjay = UIStoryboard(name: "StoryboardSanjay", bundle: Bundle.main)
        let loadSSPhotoEditorViewController = storyboardSanjay.instantiateViewController(identifier: "SSPhotoEditorViewController") as! SSPhotoEditorViewController
        loadSSPhotoEditorViewController.image = photo
        //loadSSPhotoEditorViewController.ssPhotoEditorDelegate = self
        
        //Colors for drawing and Text, If not set default values will be used
        //loadSSPhotoEditorViewController.colors = [.red, .blue, .green]
        
        //Stickers that the user will choose from to add on the image
        //for i in 0...10 {
        //    loadSSPhotoEditorViewController.stickers.append(UIImage(named: i.description )!)
        //}
        
        //To hide controls - array of enum control
        //loadSSPhotoEditorViewController.hiddenControls = [.crop, .draw, .share]
        
        return loadSSPhotoEditorViewController
        */
        let personPhotoImagePickerViewController = PersonPhotoImagePickerViewController()
        personPhotoImagePickerViewController.modalTransitionStyle = .crossDissolve
        personPhotoImagePickerViewController.modalPresentationStyle = .overFullScreen
        
        personPhotoImagePickerViewController.delegate = context.coordinator

        return personPhotoImagePickerViewController

    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }
    
    func makeCoordinator() -> CoordinatorPersonPhotoImagePickerViewController {
        CoordinatorPersonPhotoImagePickerViewController(self)
    }

    
    // Use a Coordinator to act as your PersonPhotoImagePickerViewController
    class CoordinatorPersonPhotoImagePickerViewController: PersonPhotoImagePickerViewControllerDelegate {
        
        private var parent: CustomPersonPhotoImagePickerViewController
        
        init(_ parent: CustomPersonPhotoImagePickerViewController) {
            self.parent = parent
        }
        
        func didSelect(profileImage: UIImage) {
            self.parent.isPresentedStoryboardSanjay = false
            self.parent.photo = profileImage
            self.parent.photoChanged = true
        }
        
        func didCancel() {
            self.parent.isPresentedStoryboardSanjay = false
            self.parent.photoChanged = false
        }
        
    }
    
    /*  // for Photo Editor
    func makeCoordinator() -> CoordinatorSSPhotoEditorViewController {
        CoordinatorSSPhotoEditorViewController(self)
    }
    
    // for Photo Editor
    // Use a Coordinator to act as your SSPhotoEditorViewController
    class CoordinatorSSPhotoEditorViewController: SSPhotoEditorDelegate {
        
        private var parent: CustomViewController
        
        init(_ parent: CustomViewController) {
            self.parent = parent
        }
        
        func doneEditing(image: UIImage) {
            // SSTODO
        }
        
        func canceledEditing() {
            // SSTODO
        }
        
        
        /*
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            
            if !results.isEmpty {
                parent.itemProviders = []
                parent.imageArray = []
            }
            //print(results)
            let identifiers: [String] = results.compactMap(\.assetIdentifier)
            parent.isPresentedPhPickerWithPhotoKit = false
            let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: identifiers, options: nil)
            
            let phAssets = fetchResult.objects(at: IndexSet(0 ..< fetchResult.count))
            
            for asset in phAssets {
                
                let opts = PHImageRequestOptions()
                opts.deliveryMode = .highQualityFormat
                opts.isSynchronous = true
                opts.isNetworkAccessAllowed = true
                opts.resizeMode = .exact
                
                print("asset size: \(asset.pixelWidth) x \(asset.pixelHeight)")
                
                PHImageManager.default().requestImage(for: asset,
                                                      targetSize: PHImageManagerMaximumSize,
                                                      contentMode: .default,
                                                      options: opts,
                                                      resultHandler: { (image, info) in
                                                        
                                                        // SSTODO - to find how can we get if we are getting low resolution image in case of no image authorization. ( info key PHImageResultIsDegradedKey is giving same for authorized and no-access images )
                                                        
                                                        if let image = image {
                                                            //print("mage info \(String(describing: info))")
                                                            self.parent.imageArray.append(ItemImage(image: image))
                                                        } else {
                                                            print("Could not load image \(String(describing: info))")
                                                        }
                                                        
                })
            }
            
            picker.dismiss(animated: true)
        }
        */
    }
    */
    
}

struct CustomPersonPhotoImagePickerViewController_Previews: PreviewProvider {
    static var previews: some View {
        // pass constant value to @Binding vars or @State vars in PreviewProvider
        CustomPersonPhotoImagePickerViewController(isPresentedStoryboardSanjay: .constant(true), photoChanged: .constant(false), photo: .constant(UIImage(systemName: "image")))
    }
}

