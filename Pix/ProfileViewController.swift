//
//  ProfileViewController.swift
//  Pix
//
//  Created by Adeola Uthman on 11/25/16.
//  Copyright © 2016 Adeola Uthman. All rights reserved.
//

import UIKit
import Neon

class ProfileViewController: UIViewController {

    // The user's profile picture.
    let profilePic: UIImageView = {
        let img = UIImageView();
        img.layer.cornerRadius = 25;
        img.translatesAutoresizingMaskIntoConstraints = false;
        
        return img;
    }();
    
    
    // The label that displays the user's name
    let nameLabel: UILabel = {
        let l = UILabel();
        l.translatesAutoresizingMaskIntoConstraints = false;
        l.text = currentUser.firstName + " " + currentUser.lastName;
        l.textAlignment = .center;
        
        return l;
    }();
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.green;

        view.addSubview(profilePic);
        view.addSubview(nameLabel);
        
        profilePic.anchorToEdge(.top, padding: 20, width: 100, height: 100);
        nameLabel.align(.underCentered, relativeTo: profilePic, padding: 10, width: view.frame.width, height: 100);
    }




}
