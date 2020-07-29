//
//  PersonPhotoImagePickerViewControllerDelegate.swift
//  SanjaySwiftUI
//
//  Created by Sanjay on 29/07/20.
//  Copyright © 2020 Sanjay. All rights reserved.
//

import UIKit

let appColor = UIColor(displayP3Red: 0.888, green: 0.636, blue: 0.133, alpha: 1)

protocol PersonPhotoImagePickerViewControllerDelegate: AnyObject {
    func didSelect(profileImage: UIImage)
    func didCancel()
}

class PersonPhotoImagePickerViewController: UIViewController {
    
    weak var delegate: PersonPhotoImagePickerViewControllerDelegate?
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let cameraStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let galeryStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let stackViewVertical: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .equalCentering
        stackView.spacing = 25
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let stackViewHorizontal: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let galleryImageButton: UIButton = {
        let button = UIButton()
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 50, weight: .light, scale: .medium)
        let image = UIImage(systemName: "photo.fill.on.rectangle.fill", withConfiguration: symbolConfig)
        button.setImage(image, for: .normal)
        button.imageView?.tintColor = appColor
        button.addTarget(self, action: #selector(galeryButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let galleryLabel: UILabel = {
        let label = UILabel()
        label.text = "Galery"
        label.textColor = .systemGray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let cameraImageButton: UIButton = {
        let button = UIButton()
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 50, weight: .light, scale: .medium)
        let image = UIImage(systemName: "camera.circle.fill", withConfiguration: symbolConfig)
        button.setImage(image, for: .normal)
        button.imageView?.tintColor = appColor
        button.addTarget(self, action: #selector(cameraButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let cameraLabel: UILabel = {
        let label = UILabel()
        label.text = "Camera"
        label.textColor = .systemGray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let cancelButtonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .equalCentering
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.tintColor = .white
        button.backgroundColor = appColor
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.746368838)
        
        view.addSubview(containerView)
        containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                               constant: 25).isActive = true
        containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                constant: -25).isActive = true
        
        galeryStackView.addArrangedSubview(galleryImageButton)
        galeryStackView.addArrangedSubview(galleryLabel)
        
        cameraStackView.addArrangedSubview(cameraImageButton)
        cameraStackView.addArrangedSubview(cameraLabel)
        
        stackViewHorizontal.addArrangedSubview(UIView())
        stackViewHorizontal.addArrangedSubview(galeryStackView)
        stackViewHorizontal.addArrangedSubview(UIView())
        stackViewHorizontal.addArrangedSubview(cameraStackView)
        stackViewHorizontal.addArrangedSubview(UIView())
        
        cancelButtonStackView.addArrangedSubview(UIView())
        cancelButtonStackView.addArrangedSubview(cancelButton)
        cancelButtonStackView.addArrangedSubview(UIView())
        
        stackViewVertical.addArrangedSubview(stackViewHorizontal)
        stackViewVertical.addArrangedSubview(cancelButtonStackView)

        containerView.addSubview(stackViewVertical)
        stackViewVertical.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        stackViewVertical.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        stackViewVertical.leadingAnchor.constraint(equalTo: containerView.leadingAnchor,
                                                   constant: 25).isActive = true
        stackViewVertical.trailingAnchor.constraint(equalTo: containerView.trailingAnchor,
                                                    constant: -25).isActive = true
        
        cancelButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    @objc
    func galeryButtonPressed() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
    }
    
    @objc
    func cancelButtonPressed() {
        self.dismiss(animated: true, completion: {
            self.delegate?.didCancel()
        })
    }
    
    @objc
    func cameraButtonPressed() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
    }
    
}

extension PersonPhotoImagePickerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }
        picker.dismiss(animated: true, completion: {
            self.dismiss(animated: true, completion: {
                self.delegate?.didSelect(profileImage: image)
            })
        })
    }
    
}

