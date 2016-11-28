//
//  ProfileViewController.swift
//  Pix
//
//  Created by Adeola Uthman on 11/25/16.
//  Copyright © 2016 Adeola Uthman. All rights reserved.
//

import UIKit
import Neon
import DZNEmptyDataSet

class ProfileViewController: UIViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {

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
        l.text = currentUser.firstName + " " + currentUser.lastName;    // By the time you get here, current user will not be nil
        l.textAlignment = .center;
        
        return l;
    }();
    
    
    // The label that says followers
    let followersLabel: UILabel = {
        let l = UILabel();
        l.translatesAutoresizingMaskIntoConstraints = false;
        l.text = "Followers: \(currentUser.followers.count)";
        l.textAlignment = .center;
        
        return l;
    }();
    
    
    // The label that says followers
    let followingLabel: UILabel = {
        let l = UILabel();
        l.translatesAutoresizingMaskIntoConstraints = false;
        l.text = "Following: \(currentUser.following.count)";
        l.textAlignment = .center;
        
        return l;
    }();
    
    
    // The collection view that displays all of the user's photos.
    var photosCollectionView: UICollectionView!
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 239/255, green: 255/255, blue:245/255, alpha: 1);
        navigationItem.title = "Profile";
        setupCollectionView();
        
        view.addSubview(profilePic);
        view.addSubview(nameLabel);
        view.addSubview(followersLabel);
        view.addSubview(followingLabel);
        view.addSubview(photosCollectionView);
        
        profilePic.align(.underCentered, relativeTo: (navigationController?.navigationBar)!, padding: 30, width: 90, height: 90);
        nameLabel.align(.underCentered, relativeTo: profilePic, padding: 10, width: view.frame.width, height: 20);
        followersLabel.align(.underCentered, relativeTo: nameLabel, padding: 0, width: view.frame.width, height: 20);
        followingLabel.align(.underCentered, relativeTo: followersLabel, padding: 0, width: view.frame.width, height: 20);
        photosCollectionView.anchorAndFillEdge(.bottom, xPad: 0, yPad: 0, otherSize: 300);
    }

    


    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout();
        layout.scrollDirection = .vertical;
        
        photosCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 300), collectionViewLayout: layout);
        photosCollectionView.backgroundColor = view.backgroundColor;
        photosCollectionView.backgroundColor = UIColor.blue;
        photosCollectionView.emptyDataSetDelegate = self;
        photosCollectionView.emptyDataSetSource = self;
    }
    
    
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let s = NSAttributedString(string: "No photos to display.");
        return s;
    }
}
