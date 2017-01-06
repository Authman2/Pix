//
//  FollowRequestCellTableViewCell.swift
//  Pix
//
//  Created by Adeola Uthman on 1/5/17.
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
        a.numberOfLines = 0;
        a.textColor = .black;
        a.textAlignment = .left;
        
        return a;
    }();
    
    
    let acceptButton: UIButton = {
        let a = UIButton();
        a.translatesAutoresizingMaskIntoConstraints = false;
        a.setTitle("Accept", for: .normal);
        a.backgroundColor = .black;
        a.layer.cornerRadius = 5;
        a.titleLabel?.font = UIFont(name: (a.titleLabel?.font.fontName)!, size: 15);
        a.titleLabel?.textColor = .white;
        
        return a;
    }();
    
    
    let declineButton: UIButton = {
        let a = UIButton();
        a.translatesAutoresizingMaskIntoConstraints = false;
        a.setTitle("Decline", for: .normal);
        a.backgroundColor = .black;
        a.layer.cornerRadius = 5;
        a.titleLabel?.font = UIFont(name: (a.titleLabel?.font.fontName)!, size: 15);
        a.titleLabel?.textColor = .white;
        
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
        addSubview(acceptButton);
        addSubview(declineButton);
        
        profileView.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.left.equalTo(snp.left).offset(10);
            maker.top.equalTo(snp.top);
            maker.height.equalTo(height);
            maker.width.equalTo(50);
        }
        titleLabel.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.left.equalTo(profileView.snp.right);
            maker.top.equalTo(snp.top);
            maker.right.equalTo(snp.right);
        }
        acceptButton.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.top.equalTo(titleLabel.snp.bottom).offset(5);
            maker.width.equalTo(80);
            maker.height.equalTo(25);
            maker.centerX.equalTo(snp.centerX).offset(-50);
        }
        declineButton.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.top.equalTo(titleLabel.snp.bottom).offset(5);
            maker.width.equalTo(80);
            maker.height.equalTo(25);
            maker.centerX.equalTo(snp.centerX).offset(50);
        }
        
        
        acceptButton.addTarget(self, action: #selector(accept), for: .touchUpInside);
    }

    
    
    
    @objc func accept() {
        profilePage.acceptFollowRequest();
        profilePage.reloadLabels();
        acceptButton.isHidden = true;
        declineButton.isHidden = true;
    }
    
    
    @objc func decline() {
        acceptButton.isHidden = true;
        declineButton.isHidden = true;
    }



}
