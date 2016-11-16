//
//  PostCell.swift
//  Pix
//
//  Created by Adeola Uthman on 11/15/16.
//  Copyright © 2016 Adeola Uthman. All rights reserved.
//

import Foundation
import UIKit

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
        
        // Create the stack views
        let photoStackView = UIStackView();
        let profileStackView = UIStackView();
        let labelsStackView = UIStackView();
        let profileLabelsStackView = UIStackView();
        let everythingStackView = UIStackView();
        
        
        // Quick setup
        photoStackView.translatesAutoresizingMaskIntoConstraints = false;
        profileStackView.translatesAutoresizingMaskIntoConstraints = false;
        labelsStackView.translatesAutoresizingMaskIntoConstraints = false;
        profileLabelsStackView.translatesAutoresizingMaskIntoConstraints = false;
        everythingStackView.translatesAutoresizingMaskIntoConstraints = false;
        
        
        // Set whether vertical/horizontal
        photoStackView.axis = UILayoutConstraintAxis.vertical;
        profileStackView.axis = UILayoutConstraintAxis.vertical;
        labelsStackView.axis = UILayoutConstraintAxis.vertical;
        profileLabelsStackView.axis = UILayoutConstraintAxis.horizontal;
        everythingStackView.axis = UILayoutConstraintAxis.vertical;
        
        
        // Add elements to the stack views
        photoStackView.addArrangedSubview(photo);
        profileStackView.addArrangedSubview(profilePhoto);
        labelsStackView.addArrangedSubview(captionLabel);
        labelsStackView.addArrangedSubview(nameLabel);
        
        profileLabelsStackView.addArrangedSubview(profileStackView);
        profileLabelsStackView.addArrangedSubview(labelsStackView);
        
        everythingStackView.addArrangedSubview(photoStackView);
        everythingStackView.addArrangedSubview(profileLabelsStackView);
        
        
        // Add the everythingStackView to the cell
        addSubview(everythingStackView);
        
        
        // Perform layout operations
        createConstraints(profileStackView: profileStackView, everythingStackView: everythingStackView);
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
    
    
    
    
    
    func createConstraints(profileStackView: UIStackView, everythingStackView: UIStackView) {
        // Add constraints for the actual photo
        addConstraintToFrom(from: photo, attr1: .width, relation: .equal, to: self, attr2: .width, multiplier: 1, constant: 0);
        addConstraintToFrom(from: photo, attr1: .height, relation: .equal, to: self, attr2: .height, multiplier: 0.85, constant: 0);
        addConstraintToFrom(from: photo, attr1: .top, relation: .equal, to: self, attr2: .top, multiplier: 1, constant: 0);
        
        
        // Add constraints for the profileLabelsStackView
        addConstraintToFrom(from: profileStackView, attr1: .leftMargin, relation: .equal, to: self, attr2: .leftMargin, multiplier: 1, constant: 0);
        addConstraintToFrom(from: profileStackView, attr1: .width, relation: .equal, to: self, attr2: .width, multiplier: 0.25, constant: 0);
        
        
        // Add constraints for the everything stack view
        addConstraintToFrom(from: everythingStackView, attr1: .centerX, relation: .equal, to: self, attr2: .centerX, multiplier: 1, constant: 0);
        addConstraintToFrom(from: everythingStackView, attr1: .bottomMargin, relation: .equal, to: self, attr2: .bottomMargin, multiplier: 1, constant: 0);
    }
    
}






// Extension
extension UIView {
    
    // Just a slightly simpler way to add constraints
    public func addConstraintToFrom(from: UIView, attr1: NSLayoutAttribute, relation: NSLayoutRelation, to: UIView, attr2: NSLayoutAttribute, multiplier: CGFloat, constant: CGFloat) {
        
        addConstraint(NSLayoutConstraint(item: from, attribute: attr1, relatedBy: relation, toItem: to, attribute: attr2, multiplier: multiplier, constant: constant));
        
    }
    
}

