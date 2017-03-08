//
//  UnblockUserPage.swift
//  Pix
//
//  Created by Adeola Uthman on 1/11/17.
//  Copyright © 2017 Adeola Uthman. All rights reserved.
//

import Foundation
import UIKit
import Presentr
import Firebase
import SnapKit


class UnblockUserPage: UIViewController {
    
    
    var username: String?;
    var uid: String?;
    var blockedPage: BlockedUsersPage?;
    
    
    var textLabel: UILabel = {
        let a = UILabel();
        a.translatesAutoresizingMaskIntoConstraints = false;
        a.textColor = .black;
        a.font = UIFont(name: (a.font?.fontName)!, size: 20);
        a.textAlignment = .center;
        a.numberOfLines = 0;
        
        return a;
    }();
    
    let yesButton: UIButton = {
        let a = UIButton();
        a.translatesAutoresizingMaskIntoConstraints = false;
        a.setTitle("Yes", for: .normal);
        a.setTitleColor(.black, for: .normal);
        a.backgroundColor = .lightGray;
        a.titleLabel?.font = UIFont(name: (a.titleLabel?.font.fontName)!, size: 20);
        
        return a;
    }();
    
    
    let noButton: UIButton = {
        let a = UIButton();
        a.translatesAutoresizingMaskIntoConstraints = false;
        a.setTitle("No", for: .normal);
        a.setTitleColor(.red, for: .normal);
        a.backgroundColor = .lightGray;
        a.titleLabel?.font = UIFont(name: (a.titleLabel?.font.fontName)!, size: 20);
        
        return a;
    }();
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad();
        view.backgroundColor = UIColor(white: 255, alpha: 0.5);
        textLabel.text = "Are you sure you want to unblock \(username!)?";
        
        view.addSubview(textLabel);
        view.addSubview(yesButton);
        view.addSubview(noButton);
        
        
        textLabel.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.centerX.equalTo(view.snp.centerX);
            maker.top.equalTo(view.snp.top).offset(10);
            maker.width.equalTo(view.width);
            maker.height.equalTo(50);
        }
        yesButton.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.centerX.equalTo(view.snp.centerX);
            maker.top.equalTo(textLabel.snp.bottom);
            maker.width.equalTo(view.width);
            maker.height.equalTo(50);
        }
        noButton.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.centerX.equalTo(view.snp.centerX);
            maker.top.equalTo(yesButton.snp.bottom).offset(10);
            maker.width.equalTo(view.width);
            maker.height.equalTo(50);
        }
        
        yesButton.addTarget(self, action: #selector(yesMethod), for: .touchUpInside);
        noButton.addTarget(self, action: #selector(noMethod), for: .touchUpInside);
    }
    
    
    
    @objc func yesMethod() {
        if Networking.currentUser!.blockedUsers.containsUsername(username: uid!) {
            Networking.currentUser!.blockedUsers.removeItem(item: uid!);
            blockedUsernames.removeItem(item: username!);
            UserDefaults.standard.setValue(blockedUsernames, forKey: "\(Networking.currentUser!.uid)_blocked_users");

            Networking.updateCurrentUserInFirebase();
//            let fireRef = FIRDatabase.database().reference();
//            fireRef.child("Users").child(Networking.currentUser!.uid).updateChildValues(Networking.currentUser!.toDictionary() as! [AnyHashable : Any]);
            blockedPage?.adapter.performUpdates(animated: true, completion: nil);
        }
        noMethod();
    }
    
    
    @objc func noMethod() {
        dismiss(animated: true, completion: nil);
    }
}
