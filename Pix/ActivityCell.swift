//
//  ActivityCell.swift
//  Pix
//
//  Created by Adeola Uthman on 1/3/17.
//  Copyright © 2017 Adeola Uthman. All rights reserved.
//

import UIKit
import SnapKit

class ActivityCell: UITableViewCell {

    /********************************
     *
     *          VARIABLES
     *
     ********************************/
    
    //\(currentUser.username)_activity_log_profile_pictures
    
    let profileView: CircleImageView = {
        let a = CircleImageView();
        a.translatesAutoresizingMaskIntoConstraints = false;
        a.isUserInteractionEnabled = false;
        a.backgroundColor = .gray;
        
        return a;
    }();
    
    let titleLabel: UILabel = {
        let a = UILabel();
        a.translatesAutoresizingMaskIntoConstraints = false;
        a.numberOfLines = 1;
        a.textColor = .black;
        a.textAlignment = .left;
        
        return a;
    }();
    
    
    
    
    /********************************
     *
     *          METHODS
     *
     ********************************/
    
    func setup() {
        addSubview(profileView);
        addSubview(titleLabel);
        
        profileView.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.left.equalTo(snp.left).offset(10);
            maker.top.equalTo(snp.top);
            maker.height.equalTo(height);
            maker.width.equalTo(50);
        }
        titleLabel.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.left.equalTo(profileView.snp.right);
            maker.top.equalTo(snp.top);
            maker.height.equalTo(height);
            maker.right.equalTo(snp.right);
        }
    }

}
