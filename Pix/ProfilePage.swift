//
//  ProfilePage.swift
//  Pix
//
//  Created by Adeola Uthman on 12/23/16.
//  Copyright © 2016 Adeola Uthman. All rights reserved.
//

import UIKit
import Foundation
import SnapKit
import Firebase
import Presentr
import PullToRefreshSwift

class ProfilePage: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    
    /********************************
     *
     *          VARIABLES
     *
     ********************************/
    
    /* The user to use for displaying data on this profile page.*/
    var useUser: User!;
    
    
    /* The image view that displays the profile picture. */
    let profilePicture: UIImageView = {
        let i = UIImageView();
        i.translatesAutoresizingMaskIntoConstraints = false;
        i.layer.cornerRadius = 45;
        i.isUserInteractionEnabled = true;
        i.backgroundColor = UIColor.gray;
        
        return i;
    }();
    
    
    /* Label that shows the user's name. */
    let nameLabel: UILabel = {
        let n = UILabel();
        n.translatesAutoresizingMaskIntoConstraints = false;
        n.isUserInteractionEnabled = false;
        n.font = UIFont(name: n.font.fontName, size: 20);
        n.textColor = UIColor.black;
        n.textAlignment = .center;
        
        return n;
    }();
    
    
    /* Label that shows the number of followers this user has. */
    let followersLabel: UILabel = {
        let n = UILabel();
        n.translatesAutoresizingMaskIntoConstraints = false;
        n.isUserInteractionEnabled = false;
        n.font = UIFont(name: n.font.fontName, size: 15);
        n.textColor = UIColor.black;
        n.textAlignment = .center;
        
        return n;
    }();
    
    
    /* Label that shows the number of people this user is following. */
    let followingLabel: UILabel = {
        let n = UILabel();
        n.translatesAutoresizingMaskIntoConstraints = false;
        n.isUserInteractionEnabled = false;
        n.font = UIFont(name: n.font.fontName, size: 15);
        n.textColor = UIColor.black;
        n.textAlignment = .center;
        
        return n;
    }();
    
    
    /* The button for logging out. */
    var logoutButton: UIBarButtonItem!;
    
    
    
    
    /********************************
     *
     *           METHODS
     *
     ********************************/
    
    override func viewDidLoad() {
        super.viewDidLoad();
        //useUser = currentUser;
        view.backgroundColor = UIColor(red: 239/255, green: 255/255, blue:245/255, alpha: 1);
        navigationController?.navigationBar.isHidden = false;
        navigationItem.hidesBackButton = true;
        navigationItem.title = "Profile";
        setupCollectionView();
        
        
        /* Setup/Layout the view. */
        view.addSubview(profilePicture);
        view.addSubview(nameLabel);
        view.addSubview(followersLabel);
        view.addSubview(followingLabel);
        
        profilePicture.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.centerX.equalTo(view.snp.centerX);
            maker.bottom.equalTo(view.snp.centerY).offset(-100);
            maker.width.equalTo(90);
            maker.height.equalTo(90);
        }
        nameLabel.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.centerX.equalTo(view.snp.centerX);
            maker.width.equalTo(view.width);
            maker.height.equalTo(25);
            maker.top.equalTo(profilePicture.snp.bottom).offset(20);
        }
        followersLabel.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.centerX.equalTo(view.snp.centerX);
            maker.width.equalTo(view.width);
            maker.height.equalTo(20);
            maker.top.equalTo(nameLabel.snp.bottom).offset(10);
        }
        followingLabel.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.centerX.equalTo(view.snp.centerX);
            maker.width.equalTo(view.width);
            maker.height.equalTo(20);
            maker.top.equalTo(followersLabel.snp.bottom).offset(5);
        }
        collectionView?.snp.makeConstraints({ (maker: ConstraintMaker) in
            maker.width.equalTo(view.frame.width);
            maker.centerX.equalTo(view);
            maker.top.equalTo(followingLabel.snp.bottom).offset(10);
            maker.bottom.equalTo(view.snp.bottom);
        })
        
        
        /* Add the pull to refresh function. */
        var options = PullToRefreshOption();
        options.fixedSectionHeader = false;
        collectionView?.addPullRefresh(options: options, refreshCompletion: { (Void) in
            self.collectionView?.reloadData();
            self.debug(message: "Size: \(self.useUser.posts.count)");
            self.collectionView?.stopPullRefreshEver();
        });
        
        
        logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logout));
        logoutButton.tintColor = .white;
        navigationItem.leftBarButtonItem = logoutButton;
        
    } // End of viewDidLoad().
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        collectionView?.reloadData();
        
        if useUser !== currentUser {
            logoutButton.isEnabled = false;
            logoutButton.tintColor = navigationController?.navigationBar.barTintColor;
        } else {
            logoutButton.isEnabled = true;
            logoutButton.tintColor = .white;
        }
        
        nameLabel.text = "\(useUser.firstName) \(useUser.lastName)";
        followersLabel.text = "Followers: \(useUser.followers.count)";
        followingLabel.text = "Following: \(useUser.following.count)";
    } // End of viewDidAppear().
    
    
    
    @objc func logout() {
        do {
            try FIRAuth.auth()?.signOut();
            currentUser = nil;
            let _ = navigationController?.popToRootViewController(animated: true);
            self.debug(message: "Signed out!");
            self.debug(message: "Logged out!");
        } catch {
            self.debug(message: "There was a problem signing out.");
        }
    }
    
    
    
    
    
    /********************************
     *
     *       COLLECTION VIEW
     *
     ********************************/
    
    func setupCollectionView() {
        collectionView?.register(ProfilePageCell.self, forCellWithReuseIdentifier: "Cell");
        collectionView?.backgroundColor = view.backgroundColor;
        collectionView?.alwaysBounceVertical = true;
        collectionView?.delegate = self;
        collectionView?.dataSource = self;
    }
    
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return useUser.posts.count;
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ProfilePageCell;
        
        cell.imageView.image = useUser.posts[indexPath.item].photo.image!;
        cell.setup();
    
        return cell;
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 90, height: 90);
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10;
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let presenter: Presentr = {
            let pres = Presentr(presentationType: .popup);
            pres.dismissOnSwipe = true;
            pres.dismissAnimated = true;
            return pres;
        }();
        
        let detailView = PostDetailPage();
        detailView.setup(post: useUser.posts[indexPath.item]);
        
        customPresentViewController(presenter, viewController: detailView, animated: true, completion: nil);
    }
    
}
