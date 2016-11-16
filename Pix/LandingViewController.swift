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

    let titleLabel: UILabel = {
        let label: UILabel = UILabel();
        label.text = "Pix";
        label.textColor = UIColor.white;
        label.translatesAutoresizingMaskIntoConstraints = false;
        
        
        return label;
    }();
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 41/255, green: 200/255, blue: 153/255, alpha: 1)
        
        createElements();
    }

    
    
    func createElements() {
        view.addSubview(titleLabel);
        
        view.addConstraintToFrom(from: titleLabel, attr1: .centerX, relation: .equal, to: view, attr2: .centerX, multiplier: 1, constant: 0);
        view.addConstraintToFrom(from: titleLabel, attr1: .centerY, relation: .equal, to: view, attr2: .centerY, multiplier: 1, constant: 0);
        
    }
    
    
    
}
