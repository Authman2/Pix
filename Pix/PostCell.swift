//
//  PostCell.swift
//  Pix
//
//  Created by Adeola Uthman on 11/15/16.
//  Copyright © 2016 Adeola Uthman. All rights reserved.
//

import Foundation
import UIKit
import Neon

class PostCell: UICollectionViewCell {
    

    ////////////////////////
    ///
    ///
    /// Variables
    ///
    ///
    ////////////////////////
    
    // The post object where all of the data is stored
    public var post: Post = Post();
    
    
    
    // The photo that is being uploaded
    private let photo: UIImageView = UIImageView();
    
    // The profile photo of the user
    private let profilePhoto: UIImageView = UIImageView();
    
    // The label that displays the uploader's name
    private let nameLabel: UILabel = UILabel();

    // The label that displays the image caption
    private let captionLabel: UILabel = UILabel();
    
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        backgroundColor = UIColor.white;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
        
    ////////////////////////
    ///
    ///
    /// Methods
    ///
    ///
    ////////////////////////
    
    // Layout all of the components on screen.
    func setupLayout() {
        addSubview(photo);
        addSubview(profilePhoto);
        addSubview(nameLabel);
        addSubview(captionLabel);
        
        
        photo.anchorToEdge(.top, padding: 0, width: frame.width, height: frame.height);
        profilePhoto.align(.underMatchingLeft, relativeTo: photo, padding: 5, width: frame.width / 8, height: AutoHeight);
        captionLabel.align(.toTheRightMatchingTop, relativeTo: profilePhoto, padding: 10, width: frame.width, height: AutoHeight);
        nameLabel.align(.underCentered, relativeTo: captionLabel, padding: 10, width: frame.width, height: AutoHeight);
    }
    
    
    
    
    
    func setupVariables() {
        // Setup variables
        
        // Setup uploaded photo
        photo.contentMode = .scaleAspectFit;
        photo.translatesAutoresizingMaskIntoConstraints = false;
        if let img = post.image {
            photo.image = img;
        } else {
            photo.image = UIImage(named: "BlankImage.png");
        }
        
        
        // Setup profile image
        profilePhoto.contentMode = .scaleAspectFit;
        profilePhoto.translatesAutoresizingMaskIntoConstraints = false;
        profilePhoto.image = UIImage(named: "friends_icon.png");     // Change later
        
        
        // Setup name label
        nameLabel.text = post.user.firstName + " " + post.user.lastName;
        nameLabel.translatesAutoresizingMaskIntoConstraints = false;
        
        
        // Setup caption label
        if let cap = post.caption {
            captionLabel.text = cap;
        } else {
            captionLabel.text = "nil_caption";
        }
        captionLabel.translatesAutoresizingMaskIntoConstraints = false;
    }
    
    
}
