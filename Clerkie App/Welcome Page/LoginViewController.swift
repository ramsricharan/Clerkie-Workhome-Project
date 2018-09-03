//
//  ViewController.swift
//  Clerkie App
//
//  Created by Ram Sri Charan on 8/30/18.
//  Copyright © 2018 Ram Sri Charan. All rights reserved.
//

import UIKit
import FirebaseAuth


class LoginViewController: UIViewController {

    let checkInput = inputValidation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add background color
        view.backgroundColor = UIColor.darkGray
        
        // Add view components
        setupView()
        
        // Handle keyboard
        self.hideKeyboardWhenTappedAround()
    }
    
    ///////////////// Action Handlers ///////////////////
    @objc private func onLoginPressed()
    {
//        let username : String! = usernameTextField.text ?? ""
//        let password : String!  = passwordTextField.text ?? ""
        
        let username = "test@clerkie.com"
        let password = "12345678"
        
        
        if(checkInput.checkUserInput(username: username, password: password, viewController: self))
        {
            Auth.auth().signIn(withEmail: username, password: password) {
                (user, error) in
                if(error == nil && user != nil)
                {
                    // Successful login
                    print("login successful")
                    self.launchChatViewController()
                }
                else
                {
                    let error = error! as NSError
                    
                    switch(error.code)
                    {
                    case 17009:
                        self.showAlertWith(AlertTitle: "Wrong Password", AlertMessage: error.localizedDescription)
                        break
                        
                    case 17011:
                        self.showAlertWith(AlertTitle: "Invalid Email ID", AlertMessage: error.localizedDescription)
                        
                    default:
                        self.showAlertWith(AlertTitle: "Login Failed", AlertMessage: "Unable to Login to your account. Please try again later.")
                    }
                    
                }
            }
        }
    }
    
    
    // Sign Up Button Pressed
    @objc private func onSubmitPressed()
    {
        self.present(SignUpViewController(), animated: true, completion: nil)
    }
    
    
    
    
    
    
    ///////////////// Helper methods ///////////////////

    private func launchChatViewController()
    {
        let chatroomNavController = UINavigationController(rootViewController: ChatRoomViewController())
        self.present(chatroomNavController, animated: true, completion: nil)
    }
    
    ///////////////// View components and Arrangement ///////////////////
    
    
    // App title view
    var appTitleLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Clerkie Project"
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
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
    
    
    // Password textField container
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
    
    // Sign Up button
    var signUpButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(" SignUp ", for: .normal)
        
        
        button.layer.cornerRadius = 35
        button.layer.masksToBounds = true
        button.layer.borderWidth = 3
        button.layer.borderColor = UIColor.white.cgColor
        
        button.addTarget(self, action: #selector(onSubmitPressed), for: .touchUpInside)
        return button
    }()
    
    
    // This function is responsible for view component arrangement
    private func setupView()
    {
        // Password Field
        setupPasswordTextField()
        
        // Adding textFields
        setupUsernameTextField()
        
        // Adding all other views to the base container
        view.addSubview(appTitleLabel)
        appTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        appTitleLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        appTitleLabel.bottomAnchor.constraint(equalTo: usernameContainer.topAnchor, constant: -24).isActive = true
        
        // Add login button
        view.addSubview(loginButton)
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        loginButton.topAnchor.constraint(equalTo: passwordContainer.bottomAnchor, constant: 24).isActive = true
        
        // Add Sign Up Button
        view.addSubview(signUpButton)
        signUpButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        signUpButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        signUpButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        signUpButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
    }
    

    private func setupUsernameTextField()
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
   
    private func setupPasswordTextField()
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

