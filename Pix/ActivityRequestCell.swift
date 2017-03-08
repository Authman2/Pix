//
//  FollowRequestCellTableViewCell.swift
//  Pix
//
//  Created by Adeola Uthman on 1/5/17.
//  Copyright © 2017 Adeola Uthman. All rights reserved.
//

import UIKit
import SnapKit
import Firebase


class ActivityRequestCell: UICollectionViewCell {

    /********************************
     *
     *          VARIABLES
     *
     ********************************/
    
    /* The activity object for grabbing data. */
    var activity: Activity?;
    
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        backgroundColor = .white;
        addSubview(titleLabel);
        addSubview(acceptButton);
        addSubview(declineButton);
        
        if activity?.interactedWith == true {
            self.acceptButton.isHidden = true;
            self.declineButton.isHidden = true;
        }
        
        
        titleLabel.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.left.equalTo(snp.left).offset(10);
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
        declineButton.addTarget(self, action: #selector(declineMethod), for: .touchUpInside);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    
    
    @objc func accept() {
        
        if activity?.interactedWith == false {
            acceptButton.isHidden = true;
            declineButton.isHidden = true;
            self.acceptButton.isEnabled = false;
            self.declineButton.isEnabled = false;
            
            // Accept the follow request.
            otherProfilePage.acceptFollowRequest(user: self.activity!.user!, followDirection: .toFrom);
            
            // Get the index of the activity.
            let insertIndex = notificationActivityLog.indexOf(activity: self.activity!);
            
            // Update the activity object.
            self.activity?.interactedWith = true;
            
            // Update the array.
            notificationActivityLog[insertIndex] = self.activity!.toDictionary();
            UserDefaults.standard.setValue(notificationActivityLog, forKey: "\(Networking.currentUser!.uid)_activity_log");
        }
        
    } // End of method.
    
    
    @objc func declineMethod() {
        if self.activity?.interactedWith == false {
            acceptButton.isHidden = true;
            declineButton.isHidden = true;
            self.acceptButton.isEnabled = false;
            self.declineButton.isEnabled = false;
            
            // Get the index of the activity.
            let insertIndex = notificationActivityLog.indexOf(activity: self.activity!);
            
            // Update the activity object.
            self.activity?.interactedWith = true;
            
            // Update the array.
            notificationActivityLog[insertIndex] = self.activity!.toDictionary();
            UserDefaults.standard.setValue(notificationActivityLog, forKey: "\(Networking.currentUser!.uid)_activity_log");
        }
    }



}
