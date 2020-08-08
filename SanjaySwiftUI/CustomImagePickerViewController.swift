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
    
    func makeUIViewController(context: Context) -> UIViewController {
        let personPhotoImagePickerViewController = PersonPhotoImagePickerViewController()
        personPhotoImagePickerViewController.modalTransitionStyle = .crossDissolve
        personPhotoImagePickerViewController.modalPresentationStyle = .overFullScreen
        personPhotoImagePickerViewController.imageForEditing = photo
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
    
}

struct CustomPersonPhotoImagePickerViewController_Previews: PreviewProvider {
    static var previews: some View {
        // pass constant value to @Binding vars or @State vars in PreviewProvider
        CustomPersonPhotoImagePickerViewController(isPresentedStoryboardSanjay: .constant(true), photoChanged: .constant(false), photo: .constant(UIImage(systemName: "image")))
    }
}

