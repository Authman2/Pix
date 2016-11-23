//
//  LandingViewController.swift
//  Pix
//
//  Created by Adeola Uthman on 11/16/16.
//  Copyright © 2016 Adeola Uthman. All rights reserved.
//

import UIKit
import Neon

class LandingViewController: UIViewController {

    ////////////////////////
    ///
    ///
    /// Variables
    ///
    ///
    ////////////////////////

    // Displays the naem of the app
    let titleLabel: UILabel = {
        let label: UILabel = UILabel();
        label.text = "Pix";
        label.textColor = UIColor.white;
        label.translatesAutoresizingMaskIntoConstraints = false;
        label.font = UIFont.boldSystemFont(ofSize: 35);
        label.textAlignment = .center;
        
        return label;
    }();
    
    
    // Enter the user's email
    let emailField: UITextField = {
        let eField: UITextField = UITextField();
        eField.placeholder = "Email";
        eField.translatesAutoresizingMaskIntoConstraints = false;
        eField.backgroundColor = UIColor.white;
        eField.textAlignment = .center;
        
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
        
        return pass;
    }();
    
    
    // Enter the user's full name (only visible when trying to sign up).
    let fullNameField: UITextField = {
        let fnf: UITextField = UITextField();
        fnf.placeholder = "Full Name";
        fnf.isSecureTextEntry = true;
        fnf.translatesAutoresizingMaskIntoConstraints = false;
        fnf.backgroundColor = UIColor.white;
        fnf.textAlignment = .center;
        fnf.isHidden = true;
        
        return fnf;
    }();
    
    
    // A button to create a new account
    let signUpBtn: UIButton = {
        let btn: UIButton = UIButton();
        btn.setTitle("Sign Up", for: .normal);
        btn.backgroundColor = UIColor(red: 21/255, green: 180/255, blue: 133/255, alpha: 1);
        btn.layer.cornerRadius = 25;
        btn.titleLabel?.font = UIFont(name: (btn.titleLabel?.font.fontName)!, size: 15);
        
        return btn;
    }();
    
    
    // A button to login
    let loginBtn: UIButton = {
        let btn: UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50));
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

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 41/255, green: 200/255, blue: 153/255, alpha: 1);
        
        // Add all the necessary elements on screen.
        layoutElements();
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(LandingViewController.dismissKeyboard));
        view.addGestureRecognizer(tap);
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
}
