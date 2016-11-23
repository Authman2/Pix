//
//  LandingViewController.swift
//  Pix
//
//  Created by Adeola Uthman on 11/16/16.
//  Copyright © 2016 Adeola Uthman. All rights reserved.
//

import UIKit
import Neon
import Spring
import Firebase



/// The current user. Global constant.
var currentUser: User = User();




class LandingViewController: UIViewController {

    
    ////////////////////////
    ///
    ///
    /// Variables
    ///
    ///
    ////////////////////////
    
    // The reference to the Firebase database
    var ref: FIRDatabaseReference! = FIRDatabase.database().reference();

    
    // Displays the name of the app
    let titleLabel: UILabel = {
        let label: UILabel = UILabel();
        label.text = "Pix";
        label.textColor = UIColor.white;
        label.translatesAutoresizingMaskIntoConstraints = false;
        label.font = UIFont.boldSystemFont(ofSize: 35);
        label.textAlignment = .center;
        label.isUserInteractionEnabled = false;
        
        return label;
    }();
    
    
    // Enter the user's email
    let emailField: UITextField = {
        let eField: UITextField = UITextField();
        eField.placeholder = "Email";
        eField.translatesAutoresizingMaskIntoConstraints = false;
        eField.backgroundColor = UIColor.white;
        eField.textAlignment = .center;
        eField.autocapitalizationType = .none;
        eField.autocorrectionType = .no;
        
        return eField;
    }();
    
    
    // Enter the user's password
    let passwordField: UITextField = {
        let pass: UITextField = UITextField();
        pass.placeholder = "Password";
        pass.isSecureTextEntry = true;
        pass.translatesAutoresizingMaskIntoConstraints = false;
        pass.backgroundColor = UIColor.white;
        pass.textAlignment = .center;
        pass.autocorrectionType = .no;
        pass.autocapitalizationType = .none;
        
        return pass;
    }();
    
    
    // Enter the user's full name (only visible when trying to sign up).
    let fullNameField: UITextField = {
        let fnf: UITextField = UITextField();
        fnf.placeholder = "Full Name";
        fnf.translatesAutoresizingMaskIntoConstraints = false;
        fnf.backgroundColor = UIColor.white;
        fnf.textAlignment = .center;
        fnf.isHidden = true;
        fnf.autocapitalizationType = .none;
        fnf.autocorrectionType = .no;
        
        return fnf;
    }();
    
    
    // A button to create a new account
    let signUpBtn: SpringButton = {
        let btn: SpringButton = SpringButton();
        btn.setTitle("Sign Up", for: .normal);
        btn.backgroundColor = UIColor(red: 21/255, green: 180/255, blue: 133/255, alpha: 1);
        btn.layer.cornerRadius = 25;
        btn.titleLabel?.font = UIFont(name: (btn.titleLabel?.font.fontName)!, size: 15);
        
        return btn;
    }();
    
    
    // A button to login
    let loginBtn: SpringButton = {
        let btn: SpringButton = SpringButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50));
        btn.setTitle("Login", for: .normal);
        btn.backgroundColor = UIColor(red: 21/255, green: 180/255, blue: 133/255, alpha: 1);
        btn.layer.cornerRadius = 25;
        btn.titleLabel?.font = UIFont(name: (btn.titleLabel?.font.fontName)!, size: 15);
        
        return btn;
    }();
    
    
    
    
    
    
    
    
    
    
    
    ////////////////////////
    ///
    ///
    /// Methods
    ///
    ///
    ////////////////////////

    
    
    // Standard viewDidLoad method.
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 41/255, green: 200/255, blue: 153/255, alpha: 1);
        
        // Add all the necessary elements on screen.
        layoutElements();
        
        
        // Add a tap recognizer
        let tap = UITapGestureRecognizer(target: self, action: #selector(LandingViewController.dismissKeyboard));
        view.addGestureRecognizer(tap);
        
        
        // Add the button functions
        signUpBtn.addTarget(self, action: #selector(LandingViewController.signUp), for: .touchUpInside);
        loginBtn.addTarget(self, action: #selector(LandingViewController.login), for: .touchUpInside);
    }

    
    
    // Creating and layouting out the view elements.
    func layoutElements() {
        view.addSubview(titleLabel);
        view.addSubview(emailField);
        view.addSubview(passwordField);
        view.addSubview(fullNameField);
        
        // A view for the buttons
        let btnView = UIView();
        btnView.addSubview(signUpBtn);
        btnView.addSubview(loginBtn);
        view.addSubview(btnView);
        
        
        let padding: CGFloat = 25;
        let formHeight: CGFloat = 35;
        
        
        // Use Neon to align them.
        titleLabel.anchorAndFillEdge(.top, xPad: 0, yPad: 50, otherSize: AutoHeight);
        
        emailField.align(.underCentered, relativeTo: titleLabel, padding: padding, width: view.frame.width, height: formHeight);
        passwordField.align(.underCentered, relativeTo: emailField, padding: padding, width: view.frame.width, height: formHeight);
        fullNameField.align(.underCentered, relativeTo: passwordField, padding: padding, width: view.frame.width, height: formHeight);
        
        btnView.align(.underCentered, relativeTo: fullNameField, padding: padding - 5, width: view.frame.width, height: 50);
        btnView.groupInCenter(group: .horizontal, views: [signUpBtn, loginBtn], padding: 20, width: 70, height: 50);
    }
    
    
    
    
    // Close the keyboard
    @objc private func dismissKeyboard() {
        view.endEditing(true);
    }
    
    
    
    // Sign up for a new account. First show the full name area, then actually sign up.
    @objc private func signUp() {
        signUpBtn.animation = "pop";
        signUpBtn.curve = "spring";
        signUpBtn.duration = 1.0;
        signUpBtn.animate();
        
        // First time clicking? Show full name field.
        if(fullNameField.isHidden) {
            fullNameField.alpha = 0;
            fullNameField.isHidden = false;
            
            UIView.animate(withDuration: 0.3, animations: {
                
                self.fullNameField.alpha = 1;
                
            }, completion: nil);
        
        
        } else {
        
        
            // Second time clicking? Actually create an account and login.
            FIRAuth.auth()?.createUser(withEmail: emailField.text!, password: passwordField.text!, completion: { (user: FIRUser?, error: Error?) in

                if(error == nil) {
                    var name = self.fullNameField.text!;
                    let usr = User();
                    usr.firstName = name.substring(i: 0, j: name.indexOf(string: " "));
                    usr.lastName = name.substring(i: name.indexOf(string: " ") + 1 , j: name.length());
                    usr.email = self.emailField.text!;
                    usr.password = self.passwordField.text!;
                    usr.id = user?.uid;
                    
                    self.addUserToDatabase(user: usr);
                    print("CREATED ACCOUNT!");
                    self.login();
                } else {
                    print(error.debugDescription);
                }
            });
        }
    }
    
    
    
    
    // Login to the app.
    @objc private func login() {
        loginBtn.animation = "pop";
        loginBtn.curve = "spring";
        loginBtn.duration = 1.0;
        loginBtn.animate();
        
        
        ref.child("Users").child(emailField.text!.substring(i: 0, j: emailField.text!.length() - 4)).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let firstName = value?["first_name"] as? String ?? "";
            let lastName = value?["last_name"] as? String ?? "";
            let userID = value?["id"] as? String ?? "";
            let user = User(firstName: firstName, lastName: lastName, email: self.emailField.text! + ".com");
            user.password = value?["password"] as? String ?? "";
            user.id = userID;
            
            
            
            if value?["password"] as? String == self.passwordField.text! {
                currentUser = user;
                
                print("LOGGED IN!");
                print(currentUser.firstName);
                print(currentUser.lastName);
                print(currentUser.email);
                print(currentUser.password);
                print(currentUser.id);
            } else {
                print("WRONG PASSWORD");
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    
    
    
    
    // Adds a node for the users
    private func addUserToDatabase(user: User) {
        let emailData = user.email.substring(i: 0, j: user.email.length() - 4);
        
        ref.child("Users").child(emailData).child("first_name").setValue(user.firstName);
        ref.child("Users").child(emailData).child("last_name").setValue(user.lastName);
        ref.child("Users").child(emailData).child("password").setValue(user.password);
        ref.child("Users").child(emailData).child("id").setValue(user.id);

        print(user.firstName);
        print(user.lastName);
        print(user.email);
        print(user.password);
        print(user.id);
    }
    
    
    
    
}
