//
//  LandingViewController.swift
//  Pix
//
//  Created by Adeola Uthman on 11/16/16.
//  Copyright © 2016 Adeola Uthman. All rights reserved.
//

import UIKit

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
    
    
    // A button to create a new account
    let signUpBtn: UIButton = {
        let btn: UIButton = UIButton();
        btn.titleLabel?.text = "Sign Up";
        btn.backgroundColor = UIColor(red: 21/255, green: 180/255, blue: 133/255, alpha: 1);
        
        return btn;
    }();
    
    
    // A button to login
    let loginBtn: UIButton = {
        let btn: UIButton = UIButton();
        btn.titleLabel?.text = "Login";
        btn.backgroundColor = UIColor(red: 21/255, green: 180/255, blue: 133/255, alpha: 1);
        
        return btn;
    }();
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 41/255, green: 200/255, blue: 153/255, alpha: 1);
        
        // Add all the necessary elements on screen.
        createElements();
    }

    
    
    func createElements() {
        // Setup stack views to hold the elements.
        let stackView = UIStackView();
        stackView.addArrangedSubview(titleLabel);
        stackView.addArrangedSubview(emailField);
        stackView.addArrangedSubview(passwordField);
        
        let btnStackView = UIStackView();
        btnStackView.addArrangedSubview(signUpBtn);
        btnStackView.addArrangedSubview(loginBtn);
        
        let everythingStackView = UIStackView();
        everythingStackView.addArrangedSubview(stackView);
        everythingStackView.addArrangedSubview(btnStackView);
        
        
        // Edit some stack view properties
        stackView.axis = .vertical;
        stackView.translatesAutoresizingMaskIntoConstraints = false;
        stackView.alignment = .center;
        stackView.spacing = 20;
        
        btnStackView.axis = .horizontal;
        btnStackView.translatesAutoresizingMaskIntoConstraints = false;
        btnStackView.alignment = .center;
        btnStackView.spacing = 20;
        
        everythingStackView.axis = .vertical;
        everythingStackView.translatesAutoresizingMaskIntoConstraints = false;
        everythingStackView.alignment = .center;
        
        
        // Do layout stuff
        view.addSubview(everythingStackView);
        
        view.addConstraintToFrom(from: stackView, attr1: .centerY, relation: .equal, to: view, attr2: .centerY, multiplier: 0.5, constant: 0);
        
        view.addConstraintToFrom(from: emailField, attr1: .width, relation: .equal, to: view, attr2: .width, multiplier: 1, constant: 0);
        view.addConstraintToFrom(from: passwordField, attr1: .width, relation: .equal, to: view, attr2: .width, multiplier: 1, constant: 0);
        view.addConstraintToFrom(from: emailField, attr1: .height, relation: .equal, to: view, attr2: .height, multiplier: 0.05, constant: 0);
        view.addConstraintToFrom(from: passwordField, attr1: .height, relation: .equal, to: view, attr2: .height, multiplier: 0.05, constant: 0);
        
        view.addConstraintToFrom(from: everythingStackView, attr1: .centerX, relation: .equal, to: view, attr2: .centerX, multiplier: 1, constant: 0);
        view.addConstraintToFrom(from: everythingStackView, attr1: .centerY, relation: .equal, to: view, attr2: .centerY, multiplier: 0.75, constant: 0);
    }
    
    
    
}
