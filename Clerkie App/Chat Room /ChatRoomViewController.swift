//
//  ChatRoomViewController.swift
//  Clerkie App
//
//  Created by Ram Sri Charan on 8/31/18.
//  Copyright © 2018 Ram Sri Charan. All rights reserved.
//
import UIKit
import FirebaseAuth

class ChatRoomViewController: UITableViewController, UITextViewDelegate, SelectedImageDelegate {
    
    fileprivate let cellIdentifier = "MessageCell"
    fileprivate let userName = "John"
    
    ////////////////// My Variables //////////////////
    private struct Message {
        var isIncoming : Bool?
        var sender : String?
        var content : String?
        var type : MessageType?
        var thumbnail : UIImage?
    }
    
    private var conversations = [Message]()
    fileprivate let myBlueColor : UIColor = UIColor(red: 66/255, green: 103/255, blue: 178/255, alpha: 1.0)
    
    enum MessageType : Int {
        case text, photo, video
    }
    
    
    
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
        self.navigationController?.navigationBar.barStyle = .blackOpaque

        // Add Data Analytics Page button
        let chartButton = UIBarButtonItem(image: #imageLiteral(resourceName: "chart-icon"), style: .plain, target: self, action: #selector(handleDataAnalyticsTapped))
        self.navigationItem.leftBarButtonItem = chartButton
        
        // Add logout button
        let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(onLogoutPressed))
        logoutButton.tintColor = UIColor.red
        self.navigationItem.rightBarButtonItem  = logoutButton
        
        
        arrangeNavTitleViews()

        // Adding Keyboard observers
        self.hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotifications), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotifications), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    
    // On View appear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if(messageContainerView.isHidden)
        {
            messageContainerView.alpha = 0
            shortcutContainer.alpha = 0
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                
                self.messageContainerView.isHidden = false
                self.shortcutContainer.isHidden = false
                
                self.messageContainerView.alpha = 1
                self.shortcutContainer.alpha = 1
                
            }, completion: nil)
        }
        
        
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
    
    

    
    
    
    ////////////////// Send Selected Image Delegate Method //////////////////

    func imageUploaded(selectedImage: UIImage) {
        let mediaMessage : Message = Message(isIncoming: false, sender: userName, content: "", type: .photo, thumbnail: selectedImage)
        
        addMessageToChat(newMessage: mediaMessage)
        askChatBotToRespond(userMessage: mediaMessage)
    }
    
    func videoUploaded(thumbnail: UIImage, duration: Float, localURL: URL) {
        let mediaMessage : Message = Message(isIncoming: false, sender: userName, content: "", type: .video, thumbnail: thumbnail)
        
        addMessageToChat(newMessage: mediaMessage)
        askChatBotToRespond(userMessage: mediaMessage)
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
        
        
        let frameWidth = view.frame.width
        
        if(conversations[indexPath.row].type == .text)
        {
            cell.messageImageView.isHidden = true
            cell.messageTextView.isHidden = false
            cell.messageBubbleView.isHidden = false
            
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
                    cell.messageBubbleView.frame = CGRect(x: frameWidth - estimatedSize.width - 8 - 16 - 8, y: 5, width: estimatedSize.width + 8 + 16, height: estimatedSize.height + 25)
                    cell.messageBubbleView.backgroundColor = myBlueColor
                    cell.messageTextView.frame = CGRect(x: frameWidth - estimatedSize.width - 16 - 8 - 2, y: 8, width: estimatedSize.width + 16 + 8, height: estimatedSize.height + 20)
                    cell.messageTextView.textColor = UIColor.white
                }
            }
        }
        
        
        else
        {
            // Media Message
            cell.messageImageView.isHidden = false
            cell.messageTextView.isHidden = true
            cell.messageBubbleView.isHidden = true
            
            let myCellSize : CGFloat = (self.view.frame.height / 3)
            cell.messageImageView.image = self.conversations[indexPath.row].thumbnail

            
            if(conversations[indexPath.row].isIncoming)!
            {
                // Incoming message
                cell.messageImageView.frame = CGRect(x: 8, y: 5, width: myCellSize + 8, height: myCellSize + 25)
            }

            else
            {
                // Outgoing message
                let leftMargin = frameWidth - myCellSize - 32.0
                let senderWidth = myCellSize + 24

                cell.messageImageView.frame = CGRect(x: leftMargin, y: 8, width: senderWidth, height: myCellSize + 20)
            }
            
        }
        
        cell.layoutIfNeeded()
        
        return cell
    }
    
    
    
    
    // Setup Cell height based on the length of Message String
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if conversations[indexPath.row].type == .text
        {
            if let messageText = conversations[indexPath.row].content {
                let size = CGSize(width: 250.0, height: .infinity)
                let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
                let estimatedSize = NSString(string: messageText).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14)], context: nil)
                return (estimatedSize.height + 30)
            }
        }
        return ((self.view.frame.height / 3) + 30.0)
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
    
    // Go to Data Analytics Page
    @objc private func handleDataAnalyticsTapped()
    {
        messageBoxTextView.endEditing(true)
        messageContainerView.isHidden = true
        shortcutContainer.isHidden = true
        
        let dataAnalyticsVC = DataAnalyticsViewController()
        self.navigationController?.pushViewController(dataAnalyticsVC, animated: true)
    }
    
    // Send messages handler
    @objc private func onSendButtonPressed()
    {
        let message : String! = messageBoxTextView.text ?? ""
        if(!message.isEmpty)
        {
            let newMessage : Message = Message.init(isIncoming: false, sender: userName, content: message.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines), type: .text, thumbnail: nil)
        
            addMessageToChat(newMessage: newMessage)
            
            resetMessageBox()
            askChatBotToRespond(userMessage: newMessage)
        }
    }
    
    // Keyboard Will Show handler
    @objc private func handleKeyboardNotifications(notification: NSNotification)
    {
        if let keyboardSize = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect {
            
            let isKeyboardShowing = (notification.name == NSNotification.Name.UIKeyboardWillShow)
            let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! Double
            self.messageContainerBottomConstraint?.constant = isKeyboardShowing ? -keyboardSize.height : 0

            UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
                self.navigationController?.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    
    // Chat shortcut button pressed
    @objc private func chatShortcutTapped()
    {
        if(chatShortcutsButton.transform == .identity)
        {
            // Chat Button Animation
            UIView.animate(withDuration: 0.5) {
                let degrees : CGFloat = 45 * (.pi / 180.0)
                self.chatShortcutsButton.transform = CGAffineTransform(rotationAngle: degrees)
                
                self.shortcutContainerHeightConstraint?.constant = 150
                
                self.galleryButton.transform = CGAffineTransform(translationX: 0, y: -50)
                self.galleryButton.alpha = 1
                
                self.sayHiButton.transform = CGAffineTransform(translationX: 0, y: -100)
                self.sayHiButton.alpha = 1
            }
        }
        
        // Remove animation
        else
        {
            startCollapseAnimations()
        }
    }

    

    // Gallery Tapped
    @objc private func onGalleryTapped()
    {
        startCollapseAnimations()
        let galleryVC = GalleryViewController()
        galleryVC.imageSelectedDelegate = self
        galleryVC.view.backgroundColor = UIColor.clear
        galleryVC.modalPresentationStyle = .overCurrentContext
        self.present(galleryVC, animated: true, completion: nil)
    }
    
    
    // Say Hi tapped
    @objc private func onSayHiTapped()
    {
        startCollapseAnimations()
        let messageContent = "Hey there! My name is \(userName)."
        let message : Message = Message.init(isIncoming: false, sender: userName, content: messageContent, type: .text, thumbnail: nil)
        addMessageToChat(newMessage: message)
        askChatBotToRespond(userMessage: message)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    ////////////////// Helper methods //////////////////

    // Populate chat data
    private func populateData()
    {
        let welcomeMessage_1 : Message = Message.init(isIncoming: true, sender: "Chat Bot", content: "Hello there", type: .text, thumbnail: nil)

        let welcomeMessage_2 : Message = Message.init(isIncoming: true, sender: "Chat Bot", content: "Welcome to the Clerkie Chat bot.", type: .text, thumbnail: nil)

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
    private func askChatBotToRespond(userMessage : Message)
    {
        let myChatBot : ChatBot = ChatBot()
        var response : String = ""
        if(userMessage.type == .text)
        {
            response = myChatBot.getResponse(message: userMessage.content!)
        }
        else if (userMessage.type == .photo)
        {
            response = myChatBot.respondToPhoto()
        }
        else if (userMessage.type == .video)
        {
            response = myChatBot.respondToVideo()
        }
        else
        {
            response = myChatBot.respondDefault()
        }
        
        let newMessage : Message = Message.init(isIncoming: true, sender: "Chat Bot", content: response, type: .text, thumbnail: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.addMessageToChat(newMessage: newMessage)
        })
        
    }
    
    
    // Handle Collapsing shortcut button animations
    private func startCollapseAnimations()
    {
        UIView.animate(withDuration: 0.5) {
            self.chatShortcutsButton.transform = .identity
            
            self.shortcutContainerHeightConstraint?.constant = 43

            self.galleryButton.transform = .identity
            self.galleryButton.alpha = 0
            
            self.sayHiButton.transform = .identity
            self.sayHiButton.alpha = 0
            
        }
    }

    
    
    
    
    
    
    
    
    
    
    
    
    
    ////////////////// View Components //////////////////
    
    // Container view
    var messageContainerView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        
        view.layer.cornerRadius = 3
        view.layer.masksToBounds = true
        view.clipsToBounds = false
        
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
    
    
    
    
    // Add Shortcut container
    var shortcutContainer : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    // Add Chat Shortcut button
    lazy var chatShortcutsButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "shortcut-icon"), for: .normal)
        button.backgroundColor = UIColor(red: 209/255, green: 0/255, blue: 80/255, alpha: 1.0)
        button.addTarget(self, action: #selector(chatShortcutTapped), for: .touchUpInside)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16.5
        return button
    }()
    
    // Add Gallery button
    lazy var galleryButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "gallery-icon"), for: .normal)
        button.backgroundColor = UIColor(red: 209/255, green: 0/255, blue: 80/255, alpha: 1.0)
        button.addTarget(self, action: #selector(onGalleryTapped), for: .touchUpInside)
        button.layer.masksToBounds = true
        
        button.layer.cornerRadius = 16.5
        return button
    }()
    
    // Add Say Hi Button
    lazy var sayHiButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "hello-icon"), for: .normal)
        button.backgroundColor = UIColor(red: 209/255, green: 0/255, blue: 80/255, alpha: 1.0)
        button.addTarget(self, action: #selector(onSayHiTapped), for: .touchUpInside)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16.5
        return button
    }()
    
    
    // Constraints
    var messageContainerHeightConstraint : NSLayoutConstraint?
    var messageContainerBottomConstraint : NSLayoutConstraint?
    var shortcutContainerHeightConstraint : NSLayoutConstraint?
    
    
    
    
    
    // Arrange all the view components
    private func setupViews()
    {
        // Getting View
        let myView = self.navigationController?.view
        
        // Add the base Container View
        myView?.addSubview(messageContainerView)
        messageContainerHeightConstraint = messageContainerView.heightAnchor.constraint(equalToConstant: 43)
        messageContainerHeightConstraint?.isActive = true

        messageContainerBottomConstraint = messageContainerView.bottomAnchor.constraint(equalTo: (myView?.bottomAnchor)!, constant: 0)
        messageContainerBottomConstraint?.isActive = true
        
        messageContainerView.centerXAnchor.constraint(equalTo: (myView?.centerXAnchor)!).isActive = true
        messageContainerView.widthAnchor.constraint(equalTo: (myView?.widthAnchor)!, multiplier: 1).isActive = true
        
        // Add Chat Shortcuts button
        setupShortcutButtons()

        
        // Add Message Box Text view to container
        messageContainerView.addSubview(messageBoxTextView)
        messageBoxTextView.heightAnchor.constraint(equalToConstant: 33).isActive = true
        
        messageBoxTextView.widthAnchor.constraint(equalTo: messageContainerView.widthAnchor, multiplier: 1, constant: -82).isActive = true
        messageBoxTextView.leftAnchor.constraint(equalTo: chatShortcutsButton.rightAnchor, constant: 4).isActive = true
        messageBoxTextView.topAnchor.constraint(equalTo: messageContainerView.topAnchor, constant: 5).isActive = true
        messageBoxTextView.bottomAnchor.constraint(equalTo: messageContainerView.bottomAnchor, constant: -5).isActive = true
        messageBoxTextView.delegate = self
        
        
        //Add Send Button
        messageContainerView.addSubview(sendButton)
        sendButton.widthAnchor.constraint(equalToConstant: 33).isActive = true
        sendButton.heightAnchor.constraint(equalToConstant: 33).isActive = true
        sendButton.leftAnchor.constraint(equalTo: messageBoxTextView.rightAnchor, constant: 4).isActive = true
        sendButton.rightAnchor.constraint(equalTo: messageContainerView.rightAnchor, constant: -4).isActive = true
        sendButton.bottomAnchor.constraint(equalTo: messageContainerView.bottomAnchor, constant: -4).isActive = true
        
    }
    
    
    // Setting up Shortcut button layout
    private func setupShortcutButtons()
    {
        
        let myView = self.navigationController?.view
        
        // Add Shortcut container
        myView?.addSubview(shortcutContainer)
        shortcutContainerHeightConstraint = shortcutContainer.heightAnchor.constraint(equalToConstant: 43)
        shortcutContainerHeightConstraint?.isActive = true
        
        shortcutContainer.widthAnchor.constraint(equalToConstant: 33).isActive = true
        shortcutContainer.bottomAnchor.constraint(equalTo: messageContainerView.bottomAnchor).isActive = true
        shortcutContainer.leftAnchor.constraint(equalTo: messageContainerView.leftAnchor, constant: 4).isActive = true
        
        
        // Add shortcut root button
        shortcutContainer.addSubview(chatShortcutsButton)
        chatShortcutsButton.widthAnchor.constraint(equalToConstant: 33).isActive = true
        chatShortcutsButton.heightAnchor.constraint(equalToConstant: 33).isActive = true
        chatShortcutsButton.centerXAnchor.constraint(equalTo: shortcutContainer.centerXAnchor).isActive = true
        chatShortcutsButton.bottomAnchor.constraint(equalTo: shortcutContainer.bottomAnchor, constant: -4).isActive = true
        
        
        // Add Gallery Button
        shortcutContainer.addSubview(galleryButton)
        galleryButton.widthAnchor.constraint(equalToConstant: 33).isActive = true
        galleryButton.heightAnchor.constraint(equalToConstant: 33).isActive = true
        galleryButton.centerXAnchor.constraint(equalTo: shortcutContainer.centerXAnchor).isActive = true
        galleryButton.bottomAnchor.constraint(equalTo: chatShortcutsButton.bottomAnchor).isActive = true
        
        // Add Say Hi Button
        shortcutContainer.addSubview(sayHiButton)
        sayHiButton.widthAnchor.constraint(equalToConstant: 33).isActive = true
        sayHiButton.heightAnchor.constraint(equalToConstant: 33).isActive = true
        sayHiButton.centerXAnchor.constraint(equalTo: shortcutContainer.centerXAnchor).isActive = true
        sayHiButton.bottomAnchor.constraint(equalTo: chatShortcutsButton.bottomAnchor).isActive = true
        
        // Make the root button top of stack
        shortcutContainer.bringSubview(toFront: chatShortcutsButton)
    }
    
    
    
    
    
    
}
















