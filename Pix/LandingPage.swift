//
//  LandingPage.swift
//  Pix
//
//  Created by Adeola Uthman on 12/21/16.
//  Copyright © 2016 Adeola Uthman. All rights reserved.
//

import UIKit
import SnapKit
import Firebase
import Spring

class LandingPage: UIViewController {
    
    
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
    
    
    /* The login button. */
    let loginButton: SpringButton = {
        let s = SpringButton();
        s.setTitle("Login", for: .normal);
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
        navigationController?.navigationBar.isHidden = true;
        
        
        /* Set up the view. */
       
        view.addSubview(titleLabel);
        view.addSubview(emailField);
        view.addSubview(passwordField);
        
        let btnView = UIView();
        btnView.addSubview(signupButton);
        btnView.addSubview(loginButton);
        view.addSubview(btnView);
        view.addSubview(statusLabel);
        
        
        titleLabel.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.top.equalTo(view.snp.top).offset(70);
            maker.centerX.equalTo(view.snp.centerX);
        }
        emailField.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.top.equalTo(titleLabel.snp.bottom).offset(25);
            maker.width.equalTo(view.width);
            maker.height.equalTo(30);
        }
        passwordField.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.top.equalTo(emailField.snp.bottom).offset(25);
            maker.width.equalTo(view.width);
            maker.height.equalTo(30);
        }
        statusLabel.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.top.equalTo(passwordField.snp.bottom);
            maker.width.equalTo(view.width);
            maker.height.equalTo(30);
            maker.centerX.equalTo(view.snp.centerX);
        }
        btnView.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.top.equalTo(statusLabel.snp.bottom).offset(25);
            maker.width.equalTo(view.width);
            maker.height.equalTo(100);
        }
        signupButton.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.right.equalTo(btnView.snp.centerX).offset(10);
            maker.top.equalTo(btnView.snp.top);
            maker.width.equalTo(70);
            maker.height.equalTo(45);
        }
        loginButton.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.left.equalTo(btnView.snp.centerX).offset(10);
            maker.top.equalTo(btnView.snp.top);
            maker.width.equalTo(70);
            maker.height.equalTo(45);
        }
        
        
        signupButton.addTarget(self, action: #selector(signUp), for: .touchUpInside);
        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside);
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard));
        view.addGestureRecognizer(tap);
    }
    
    
    
    
    /* Goes to the sign up page. */
    @objc func signUp() {
        let signupPage = SignUpPage();
        show(signupPage, sender: self);
    }
    
    
    
    /* Logs the user in and sends them to the home feed page. */
    @objc func login() {
        loginButton.animateButtonClick();
        
        // Sign in.
        if((self.emailField.text?.length())! > 0 && (self.passwordField.text?.length())! > 0) {
            FIRAuth.auth()?.signIn(withEmail: emailField.text!, password: passwordField.text!, completion: { (usr: FIRUser?, error: Error?) in
            if error != nil {

                print("----------> Wrong Password!");
                self.statusLabel.textColor = UIColor.red;
                self.statusLabel.isHidden = false;
                self.statusLabel.text = "Incorrect password.";
                
            } else {
                // Search in the database for the user with the email that has been entered.
                let emailTrimmed = self.emailField.text!.substring(i: 0, j: self.emailField.text!.indexOf(string: "@"));
                
                self.fireRef.child("Users").child(emailTrimmed).observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as? NSDictionary
                    
                    let first = value?["first_name"] as? String ?? "";
                    let last = value?["last_name"] as? String ?? "";
                    let pass = value?["password"] as? String ?? "";
                    let em = value?["email"] as? String ?? "";
                    
                    let usr = User(first: first, last: last, email: em);
                    usr.password = pass;
                    currentUser = usr;
                    
                    print("----------> Logged in!");
                    self.statusLabel.textColor = UIColor.green;
                    self.statusLabel.isHidden = false;
                    self.statusLabel.text = "Logging In!";
                    
                    self.goToApp();
                    self.loadUsersPhotos();
                });
                print("----------> Signed In!");
            }
        });
            
        } else {
            print("----------> Invalid Credentials!");
            self.statusLabel.textColor = UIColor.red;
            self.statusLabel.isHidden = false;
            self.statusLabel.text = "Invalid Credentials.";
        }
    }
    
    
    
    
    /* Tells the program to take the user to the actually application. */
    private func goToApp() {
        navigationController?.pushViewController(feedPage, animated: false);
    }
    
    
    
    // Close the keyboard
    @objc private func dismissKeyboard() {
        view.endEditing(true);
    }
    
    
    
    private func loadUsersPhotos() {
        //fireRef.child("Photos")
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

}
