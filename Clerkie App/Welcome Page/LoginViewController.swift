//
//  ViewController.swift
//  Clerkie App
//
//  Created by Ram Sri Charan on 8/30/18.
//  Copyright © 2018 Ram Sri Charan. All rights reserved.
//

import UIKit
import FirebaseAuth


class LoginViewController: UIViewController, UIViewControllerTransitioningDelegate, RegistrationDelegate {
    

    ////////////////////////////////////////////////////////////////////////////////////////////////////////
                        ///////////////// My Variables /////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////

    let circularTransition = CircularTransition()
    let checkInput = inputValidation()
    
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////
                        ///////////////// ViewController Methods /////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add background color
        view.backgroundColor = UIColor.black
        
        // Add view components
        setupView()
        
        // Handle keyboard
        self.hideKeyboardWhenTappedAround()
        
        NotificationCenter.default.addObserver(self, selector: #selector(moveKeyboardIfOverlap), name:NSNotification.Name.UIKeyboardWillShow, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(moveKeyboardIfOverlap), name:NSNotification.Name.UIKeyboardWillHide, object: nil);
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        initialAnimation()
    }
    
    
    // Setting the status bar text color to white
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    
    // Clear the text Fields
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        usernameTextField.text = ""
        passwordTextField.text = ""
    }
    
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////
                            //////////// Registration Delegate Methods ////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////

    func RegistrationResult(isSuccess: Bool) {
        print("Running delgate")
        if(isSuccess)
        {
            showAlertWith(AlertTitle: "Registration Successful", AlertMessage: "Welcome, your Clerkie App account has been created successfully. Please login to start using the app.")
        }
    }
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////
                            //////////// Circular Transition Methods ////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        circularTransition.transitionMode = .present
        circularTransition.startingPoint = signUpButton.center
        circularTransition.circleColor = signUpButton.backgroundColor!
        
        return circularTransition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        circularTransition.transitionMode = .dismiss
        circularTransition.startingPoint = signUpButton.center
        circularTransition.circleColor = signUpButton.backgroundColor!
        
        return circularTransition
    }
    
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////
                            ///////////////// Action Handlers ///////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    // Handle Keyboard show/hide action handler
    @objc func moveKeyboardIfOverlap(notification: NSNotification) {
        
        if let keyboardFrame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect {
            
            let isKeyboardShowing = (notification.name == NSNotification.Name.UIKeyboardWillShow)
            // Check if key is showing
            if(isKeyboardShowing)
            {
                // Check if it overlaps my Register button
                if(keyboardFrame.intersects(self.loginButton.frame))
                {
                    let buffer = self.loginButton.frame.maxY - keyboardFrame.minY
                    self.view.frame.origin.y = -buffer
                }
            }
            else
            {
                self.view.frame.origin.y = 0 // Move view to original position
            }
        }
    }
    
    
    // On Login Button Pressed Action handler
    @objc private func onLoginPressed()
    {
        let username : String! = usernameTextField.text ?? ""
        let password : String!  = passwordTextField.text ?? ""
                
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
    @objc private func onSignupPressed()
    {
        let signUpVC = SignUpViewController()
        signUpVC.delegate = self
        signUpVC.transitioningDelegate = self
        signUpVC.modalPresentationStyle = .custom
        self.present(signUpVC, animated: true, completion: nil)
    }
    
    
    
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////
                                ///////////////// Helper methods ///////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////

    // Launch Chat View controller 
    private func launchChatViewController()
    {
        let chatroomNavController = UINavigationController(rootViewController: ChatRoomViewController())
        self.present(chatroomNavController, animated: true, completion: nil)
    }
    
    
    // Starting animation
    private func initialAnimation()
    {
        // Make all views clear
        appTitleLabel.alpha = 0
        usernameContainer.alpha = 0
        usernameTextField.alpha = 0
        passwordContainer.alpha = 0
        passwordTextField.alpha = 0
        loginButton.alpha = 0
        signUpButton.alpha = 0
        
        
        // Move all views away from original position
        let myTransform : CGAffineTransform = CGAffineTransform(translationX: 0, y: 40)
        appTitleLabel.transform = myTransform
        usernameContainer.transform = myTransform
        usernameTextField.transform = myTransform
        passwordContainer.transform = myTransform
        passwordTextField.transform = myTransform
        loginButton.transform = myTransform
        
        signUpButton.transform = CGAffineTransform(scaleX: 0, y: 0)
        
        
        UIView.animate(withDuration: 1) {
            // Set alpha back to 1
            self.appTitleLabel.alpha = 1
            self.usernameContainer.alpha = 1
            self.usernameTextField.alpha = 1
            self.passwordContainer.alpha = 1
            self.passwordTextField.alpha = 1
            self.loginButton.alpha = 1
            self.signUpButton.alpha = 1

            // Move all views back to their original places
            self.appTitleLabel.transform = .identity
            self.usernameContainer.transform = .identity
            self.usernameTextField.transform = .identity
            self.passwordContainer.transform = .identity
            self.passwordTextField.transform = .identity
            self.loginButton.transform = .identity
            self.signUpButton.transform = .identity
        }
    }
    
    
    
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////
                    ///////////////// View components and Arrangement ///////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////

    
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
        textField.isSecureTextEntry = true
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
        button.backgroundColor = UIColor.myPink
        button.setTitle(" SignUp ", for: .normal)
        
        
        button.layer.cornerRadius = 35
        button.layer.masksToBounds = true
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        
        button.addTarget(self, action: #selector(onSignupPressed), for: .touchUpInside)
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
    

    // Arrange all Username textfield related subviews
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
   
    
    // Arrange all password textfield related views
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

