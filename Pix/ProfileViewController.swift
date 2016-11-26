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
        img.layer.cornerRadius = 45;
        img.translatesAutoresizingMaskIntoConstraints = false;
        img.backgroundColor = UIColor.lightGray;
        
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
        view.backgroundColor = UIColor(red: 239/255, green: 255/255, blue:245/255, alpha: 1);
        navigationItem.title = "Profile";

        view.addSubview(profilePic);
        view.addSubview(nameLabel);
        
        profilePic.align(.underCentered, relativeTo: (navigationController?.navigationBar)!, padding: 30, width: 90, height: 90);
        nameLabel.align(.underCentered, relativeTo: profilePic, padding: 5, width: view.frame.width, height: 100);
    }




}
