//
//  BlockedUsersPage.swift
//  Pix
//
//  Created by Adeola Uthman on 1/10/17.
//  Copyright © 2017 Adeola Uthman. All rights reserved.
//

import UIKit
import Neon
import SnapKit
import Firebase
import DynamicColor

class BlockedUsersPage: UIViewController {

    /********************************
     *
     *          VARIABLES
     *
     ********************************/

    let textField: UITextField = {
        let a = UITextField();
        a.translatesAutoresizingMaskIntoConstraints = false;
        a.backgroundColor = .white;
        a.placeholder = "Enter the username of the person you want to block.";
        a.font = UIFont(name: (a.font?.fontName)!, size: 14);
        a.autocapitalizationType = .none;
        a.autocorrectionType = .no;
        
        return a;
    }();
    
    let blockButton: UIButton = {
        let a = UIButton();
        a.translatesAutoresizingMaskIntoConstraints = false;
        a.setTitle("Block User", for: .normal);
        a.setTitleColor(UIColor.blue.lighter(), for: .normal);
        a.backgroundColor = .lightGray;
        
        return a;
    }();
    
    let blockedLabel: UILabel = {
        let a = UILabel();
        a.translatesAutoresizingMaskIntoConstraints = false;
        a.text = "List of blocked users";
        a.font = UIFont(name: a.font.fontName, size: 10);
        a.textColor = UIColor.lightGray;
        a.font = UIFont(name: (a.font?.fontName)!, size: 15);
        a.textAlignment = .left;
        
        return a;
    }();
    
    let blockedView: UITextView = {
        let a = UITextView();
        a.translatesAutoresizingMaskIntoConstraints = false;
        a.isUserInteractionEnabled = false;
        a.backgroundColor = .white;
        a.textAlignment = .left;
        
        return a;
    }();
    
    
    let fireRef: FIRDatabaseReference = FIRDatabase.database().reference();
    
    
    
    
    /********************************
     *
     *          METHODS
     *
     ********************************/

    override func viewDidLoad() {
        super.viewDidLoad();
        view.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1);
        navigationItem.hidesBackButton = true;
        
        
        view.addSubview(textField);
        view.addSubview(blockButton);
        view.addSubview(blockedLabel);
        view.addSubview(blockedView);
        

        textField.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.centerX.equalTo(view.snp.centerX);
            maker.width.equalTo(view.width);
            maker.height.equalTo(35);
            maker.top.equalTo(view.snp.top).offset(90);
        }
        blockButton.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.top.equalTo(textField.snp.bottom).offset(10);
            maker.centerX.equalTo(view.snp.centerX);
            maker.width.equalTo(view.width);
            maker.height.equalTo(30);
        }
        blockedLabel.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.top.equalTo(blockButton.snp.bottom).offset(40);
            maker.left.equalTo(view.snp.left).offset(10);
            maker.right.equalTo(view.snp.right);
            maker.height.equalTo(20);
        }
        blockedView.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.top.equalTo(blockedLabel.snp.bottom);
            maker.left.equalTo(view.snp.left);
            maker.right.equalTo(view.snp.right);
            maker.bottom.equalTo(view.snp.bottom);
        }
        
        
        let backBtn = UIBarButtonItem(title: "< Back", style: .plain, target: self, action: #selector(back));
        backBtn.tintColor = .white;
        navigationItem.leftBarButtonItem = backBtn;
        
        blockButton.addTarget(self, action: #selector(blockUserMethod), for: .touchUpInside);
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        self.reloadBlockedView();
    }
    
    
    func reloadBlockedView() {
        blockedView.text = "";
        
        fireRef.child("Users").observeSingleEvent(of: .value) { (snapshot: FIRDataSnapshot) in
            let userDictionary = snapshot.value as? [String : AnyObject] ?? [:];
            
            for user in userDictionary {
                
                let value = user.value as? NSDictionary
                let user = value?.toUser();
                
                
                if currentUser.blockedUsers.containsUsername(username: user!.uid) {
                    self.blockedView.text.append(user!.username);
                }
                
            } // End of for loop
            
        } // End of firebase obser.
    }
    
    
    @objc func back() {
        let _ = navigationController?.popViewController(animated: true);
    }
    
    
    @objc func blockUserMethod() {
        
        fireRef.child("Users").observeSingleEvent(of: .value) { (snapshot: FIRDataSnapshot) in
            let userDictionary = snapshot.value as? [String : AnyObject] ?? [:];
            
            for user in userDictionary {
                
                let value = user.value as? NSDictionary
                let user = value?.toUser();
                
                
                // If they have the same username, add the uid to the users blocked list and update in firebase.
                if self.textField.text == user!.username {
                    
                    // If not already added.
                    if !currentUser.blockedUsers.containsUsername(username: user!.uid) {
                        
                        currentUser.blockedUsers.append(user!.uid);
                        self.fireRef.child("Users").child(currentUser.uid).updateChildValues(currentUser.toDictionary() as! [AnyHashable : Any]);
                        self.reloadBlockedView();
                        landingPage.reloadCurrentUser();
                        break;
                        
                    }
                    
                }
                
            } // End of for loop
            
        } // End of firebase obser.
        
    }
    
    
}
