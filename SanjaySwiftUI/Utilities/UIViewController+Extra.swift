//
//  UIViewController+Extra.swift
//  SanjaySwiftUI
//
//  Created by Sanjay Sampat on 03/11/20.
//  Copyright © 2020 Sanjay Sampat. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyBoard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyBoard() {
        view.endEditing(true)
    }
    
    /*
    @objc func navigationShouldPopOnBackButton() -> Bool {
        return true
    }
    */

}
