//
//  TermsOfServicePage.swift
//  Pix
//
//  Created by Adeola Uthman on 1/9/17.
//  Copyright © 2017 Adeola Uthman. All rights reserved.
//

import Foundation
import UIKit
import Neon


var acceptedTerms = false;

class TermsOfServicePage: UIViewController {
    
    
    /********************************
     *
     *          VARIABLES
     *
     ********************************/
    
    let firstLabel: UILabel = {
        let a = UILabel();
        a.translatesAutoresizingMaskIntoConstraints = false;
        a.textAlignment = .center;
        a.text = "Welcome to Pix, an easy to use photo sharing application. Please review the terms below and click accept to continue using the app.";
        a.textColor = UIColor(red: 41/255, green: 200/255, blue: 153/255, alpha: 1);
        a.numberOfLines = 0;
        
        return a;
    }();
    
    let textField: UITextView = {
        let a = UITextView();
        a.translatesAutoresizingMaskIntoConstraints = false;
        a.isUserInteractionEnabled = false;
        a.text = terms;
        a.backgroundColor = .white;
        a.textAlignment = .left;
        a.font = UIFont(name: (a.font?.fontName)!, size: 15);
        
        return a;
    }();
    
    let button: UIButton = {
        let a = UIButton();
        a.translatesAutoresizingMaskIntoConstraints = false;
        a.setTitle("Accept", for: .normal);
        a.setTitleColor(UIColor(red: 41/255, green: 200/255, blue: 153/255, alpha: 1), for: .normal);
        
        return a;
    }();
    
    
    
    /********************************
     *
     *          METHODS
     *
     ********************************/
    
    override func viewDidLoad() {
        super.viewDidLoad();
        view.backgroundColor = UIColor(red: 239/255, green: 255/255, blue:245/255, alpha: 1);
        
        view.addSubview(firstLabel);
        view.addSubview(textField);
        view.addSubview(button);
        
        firstLabel.anchorToEdge(.top, padding: 10, width: view.width, height: 100);
        textField.align(.underCentered, relativeTo: firstLabel, padding: 10, width: view.width, height: view.height - 180);
        button.align(.underMatchingRight, relativeTo: textField, padding: 10, width: 100, height: 50);
        
        button.addTarget(self, action: #selector(acceptTerms), for: .touchUpInside);
    }
    
    
    
    @objc func acceptTerms() {
        UserDefaults.standard.setValue(true, forKey: "accepted_terms");
        let _ = navigationController?.popViewController(animated: true);
    }
    
}


var terms = "Terms: \n- Must be at least 12 years of age.\n- You are responsible for any and all activity on your account.\n- You are prohibited from posting any sexually suggestive photos.\n- Any form of bullying or harassment is also prohibited.\n- You may not use Pix for any illegal activity.\n- All posts made on the app belong solely to the user who uploaded them.\n\n- Pix reserves the right to cancel an account at any given moment.\n- We reserve the right to update these terms at any time.\n- We reserve the right to remove any material that we deem offensive, threatening, or that violates any of our terms of use.";




