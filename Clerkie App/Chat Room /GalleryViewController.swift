//
//  GalleryViewController.swift
//  Clerkie App
//
//  Created by Ram Sri Charan on 9/3/18.
//  Copyright © 2018 Ram Sri Charan. All rights reserved.
//

import UIKit
import Photos



// Setup a Protocol
protocol SelectedImageDelegate {
    func imageSelected(selectedImage : UIImage)
}



class GalleryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    ///////////////// My Variables /////////////////
    var PhotosArray = [UIImage]()
    let CELL_IDENTIFIER = "MyCollectionCell"
    var imageSelectedDelegate : SelectedImageDelegate!
    
    
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        grabPhotos()
        
        // Add tap gesture to dismiss view
        let placeHolderTapped = UITapGestureRecognizer(target: self, action: #selector(dismissVC))
        placeHolderView.addGestureRecognizer(placeHolderTapped)
    }


    /////////////// Action Handlers  ///////////////

    @objc private func dismissVC()
    {
        placeHolderView.backgroundColor = UIColor.clear
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    
    /////////////// Helper Methods  ///////////////

    // Get images from storage
    private func grabPhotos()
    {
        let imageManager = PHImageManager.default()
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        requestOptions.deliveryMode = .opportunistic
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let fetchResult : PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)

        if (fetchResult.count > 0)
        {
            // We have images
            for i in 0..<fetchResult.count
            {
                imageManager.requestImage(for: fetchResult.object(at: i), targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFit , options: requestOptions)
                { (image, error) in
                    self.PhotosArray.append(image!)
                }
            }
        }
        else
        {
            // No images found
            self.galleryCollectionView.reloadData()
        }
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    /////////////// Collection View Methods  ///////////////
    // Number of rows
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PhotosArray.count
    }
    
    // Arrange Cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_IDENTIFIER, for: indexPath) as! CustomImageCell
        
        cell.photoImageView.image = PhotosArray[indexPath.row]
        return cell
    }
    
    
    // On cell selected
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let currentCell = collectionView.cellForItem(at: indexPath) as! CustomImageCell
        
        UIView.animate(withDuration: 0.3) {
            let move = currentCell.frame.height / 4
            currentCell.transform = CGAffineTransform(translationX: move, y: move)
        }
        
        currentCell.frame.size.height = 0
        currentCell.frame.size.width = 0
        
        UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
            currentCell.alpha = 0
        }, completion: { (true) in
            self.imageSelectedDelegate.imageSelected(selectedImage: self.PhotosArray[indexPath.row])
            self.dismissVC()
        })
        
    }
    
    
    
    
    // Set cell size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let height = galleryCollectionView.frame.height
        return CGSize(width: height, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    
    
    /////////////// View Components ///////////////
    
    // Peek over view
    let placeHolderView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(white: 0, alpha: 0.4)
        return view
    }()
    
    // ImagePicker Container
    let pickerContainerView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 3
        view.layer.masksToBounds = true
        return view
    }()
    
    // Close Button
    var closeButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("X", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        return button
    }()
    
    // ImagePicker Collection View
    lazy var galleryCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.delegate = self
        cv.dataSource = self
        cv.register(CustomImageCell.self, forCellWithReuseIdentifier: CELL_IDENTIFIER)
        cv.backgroundColor = .white
        return cv

    }()
    
    
    
    // Arrange all the View components
    private func setupView()
    {
        // Add placeHolder View
        view.addSubview(placeHolderView)
        placeHolderView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6).isActive = true
        placeHolderView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        placeHolderView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        placeHolderView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        
        // Add baseContainer View
        view.addSubview(pickerContainerView)
        pickerContainerView.topAnchor.constraint(equalTo: placeHolderView.bottomAnchor).isActive = true
        pickerContainerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        pickerContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4).isActive = true
        pickerContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        // Adding close button
        pickerContainerView.addSubview(closeButton)
        closeButton.topAnchor.constraint(equalTo: pickerContainerView.topAnchor, constant: 3).isActive = true
        closeButton.rightAnchor.constraint(equalTo: pickerContainerView.rightAnchor, constant: -8).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        // Adding collectionView
        
        pickerContainerView.addSubview(galleryCollectionView)
        galleryCollectionView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 2).isActive = true
        galleryCollectionView.leftAnchor.constraint(equalTo: pickerContainerView.leftAnchor, constant: 8).isActive = true
        galleryCollectionView.rightAnchor.constraint(equalTo: pickerContainerView.rightAnchor, constant: -8).isActive = true
        galleryCollectionView.bottomAnchor.constraint(equalTo: pickerContainerView.bottomAnchor, constant: -8).isActive = true
        galleryCollectionView.widthAnchor.constraint(equalTo: pickerContainerView.widthAnchor, constant: -16).isActive = true
        galleryCollectionView.heightAnchor.constraint(equalTo: pickerContainerView.heightAnchor, constant: -43).isActive = true
        
        
        galleryCollectionView.dataSource = self
        galleryCollectionView.delegate = self
        
    }

}












