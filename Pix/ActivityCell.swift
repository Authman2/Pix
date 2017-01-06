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


class ActivityCell: UITableViewCell {

    /********************************
     *
     *          VARIABLES
     *
     ********************************/
    
    /* The user for grabbing data. */
    var user: User! = User(first: "", last: "", username: "", email: "");
    
    
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
        addSubview(titleLabel);
        addSubview(acceptButton);
        addSubview(declineButton);
        
        
        if currentUser.followers.containsUsername(username: user.uid) {
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

    
    
    
    @objc func accept() {
        // Add to the activity log.
        let fireRef = FIRDatabase.database().reference();
        fireRef.child("Users").observeSingleEvent(of: .value) { (snapshot: FIRDataSnapshot) in
            let users = snapshot.value as? [String: AnyObject] ?? [:];
            
            for user in users {
                
                let uid = user.value["userid"] as? String ?? "";
                let username = user.value["username"] as? String ?? "";
                let em = user.value["email"] as? String ?? "";
                let firstName = user.value["first_name"] as? String ?? "";
                let lastName = user.value["last_name"] as? String ?? "";
                let pass = user.value["password"] as? String ?? "";
                let followers = user.value["followers"] as? [String] ?? [];
                let following = user.value["following"] as? [String] ?? [];
                let likedPhotos = user.value["liked_photos"] as? [String] ?? [];
                let notifID = user.value["notification_id"] as? String ?? "";
                let privateAcc = user.value["is_private"] as? Bool ?? false;
                let imgName = user.value["profile_picture"] as? String ?? "";
                
                let shortName = (self.titleLabel.text)?.substring(i: 0, j: ((self.titleLabel.text)?.indexOf(string: " "))!);
                if username == shortName {
                    
                    // Get a reference to the firebase media storage.
                    let imgRef = FIRStorage.storage().reference().child("\(uid)/\(imgName).jpg");
                    imgRef.data(withMaxSize: 50 * 1024 * 1024, completion: { (data: Data?, error: Error?) in
                        
                        if error == nil {
                            let usr = User(first: firstName, last: lastName, username: username, email: em);
                            usr.uid = uid;
                            usr.followers = followers;
                            usr.following = following;
                            usr.password = pass;
                            usr.likedPhotos = likedPhotos;
                            usr.notification_ID = notifID;
                            usr.isPrivate = privateAcc;
                            usr.profilePicName = imgName;
                            usr.profilepic = UIImage(data: data!);
                            
                            usersOnActivity.append(usr.toDictionary());
                            UserDefaults.standard.setValue(usersOnActivity, forKey: "\(currentUser.uid)_activity_log_users");
                            self.user = usr;
                            
                            profilePage.acceptFollowRequest(user: self.user, followDirection: .toFrom);
                            self.acceptButton.isHidden = true;
                            self.declineButton.isHidden = true;
                            
                            // Update the NSUserDefaults.
                            UserDefaults.standard.setValue(notificationActivityLog, forKey: "\(currentUser.uid)_activity_log");
                            UserDefaults.standard.setValue(usersOnActivity, forKey: "\(currentUser.uid)_activity_log_users");
                            
                            // Update the users in firebase.
                            _ = FIRDatabase.database().reference();
                            fireRef.child("Users").child(currentUser.uid).updateChildValues(currentUser.toDictionary() as! [AnyHashable : Any]);
                            fireRef.child("Users").child(self.user.uid).updateChildValues(self.user.toDictionary() as! [AnyHashable : Any]);
                            
                            profilePage.nameLabel.text = "\(self.user.firstName) \(self.user.lastName)";
                            profilePage.followersLabel.text = "Followers: \(self.user.followers.count)";
                            profilePage.followingLabel.text = "Following: \(self.user.following.count)";
                            profilePage.collectionView?.isHidden = false;
                            profilePage.privateLabel.isHidden = true;
                            
                        } else {
                            print("----------> There was an error loading the activity user's profile pictures.");
                            print("----------> \(error.debugDescription)");
                        }
                    });
                    
                    break;
                }
            }
        }
    } // End of method.
    
    
    @objc func decline() {
        acceptButton.isHidden = true;
        declineButton.isHidden = true;
        
        // Update the NSUserDefaults.
        UserDefaults.standard.setValue(notificationActivityLog, forKey: "\(currentUser.uid)_activity_log");
        UserDefaults.standard.setValue(usersOnActivity, forKey: "\(currentUser.uid)_activity_log_users");
    }



}
