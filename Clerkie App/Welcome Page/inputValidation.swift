//
//  inputValidation.swift
//  Clerkie App
//
//  Created by Ram Sri Charan on 8/31/18.
//  Copyright © 2018 Ram Sri Charan. All rights reserved.
//

import Foundation
import UIKit

class inputValidation{
    
    // Check for user input errors
    func checkUserInput(username : String, password : String, viewController : UIViewController) -> Bool
    {        
        // Empty data error handling
        if(username.isEmpty || password.isEmpty)
        {
            viewController.showAlertWith(AlertTitle: "Empty Input field", AlertMessage: "Username and password cannot be empty.")
            return false
        }
        
        // check for valid phone number
        let phone = Int(username)
        if(phone != nil && username.count != 10)
        {
            viewController.showAlertWith(AlertTitle: "Invalid Phone", AlertMessage: "The phone number is invalid. Please verify")
            return false
        }
        else if(!validateEmail(enteredEmail: username))
        {
            viewController.showAlertWith(AlertTitle: "Invalid Email", AlertMessage: "The Email is invalid. Make sure it is a valid @clerkie.com email address")
            return false
        }
        
        
        return true
    }
    
    
    
    
    // Check and return if the given email is valid or not
    func validateEmail(enteredEmail:String) -> Bool
    {
        let emailFormat = "[A-Z0-9a-z._%+-]+@clerkie.com"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)
    }
    
    
}
