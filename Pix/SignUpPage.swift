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
    
    
    /* The email text field. */
    let emailField: UITextField = {
        let e = UITextField();
        e.translatesAutoresizingMaskIntoConstraints = false;
        e.placeholder = "Email";
        e.backgroundColor = UIColor.white;
        e.textAlignment = .center;
        
        return e;
    }();
    
    
    /* The password text field. */
    let passwordField: UITextField = {
        let p = UITextField();
        p.translatesAutoresizingMaskIntoConstraints = false;
        p.placeholder = "Password";
        p.backgroundColor = UIColor.white;
        p.textAlignment = .center;
        
        return p;
    }();
    
    
    /* The sign up button. */
    let signupButton: UIButton = {
        let s = UIButton();
        s.setTitle("Sign Up", for: .normal);
        s.backgroundColor = UIColor(red: 21/255, green: 180/255, blue: 133/255, alpha: 1);
        s.layer.cornerRadius = 25;
        s.titleLabel?.font = UIFont(name: (s.titleLabel?.font.fontName)!, size: 15);
        
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
        view.addSubview(emailField);
        view.addSubview(passwordField);
        view.addSubview(signupButton);
        
        
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
        emailField.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.top.equalTo(fullnameField.snp.bottom).offset(25);
            maker.width.equalTo(view.width);
            maker.height.equalTo(30);
        }
        passwordField.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.top.equalTo(emailField.snp.bottom).offset(25);
            maker.width.equalTo(view.width);
            maker.height.equalTo(30);
        }
        signupButton.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.centerX.equalTo(view.snp.centerX);
            maker.top.equalTo(passwordField.snp.bottom).offset(25);
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
                    
                    // Get the variables needed to create a user.
                    let name = self.fullnameField.text!;
                    let em = self.emailField.text!;
                    let pass = self.passwordField.text!;
                    
                    
                    // Create a user and save it to the firebase database.
                    let user = User(first: name.substring(i: 0, j: name.indexOf(string: " ")), last: name.substring(i: name.indexOf(string: " ") + 1, j: name.length()), email: em);
                    user.password = pass;
                    
                    
                    // Authenticate the user.
                    FIRAuth.auth()?.createUser(withEmail: em, password: pass, completion: { (usr: FIRUser?, error: Error?) in
                        // No errors creating the user.
                        if error == nil {
                            
                            self.fireRef.child("Users").child(em.substring(i: 0, j: em.indexOf(string: "@"))).setValue(user.toDictionary());
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
            }
        }
    } // End of sign up method.
    
    
    
    func uploadProfilePic(user: User, id: String, profileImage: UIImage) {
        let storageRef = FIRStorageReference().child("\(user.email)/\(id).jpg");
        let data = UIImageJPEGRepresentation(profileImage, 100) as NSData?;
        let emailTrimmed = user.email.substring(i: 0, j: user.email.indexOf(string: "@"));
        
        let _ = storageRef.put(data! as Data, metadata: nil) { (metaData, error) in
            
            if (error == nil) {
                
                self.debug(message: "Profile Picture Uploaded!");
                
                // Create a post for the database.
                let post = Post(photo: profileImage, caption: "", Uploader: user, ID: id);
                post.isProfilePicture = true;
                
                let postObj = post.toDictionary();
                self.fireRef.child("Photos").child("\(emailTrimmed)").child("\(id)").setValue(postObj);
                
            } else {
                print(error.debugDescription);
            }
        }
        
    } // End of upload method.

}
