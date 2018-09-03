//
//  ChatRoomViewController.swift
//  Clerkie App
//
//  Created by Ram Sri Charan on 8/31/18.
//  Copyright © 2018 Ram Sri Charan. All rights reserved.
//
import UIKit
import FirebaseAuth

class ChatRoomViewController: UITableViewController, UITextViewDelegate {
    
    fileprivate let cellIdentifier = "MessageCell"
    
    ////////////////// My Variables //////////////////
    struct Message {
        var isIncoming : Bool?
        var sender : String?
        var content : String?
    }
    
    var conversations = [Message]()
    
    let myBlueColor : UIColor = UIColor(red: 66/255, green: 103/255, blue: 178/255, alpha: 1.0)
    
    
    
    
    ////////////////// The startup methods //////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.darkGray
        populateData()
        
        // Setup View Components
        setupViews()
        
        // Setup TableView
        tableView.register(CustomMessageCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .onDrag
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 60, 0)

        
        // Navigation Bar
        let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(onLogoutPressed))
        logoutButton.tintColor = UIColor.red
        self.navigationItem.rightBarButtonItem  = logoutButton
        self.navigationController?.navigationBar.barStyle = .blackOpaque
        
        arrangeNavTitleViews()

        // Adding Keyboard observers
        self.hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotifications), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotifications), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    
    @objc func test()
    {
        messageBoxTextView.endEditing(true)
    }
    
    
    
    
    ////////////////// Setup TitleBar View //////////////////

    // Base UIView
    var baseView : UIView = {
        let baseView = UIView()
        baseView.translatesAutoresizingMaskIntoConstraints = false
        return baseView
    }()
    
    // Profile picture ImageView
    var Nav_ProfileImage : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = #imageLiteral(resourceName: "clerkie-logo")
        imageView.layer.borderWidth = 1
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // User name label
    var Nav_UserName : UILabel = {
        let name = UILabel()
        name.text = "Clerkie Bot"
        name.textColor = UIColor.white
        name.font = UIFont.boldSystemFont(ofSize: 12)
        name.translatesAutoresizingMaskIntoConstraints = false
        name.adjustsFontSizeToFitWidth = true
        return name
    }()
    
    // Constraints
    var portraitModeConstraints = [NSLayoutConstraint]()
    var landscapeModeConstraints = [NSLayoutConstraint]()


    
    // Arrange View in Title View
    private func arrangeNavTitleViews()
    {
        // Creating a base View to hold image and text views
        baseView.widthAnchor.constraint(equalToConstant: 60).isActive = true

        baseView.addSubview(Nav_ProfileImage)
        baseView.addSubview(Nav_UserName)
        
        // Initialize Constraits
        initializeConstraints()
        
        // Setup TitleView Arrangement based on orientation
        arrangeViewsWithOrientation()
        
        // Adding the baseview to the navigation bar
        navigationItem.titleView = baseView
    }
    
    
    // Check orientation and assign respective view arrangement
    private func arrangeViewsWithOrientation()
    {
        // Landscape Orientation
        if UIDevice.current.orientation.isLandscape {
            NSLayoutConstraint.deactivate(portraitModeConstraints)
            NSLayoutConstraint.activate(landscapeModeConstraints)
            
            Nav_ProfileImage.layer.cornerRadius = (32*0.9)/2
        }
        // Portrait Orientation
        else{
            NSLayoutConstraint.deactivate(landscapeModeConstraints)
            NSLayoutConstraint.activate(portraitModeConstraints)
            
            Nav_ProfileImage.layer.cornerRadius = (44*0.7)/2
        }
    }
    
    
    // Setup View components constraints
    private func initializeConstraints()
    {
        // Portrait Mode Constraints
        portraitModeConstraints = [baseView.heightAnchor.constraint(equalToConstant: 44),
                                           
                                   Nav_ProfileImage.topAnchor.constraint(equalTo: baseView.topAnchor),
                                   Nav_ProfileImage.centerXAnchor.constraint(equalTo: baseView.centerXAnchor),
                                   Nav_ProfileImage.heightAnchor.constraint(equalTo: baseView.heightAnchor, multiplier: 0.7),
                                   Nav_ProfileImage.widthAnchor.constraint(equalTo: Nav_ProfileImage.heightAnchor),

                                   Nav_UserName.topAnchor.constraint(equalTo: Nav_ProfileImage.bottomAnchor, constant: 2),
                                   Nav_UserName.centerXAnchor.constraint(equalTo: baseView.centerXAnchor),
                                   Nav_UserName.bottomAnchor.constraint(equalTo: baseView.bottomAnchor, constant: -2),
                                   Nav_UserName.heightAnchor.constraint(equalTo: baseView.heightAnchor, multiplier: 0.3, constant: -4)]
        
        
        // Landscape Mode Constraints
        landscapeModeConstraints = [baseView.heightAnchor.constraint(equalToConstant: 32),
                                            
                                    Nav_ProfileImage.centerYAnchor.constraint(equalTo: baseView.centerYAnchor),
                                    Nav_ProfileImage.heightAnchor.constraint(equalTo: baseView.heightAnchor, multiplier: 0.9),
                                    Nav_ProfileImage.widthAnchor.constraint(equalTo: Nav_ProfileImage.heightAnchor),
                                    Nav_ProfileImage.rightAnchor.constraint(equalTo: baseView.centerXAnchor, constant: -2),
                                    
                                    Nav_UserName.centerYAnchor.constraint(equalTo: baseView.centerYAnchor),
                                    Nav_UserName.heightAnchor.constraint(equalTo: baseView.heightAnchor, multiplier: 0.6),
                                    Nav_UserName.leftAnchor.constraint(equalTo: baseView.centerXAnchor, constant: 2)]
        
    }
    
    

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    ////////////////// TableView methods //////////////////
    
    // Set number of rows in tableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }

    // On TableView cell tapped
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.messageBoxTextView.endEditing(true)
    }
    
    
    // Populate Custom Cell with data
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CustomMessageCell
        cell.backgroundColor = UIColor.darkGray
        cell.selectionStyle = .none
        cell.messageTextView.text = conversations[indexPath.row].content
        
        if let messageText = conversations[indexPath.row].content {
            let size = CGSize(width: 250.0, height: .infinity)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimatedSize = NSString(string: messageText).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14)], context: nil)
            
            if(conversations[indexPath.row].isIncoming)!
            {
                // Incoming message
                cell.messageBubbleView.frame = CGRect(x: 8, y: 5, width: estimatedSize.width + 8 + 16, height: estimatedSize.height + 25)
                cell.messageBubbleView.backgroundColor = UIColor(white: 1, alpha: 0.9)
                cell.messageTextView.frame = CGRect(x: 16, y: 8, width: estimatedSize.width + 16 + 8 - 2, height: estimatedSize.height + 20)
                cell.messageTextView.textColor = UIColor.black
            }
            else
            {
                // Outgoing message
                cell.messageBubbleView.frame = CGRect(x: view.frame.width - estimatedSize.width - 8 - 16 - 8, y: 5, width: estimatedSize.width + 8 + 16, height: estimatedSize.height + 25)
                cell.messageBubbleView.backgroundColor = myBlueColor
                cell.messageTextView.frame = CGRect(x: view.frame.width - estimatedSize.width - 16 - 8 - 2, y: 8, width: estimatedSize.width + 16 + 8, height: estimatedSize.height + 20)
                cell.messageTextView.textColor = UIColor.white
            }
        }
        return cell
    }
    
    
    // Setup Cell height based on the length of Message String
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let messageText = conversations[indexPath.row].content {
            let size = CGSize(width: 250.0, height: .infinity)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimatedSize = NSString(string: messageText).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14)], context: nil)
            return (estimatedSize.height + 30)
        }
        return 300
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    ////////////////// Action handlers //////////////////
    
    // Logout handler
    @objc private func onLogoutPressed()
    {
        // Logging out the user
        do{
            try Auth.auth().signOut()
        } catch let error{
            print(error)
        }
        // Gping back to Login page
        self.dismiss(animated: true, completion: nil)
    }
    
    // Send messages handler
    @objc private func onSendButtonPressed()
    {
        let message : String! = messageBoxTextView.text ?? ""
        if(!message.isEmpty)
        {
            let newMessage : Message = Message.init(isIncoming: false, sender: "CurrentUser", content: message.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines))
            addMessageToChat(newMessage: newMessage)
            
            resetMessageBox()
            askChatBotToRespond(userMessage: message)
        }
    }
    
    // Keyboard Will Show handler
    @objc private func handleKeyboardNotifications(notification: NSNotification)
    {
        if let keyboardSize = notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? CGRect {
            
            let isKeyboardShowing = (notification.name == NSNotification.Name.UIKeyboardWillShow)
            self.messageContainerBottomConstraint?.constant = isKeyboardShowing ? -keyboardSize.height : 0
            
            UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
                }, completion: {(completed) in })
            
        }
    }
    
    
    
    
    
    

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    ////////////////// Helper methods //////////////////

    // Populate chat data
    private func populateData()
    {
        let welcomeMessage_1 : Message = Message.init(isIncoming: true, sender: "Chat Bot", content: "Hello there")
        let welcomeMessage_2 : Message = Message.init(isIncoming: true, sender: "Chat Bot", content: "Welcome to the Clerkie Chat bot.")

        conversations.append(welcomeMessage_1)
        conversations.append(welcomeMessage_2)

        tableView.reloadData()
    }
    
    // Handle text Change in TextView
    func textViewDidChange(_ textView: UITextView)
    {
        // Get estimated Size based on Message Content
        let size = CGSize(width: messageBoxTextView.frame.width, height: .infinity)
        let estimatedSize = messageBoxTextView.sizeThatFits(size)
        
        // Check if number lines is le
        if(estimatedSize.height < 85)
        {
            messageBoxTextView.isScrollEnabled = false
            messageContainerHeightConstraint?.constant = estimatedSize.height + 10
        }
        else
        {
            messageBoxTextView.isScrollEnabled = true
        }
    }
    
    
    // Adds messages to the chat
    private func addMessageToChat(newMessage : Message)
    {
        conversations.append(newMessage)
        // Add new message to tableView and Animate
        let indexPath = IndexPath(row: self.conversations.count-1, section: 0)
        tableView.insertRows(at: [indexPath], with: .bottom)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    
    
    // Resets the message box
    private func resetMessageBox()
    {
        messageBoxTextView.text = ""
        messageBoxTextView.isScrollEnabled = false
        
        // Reset message box container
        messageContainerHeightConstraint?.constant = 43
    }
    
    
    // Orientation changes handler
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator)
    {
        // Re-arrange tableView cells
        tableView.reloadData()
        
        // Re-arrange Title View
        arrangeViewsWithOrientation()
    }
    
    // Create response for user input
    private func askChatBotToRespond(userMessage : String)
    {
        let myChatBot : ChatBot = ChatBot()
        
        let response = myChatBot.getResponse(message: userMessage)
        
        let newMessage : Message = Message.init(isIncoming: true, sender: "Chat Bot", content: response.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.addMessageToChat(newMessage: newMessage)
        })
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    ////////////////// View Components //////////////////
    
    // Container view
    var containerView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        
        view.layer.cornerRadius = 3
        view.layer.masksToBounds = true
        
        return view
    }()
    
    // MessageBox TextView
    var messageBoxTextView : UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.backgroundColor = UIColor.lightGray
        
        textView.layer.cornerRadius = 6
        textView.layer.masksToBounds = true
        
        return textView
    }()
    
    // Send message button
    lazy var sendButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(#imageLiteral(resourceName: "send"), for: .normal)
        button.backgroundColor = UIColor(red: 0/255, green: 175/255, blue: 136/255, alpha: 1.0)
        
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16.5
        
        button.addTarget(self, action: #selector(onSendButtonPressed), for: .touchUpInside)
        return button
    }()
    
    // Constraints
    var messageContainerHeightConstraint : NSLayoutConstraint?
    var messageContainerBottomConstraint : NSLayoutConstraint?
    
    // Arrange all the view components
    private func setupViews()
    {
        // Getting View
        let myView = self.navigationController?.view
        
        myView?.addSubview(containerView)
        messageContainerHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: 43)
        messageContainerHeightConstraint?.isActive = true

        messageContainerBottomConstraint = containerView.bottomAnchor.constraint(equalTo: (myView?.bottomAnchor)!, constant: 0)
        messageContainerBottomConstraint?.isActive = true
        
        containerView.centerXAnchor.constraint(equalTo: (myView?.centerXAnchor)!).isActive = true
        containerView.widthAnchor.constraint(equalTo: (myView?.widthAnchor)!, multiplier: 1).isActive = true
        
        // Add Message Box Text view to container
        containerView.addSubview(messageBoxTextView)
        messageBoxTextView.heightAnchor.constraint(equalToConstant: 33).isActive = true
        
        messageBoxTextView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 1, constant: -45).isActive = true
        messageBoxTextView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 4).isActive = true
        messageBoxTextView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 5).isActive = true
        messageBoxTextView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -5).isActive = true
        messageBoxTextView.delegate = self
        
        
        //Add Send Button
        containerView.addSubview(sendButton)
        sendButton.widthAnchor.constraint(equalToConstant: 33).isActive = true
        sendButton.heightAnchor.constraint(equalToConstant: 33).isActive = true
        sendButton.leftAnchor.constraint(equalTo: messageBoxTextView.rightAnchor, constant: 4).isActive = true
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -4).isActive = true
        sendButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -4).isActive = true
    }
    
}
















