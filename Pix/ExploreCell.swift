//
//  ExploreCell.swift
//  Pix
//
//  Created by Adeola Uthman on 12/25/16.
//  Copyright © 2016 Adeola Uthman. All rights reserved.
//

import UIKit
import SnapKit
import Firebase

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
        n.textAlignment = .left;
        
        return n;
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
        nameLabel.text = "\(self.user.username)";
        
        
        // Setup the view
        addSubview(nameLabel);
        
        
        // Snapkit
        nameLabel.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.left.equalTo(snp.left).offset(5);
            maker.centerY.equalTo(snp.centerY);
            maker.width.equalTo(width);
            maker.height.equalTo(height);
        }
    }
    
    
    
    
    
}
