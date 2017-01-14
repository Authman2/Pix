//
//  SignUpPage.swift
//  Pix
//
//  Created by Adeola Uthman on 12/22/16.
//  Copyright © 2016 Adeola Uthman. All rights reserved.
//

import UIKit
import SnapKit
import Firebase
import OneSignal
import Spring

class SignUpPage: UIViewController {

    /********************************
     *
     *          VARIABLES
     *
     ********************************/
    
    /* The title of the app, Pix. */
    let titleLabel: UILabel = {
        let t = UILabel();
        t.translatesAutoresizingMaskIntoConstraints = false;
        t.text = "Pix";
        t.textColor = UIColor.white;
        t.font = UIFont(name: t.font.fontName, size: 35);
        t.isUserInteractionEnabled = false;
        
        return t;
    }();
    
    /* The full name text field. */
    let fullnameField: UITextField = {
        let t = UITextField();
        t.placeholder = "Full Name";
        t.translatesAutoresizingMaskIntoConstraints = false;
        t.backgroundColor = UIColor.white;
        t.textAlignment = .center;
        
        return t;
    }();
    
    
    /* A field to create a username. */
    let usernameField: UITextField = {
        let t = UITextField();
        t.placeholder = "Username";
        t.translatesAutoresizingMaskIntoConstraints = false;
        t.backgroundColor = UIColor.white;
        t.textAlignment = .center;
        t.autocapitalizationType = .none;
        t.autocorrectionType = .no;
        
        return t;
    }();
    
    /* The email text field. */
    let emailField: UITextField = {
        let e = UITextField();
        e.translatesAutoresizingMaskIntoConstraints = false;
        e.placeholder = "Email";
        e.backgroundColor = UIColor.white;
        e.textAlignment = .center;
        e.autocapitalizationType = .none;
        e.autocorrectionType = .no;
        e.keyboardType = .emailAddress;
        
        return e;
    }();
    
    
    /* The password text field. */
    let passwordField: UITextField = {
        let p = UITextField();
        p.translatesAutoresizingMaskIntoConstraints = false;
        p.placeholder = "Password";
        p.backgroundColor = UIColor.white;
        p.textAlignment = .center;
        p.isSecureTextEntry = true;
        p.autocapitalizationType = .none;
        p.autocorrectionType = .no;
        
        return p;
    }();
    
    
    /* The sign up button. */
    let signupButton: SpringButton = {
        let s = SpringButton();
        s.setTitle("Sign Up", for: .normal);
        s.backgroundColor = UIColor(red: 21/255, green: 180/255, blue: 133/255, alpha: 1);
        s.layer.cornerRadius = 25;
        s.titleLabel?.font = UIFont(name: (s.titleLabel?.font.fontName)!, size: 15);
        
        return s;
    }();
    
    
    /* Displays the status of loggin in. */
    let statusLabel: UILabel = {
        let s = UILabel();
        s.translatesAutoresizingMaskIntoConstraints = false;
        s.textColor = UIColor.red;
        s.isHidden = true;
        s.isUserInteractionEnabled = false;
        s.textAlignment = .center;
        
        return s;
    }();

    
    /* The firebase database reference. */
    let fireRef: FIRDatabaseReference! = FIRDatabase.database().reference();
    
    
    
    
    /********************************
     *
     *          METHODS
     *
     ********************************/
    
    override func viewDidLoad() {
        super.viewDidLoad();
        view.backgroundColor = UIColor(red: 41/255, green: 200/255, blue: 153/255, alpha: 1);
        
        view.addSubview(titleLabel);
        view.addSubview(fullnameField);
        view.addSubview(usernameField);
        view.addSubview(emailField);
        view.addSubview(passwordField);
        view.addSubview(signupButton);
        view.addSubview(statusLabel);
        
        
        titleLabel.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.top.equalTo(view.snp.top).offset(45);
            maker.centerX.equalTo(view.snp.centerX);
        }
        fullnameField.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.top.equalTo(titleLabel.snp.bottom).offset(20);
            maker.centerX.equalTo(view.snp.centerX);
            maker.width.equalTo(view.width);
            maker.height.equalTo(30);
        }
        usernameField.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.top.equalTo(fullnameField.snp.bottom).offset(10);
            maker.centerX.equalTo(view.snp.centerX);
            maker.width.equalTo(view.width);
            maker.height.equalTo(30);
        }
        emailField.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.top.equalTo(usernameField.snp.bottom).offset(10);
            maker.width.equalTo(view.width);
            maker.height.equalTo(30);
        }
        passwordField.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.top.equalTo(emailField.snp.bottom).offset(10);
            maker.width.equalTo(view.width);
            maker.height.equalTo(30);
        }
        statusLabel.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.top.equalTo(passwordField.snp.bottom);
            maker.width.equalTo(view.width);
            maker.height.equalTo(30);
            maker.centerX.equalTo(view.snp.centerX);
        }
        signupButton.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.centerX.equalTo(view.snp.centerX);
            maker.top.equalTo(statusLabel.snp.bottom).offset(10);
            maker.width.equalTo(70);
            maker.height.equalTo(45);
        }
        
        signupButton.addTarget(self, action: #selector(signUp), for: .touchUpInside);
    }
    
    
    
    
    /* Goes to the sign up page. */
    @objc func signUp() {
        
        if (self.fullnameField.text?.length())! > 0 {
            if (self.emailField.text?.length())! > 0 {
                if (self.passwordField.text?.length())! > 0 {
                    if ((self.usernameField.text?.length())! > 0) {
                        
                        signupButton.animateButtonClick();
                     
                        fireRef.child("Users").observeSingleEvent(of: .value, with: { (snapshot: FIRDataSnapshot) in
                            
                            let userDictionary = snapshot.value as? [String : AnyObject] ?? [:];
                            
                            for user in userDictionary {
                                let aUser = user.value as! [String : AnyObject];
                                let name = aUser["username"] as? String;
                                
                                if name == self.usernameField.text {
                                    self.statusLabel.textColor = .red;
                                    self.statusLabel.text = "Username already taken.";
                                    self.statusLabel.isHidden = false;
                                    return;
                                }
                            }
                            
                        }); // End of checking for existing username.
                        
                        self.createUser(username: self.usernameField.text!);
                        
                    }
                }
            }
        }
    } // End of sign up method.
    
    
    
    func createUser(username: String) {
        // Get the variables needed to create a user.
        let name = self.fullnameField.text!.components(separatedBy: " ");
        let first: String?;
        let last: String?;
        if name.count == 3 {
            first = name[0];
            last = name[1] + " " + name[2];
        } else if name.count == 2 {
            first = name[0];
            last = name[1];
        } else if name.count == 1 {
            first = name[0];
            last = "";
        } else {
            self.statusLabel.textColor = .red;
            self.statusLabel.text = "Enter a valid full name.";
            self.statusLabel.isHidden = false;
            return;
        }
        let em = self.emailField.text!;
        let pass = self.passwordField.text!;
    
        
        // Create a user and save it to the firebase database.
        let user = User(first: first!, last: last!, username: username, email: em);
        user.password = pass;
        user.isPrivate = false;
        OneSignal.syncHashedEmail(em);
        OneSignal.idsAvailable { (userId, pushToken) in
            user.notification_ID = userId!;
        }
        
        
        while usedIds.containsUsername(username: user.profilePicName) {
            user.profilePicName = "";
            user.profilePicName = user.randomName();
        }
        
        usedIds.append(user.profilePicName);
        let _ = FIRDatabase.database().reference().child("UsedIDs").setValue(usedIds);
            
        // Authenticate the user.
        FIRAuth.auth()?.createUser(withEmail: em, password: pass, completion: { (usr: FIRUser?, error: Error?) in
            // No errors creating the user.
            if error == nil {
                
                user.uid = usr!.uid;
                self.fireRef.child("Users").child(user.uid).setValue(user.toDictionary());
                self.debug(message: "User created!");
                
                // Upload an image for the user's profile picture.
                self.uploadProfilePic(user: user, id: user.profilePicName!, profileImage: user.profilepic);
                
                self.dismiss(animated: true, completion: nil);
                let _ = self.navigationController?.popViewController(animated: true);
                
                // Error.
            } else {
                print(error.debugDescription);
            }
        });
    }
    
    
    
    func uploadProfilePic(user: User, id: String, profileImage: UIImage) {
        let storageRef = FIRStorageReference().child("\(user.uid)/\(id).jpg");
        let data = UIImageJPEGRepresentation(profileImage, 100) as NSData?;
        
        let _ = storageRef.put(data! as Data, metadata: nil) { (metaData, error) in
            
            if (error == nil) {
                
                self.debug(message: "Profile Picture Uploaded!");
                
                // Create a post for the database.
                let post = Post(photo: profileImage, caption: "", Uploader: user, ID: id);
                post.isProfilePicture = true;
                post.flags = 0;
                
                let postObj = post.toDictionary();
                self.fireRef.child("Photos").child("\(user.uid)").child("\(id)").setValue(postObj);
                
            } else {
                print(error.debugDescription);
            }
        }
        
    } // End of upload method.

}
