//
//  CustomImageCell.swift
//  Clerkie App
//
//  Created by Ram Sri Charan on 9/4/18.
//  Copyright © 2018 Ram Sri Charan. All rights reserved.
//

import Foundation
import UIKit

class CustomImageCell : UICollectionViewCell {
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////
                                        ///////// View Components //////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////

    // Photo ImageView
    var photoImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        return imageView
    }()
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////
                        ///////////////// Arrange view in the cell //////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(photoImageView)
        photoImageView.topAnchor.constraint(equalTo: topAnchor, constant: 3).isActive = true
        photoImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -3).isActive = true
        photoImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 3).isActive = true
        photoImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -3).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
