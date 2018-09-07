//
//  myExtensions.swift
//  Clerkie App
//
//  Created by Ram Sri Charan on 8/31/18.
//  Copyright © 2018 Ram Sri Charan. All rights reserved.
//

import Foundation
import UIKit


// View Controller Extensions
extension UIViewController
{
    // Alert message display function
    func showAlertWith(AlertTitle : String, AlertMessage : String)
    {
        let alert = UIAlertController(title: AlertTitle, message: AlertMessage, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // Close keyboard when screen is touched
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}




// My Custom Colors
extension UIColor
{
    static let myPink = UIColor(red: 209/255, green: 0/255, blue: 80/255, alpha: 1.0)
    static let myBlueColor : UIColor = UIColor(red: 66/255, green: 103/255, blue: 178/255, alpha: 1.0)
    static let myGreen : UIColor = UIColor(red: 0/255, green: 175/255, blue: 136/255, alpha: 1.0)
}









