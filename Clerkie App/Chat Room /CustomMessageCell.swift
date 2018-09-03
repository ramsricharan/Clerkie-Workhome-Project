//
//  CustomMessageCell.swift
//  Clerkie App
//
//  Created by Ram Sri Charan on 9/1/18.
//  Copyright © 2018 Ram Sri Charan. All rights reserved.
//

import Foundation
import UIKit


class CustomMessageCell : UITableViewCell {
    
    ///////// View Components //////////
    let messageBubbleView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.red
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()
    
    let messageTextView : UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = UIColor.clear
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.isEditable = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    // Arrange view in the cell
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Add bubble container
        addSubview(messageBubbleView)
        
        // Add message TextField to the bubble view
        addSubview(messageTextView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
