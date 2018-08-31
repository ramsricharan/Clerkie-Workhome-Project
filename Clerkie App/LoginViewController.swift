//
//  ViewController.swift
//  Clerkie App
//
//  Created by Ram Sri Charan on 8/30/18.
//  Copyright © 2018 Ram Sri Charan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let myCredentials = Credentials()
        
        print(myCredentials.getCredentials())
        
        view.backgroundColor = UIColor.red
        
        
        setupView()
        
    }
    
    ///////////////// Action Handlers ///////////////////
    @objc func onLoginPressed()
    {
        if(checkUserInput())
        {
            
        }
    }
    
    
    ///////////////// Helper methods ///////////////////

    // Alert message display function
    func showAlertWith(AlertTitle : String, AlertMessage : String)
    {
        let alert = UIAlertController(title: AlertTitle, message: AlertMessage, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // Check for user input errors
    func checkUserInput() -> Bool
    {
        let username : String! = usernameTextField.text ?? ""
        let password : String!  = passwordTextField.text ?? ""
        
        // Empty data error handling
        if(username.isEmpty || password.isEmpty)
        {
            showAlertWith(AlertTitle: "Empty Input field", AlertMessage: "Username and password cannot be empty.")
            return false
        }
        
        // check for valid phone number
        let phone = Int(username)
        if(phone != nil && username.count != 10)
        {
            showAlertWith(AlertTitle: "Invalid Phone", AlertMessage: "The phone number is invalid. Please verify")
            return false
        }
        else if(!validateEmail(enteredEmail: username))
        {
            showAlertWith(AlertTitle: "Invalid Email", AlertMessage: "The Email is invalid")
            return false
        }
        
        
        return true
    }
    
    
    func validateEmail(enteredEmail:String) -> Bool
    {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)
    }
    
    ///////////////// View components and Arrangement ///////////////////
    
    
    // App title view
    var appTitleLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Clerkie Project"
        label.font = UIFont.boldSystemFont(ofSize: 40)
        label.textColor = .white
        return label
    }()
    
    
    // Username textField container
    var usernameContainer : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    // Text field for Username
    var usernameTextField : UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Username"
        textField.textAlignment = .center
        return textField
    }()
    
    
    // Username textField container
    var passwordContainer : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    // Text Field for Password
    var passwordTextField : UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Password"
        textField.textAlignment = .center
        textField.textContentType = UITextContentType.password
        return textField
    }()
    
    
    
    // Login button
    var loginButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Login", for: .normal)
        
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        button.layer.borderWidth = 3
        button.layer.borderColor = UIColor.white.cgColor
        
        button.addTarget(self, action: #selector(onLoginPressed), for: .touchUpInside)
        return button
    }()
    
    
    // This function is responsible for view component arrangement
    func setupView()
    {
        // Password Field
        setupPasswordTextField()
        
        // Adding textFields
        setupUsernameTextField()
        
        // Adding all other views to the base container
        view.addSubview(appTitleLabel)
        appTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        appTitleLabel.bottomAnchor.constraint(equalTo: usernameContainer.topAnchor, constant: -24).isActive = true
        
        // Add login button
        view.addSubview(loginButton)
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        loginButton.topAnchor.constraint(equalTo: passwordContainer.bottomAnchor, constant: 24).isActive = true
        
    }
    

    func setupUsernameTextField()
    {
        // Adding container to the BaseView
        view.addSubview(usernameContainer)
        usernameContainer.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1).isActive = true
        usernameContainer.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        usernameContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        usernameContainer.bottomAnchor.constraint(equalTo: passwordContainer.topAnchor, constant: -16).isActive = true

        
        // Add textField to the container
        usernameContainer.addSubview(usernameTextField)
        usernameTextField.heightAnchor.constraint(equalTo: usernameContainer.heightAnchor, multiplier: 0.9).isActive = true
        usernameTextField.widthAnchor.constraint(equalTo: usernameContainer.widthAnchor, multiplier: 0.9).isActive = true
        usernameTextField.centerXAnchor.constraint(equalTo: usernameContainer.centerXAnchor).isActive = true
        usernameTextField.centerYAnchor.constraint(equalTo: usernameContainer.centerYAnchor).isActive = true
        
    }
   
    func setupPasswordTextField()
    {
        // Adding container to the BaseView
        view.addSubview(passwordContainer)
        passwordContainer.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1).isActive = true
        passwordContainer.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        passwordContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        passwordContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        
        // Add textField to the container
        passwordContainer.addSubview(passwordTextField)
        passwordTextField.heightAnchor.constraint(equalTo: passwordContainer.heightAnchor, multiplier: 0.9).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: passwordContainer.widthAnchor, multiplier: 0.9).isActive = true
        passwordTextField.centerXAnchor.constraint(equalTo: passwordContainer.centerXAnchor).isActive = true
        passwordTextField.centerYAnchor.constraint(equalTo: passwordContainer.centerYAnchor).isActive = true
        
    }
    
    

}

