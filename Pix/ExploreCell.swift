//
//  ExploreCell.swift
//  Pix
//
//  Created by Adeola Uthman on 12/25/16.
//  Copyright © 2016 Adeola Uthman. All rights reserved.
//

import UIKit
import SnapKit

class ExploreCell: UITableViewCell {

    /********************************
     *
     *          VARIABLES
     *
     ********************************/
    
    
    /* The user object for data grabbing. */
    var user: User!;
    
    
    /* The user, but in the form of firebase data. */
    var user_fb: Any!;
    
    
    /* Displays the name of the user. */
    let nameLabel: UILabel = {
        let n = UILabel();
        n.translatesAutoresizingMaskIntoConstraints = false;
        n.textColor = .black;
        
        return n;
    }();
    
    
    /* The image view that displays that user's profile picture. */
    let profilePicture: UIImageView = {
        let a = UIImageView();
        a.translatesAutoresizingMaskIntoConstraints = false;
        a.backgroundColor = .gray;
        a.layer.cornerRadius = 15;
        
        return a;
    }();
    
    
    
    
    
    
    
    /********************************
     *
     *           METHODS
     *
     ********************************/
    
    override func awakeFromNib() {
        super.awakeFromNib();
    }
    
    public func setup(u_fb: Any, u: User) {
        user_fb = u_fb;
        user = u;
        
        // Get the data.
        nameLabel.text = "\(user.firstName) \(user.lastName)";
        // set the profile picture
        
        
        // Setup the view
        addSubview(nameLabel);
        addSubview(profilePicture);
        
        
        // Snapkit
        profilePicture.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.left.equalTo(snp.left).offset(10);
            maker.centerY.equalTo(snp.centerY);
            maker.width.equalTo(width / 10);
            maker.height.equalTo(height - 14);
        }
        nameLabel.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.left.equalTo(profilePicture.snp.right).offset(5);
            maker.right.equalTo(snp.right);
            maker.height.equalTo(height);
        }
    }
    
    
    
}
