//
//  SignUpViewController.swift
//  Clerkie App
//
//  Created by Ram Sri Charan on 8/31/18.
//  Copyright © 2018 Ram Sri Charan. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {

    let checkInput = inputValidation()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.cyan
        setupViews()
    }
    
    ///////////////// Action Handlers ///////////////////
    @objc func onClosePressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func onRegisterPressed() {
        let username : String! = usernameTextField.text ?? ""
        let password : String!  = passwordTextField.text ?? ""
        let repassword : String! = rePasswordTextField.text ?? ""
        
        if(checkInput.checkUserInput(username: username, password: password, viewController: self))
        {
            if(password != repassword)
            {
                self.showAlertWith(AlertTitle: "Password Mismatch", AlertMessage: "To confirm your password, please make sure you provided the same password twice.")
            }
            else
            {
                Auth.auth().createUser(withEmail: username, password: password) {
                    (user, error) in
                    if(error == nil && user != nil)
                    {
                        print("User created")
                        self.present(ChatRoomViewController(), animated: true, completion: nil)
                    }
                    else
                    {
                        let error = error! as NSError
                        switch(error.code)
                        {
                        case 17007:
                            self.showAlertWith(AlertTitle: "Registration Failed", AlertMessage: error.localizedDescription)
                            break
                            
                        case 17026:
                            self.showAlertWith(AlertTitle: "Registration Failed", AlertMessage: error.localizedDescription)
                            
                        default:
                            self.showAlertWith(AlertTitle: "Registration Failed", AlertMessage: "Unable to register your account. Please try again later.")
                        }
                    }
                }
            }
        }
    }
    
    ///////////////// Helper Methods ///////////////////

    
    ///////////////// UI Components ///////////////////
    
    // App title view
    var appTitleLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Welcome User"
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
        textField.placeholder = "Username (eg: user@clerkie.com)"
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
        textField.placeholder = "Password (atleast 8 characters)"
        textField.textAlignment = .center
        textField.textContentType = UITextContentType.password
        return textField
    }()
    
    // Password re-enter textField container
    var rePasswordContainer : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    // Text Field for Password re-enter
    var rePasswordTextField : UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "re-Password"
        textField.textAlignment = .center
        textField.textContentType = UITextContentType.password
        return textField
    }()
    
    
    
    // Login button
    var registerButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Register", for: .normal)
        
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        button.layer.borderWidth = 3
        button.layer.borderColor = UIColor.white.cgColor
        
        button.addTarget(self, action: #selector(onRegisterPressed), for: .touchUpInside)
        return button
    }()
    
    // Close button
    var closeButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(#imageLiteral(resourceName: "cross"), for: .normal)
        
        button.addTarget(self, action: #selector(onClosePressed), for: .touchUpInside)

        
        return button
    }()
    
    // Arranges all UI components
    private func setupViews()
    {
        // Password Field
        setupPasswordTextField()
        
        // Adding username textFields
        setupUsernameTextField()
        
        // Adding repassword TextField
        setupRePasswordTextField()
        
        // Adding all other views to the base container
        view.addSubview(appTitleLabel)
        appTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        appTitleLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        appTitleLabel.bottomAnchor.constraint(equalTo: usernameContainer.topAnchor, constant: -24).isActive = true
        
        // Add login button
        view.addSubview(registerButton)
        registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        registerButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
        registerButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        registerButton.topAnchor.constraint(equalTo: rePasswordContainer.bottomAnchor, constant: 24).isActive = true
        
        // Adding Close button
        view.addSubview(closeButton)
        closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        closeButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
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
    
    private func setupRePasswordTextField()
    {
        // Adding container to the BaseView
        view.addSubview(rePasswordContainer)
        rePasswordContainer.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1).isActive = true
        rePasswordContainer.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        rePasswordContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        rePasswordContainer.topAnchor.constraint(equalTo: passwordContainer.bottomAnchor, constant: 16).isActive = true
        
        // Add textField to the container
        rePasswordContainer.addSubview(rePasswordTextField)
        rePasswordTextField.heightAnchor.constraint(equalTo: rePasswordContainer.heightAnchor, multiplier: 0.9).isActive = true
        rePasswordTextField.widthAnchor.constraint(equalTo: rePasswordContainer.widthAnchor, multiplier: 0.9).isActive = true
        rePasswordTextField.centerXAnchor.constraint(equalTo: rePasswordContainer.centerXAnchor).isActive = true
        rePasswordTextField.centerYAnchor.constraint(equalTo: rePasswordContainer.centerYAnchor).isActive = true
        
    }


}
