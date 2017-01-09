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
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    
    
    @objc func accept() {
        
        if activity?.interactedWith == false {
            profilePage.acceptFollowRequest(user: (self.activity?.user)!, followDirection: .toFrom);
            
            // Update the activity object.
            let insertIndex = notificationActivityLog.indexOf(activity: self.activity!);
            self.activity?.interactedWith = true;
            
            
            // Update the users in firebase.
            let fireRef = FIRDatabase.database().reference();
            fireRef.child("Users").child(currentUser.uid).updateChildValues(currentUser.toDictionary() as! [AnyHashable : Any]);
            fireRef.child("Users").child((self.activity?.user?.uid)!).updateChildValues(self.activity?.user?.toDictionary() as! [AnyHashable : Any]);
            
            
            // Save the defaults.
            if insertIndex == -1 {
                notificationActivityLog.append((self.activity?.toDictionary())!);
            } else {
                notificationActivityLog.insert((self.activity?.toDictionary())!, at: insertIndex);
            }
            UserDefaults.standard.setValue(notificationActivityLog, forKey: "\(currentUser.uid)_activity_log");
        }
        
    } // End of method.
    
    
    @objc func decline() {
        acceptButton.isHidden = true;
        declineButton.isHidden = true;
        self.activity?.interactedWith = true;
        
        // Save the defaults.
        let insertIndex = notificationActivityLog.index(of: (self.activity?.toDictionary())!);
        notificationActivityLog.insert((self.activity?.toDictionary())!, at: insertIndex!);
        UserDefaults.standard.setValue(notificationActivityLog, forKey: "\(currentUser.uid)_activity_log");
    }



}
