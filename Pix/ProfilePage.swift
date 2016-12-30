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

class ProfilePage: UICollectionViewController, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    /********************************
     *
     *          VARIABLES
     *
     ********************************/
    
    /* The user to use for displaying data on this profile page.*/
    var useUser: User!;
    
    
    /* The image view that displays the profile picture. */
    let profilePicture: CircleImageView = {
        let i = CircleImageView();
        i.translatesAutoresizingMaskIntoConstraints = false;
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
    
    
    /* A button to follow a user. */
    let followButton: UIButton = {
        let a = UIButton();
        a.setTitle("Follow", for: .normal);
        a.backgroundColor = UIColor(red: 21/255, green: 180/255, blue: 133/255, alpha: 1);
        a.layer.cornerRadius = 20;
        a.titleLabel?.font = UIFont(name: (a.titleLabel?.font.fontName)!, size: 15);
        
        return a;
    }();
    
    
    
    /* The button for logging out. */
    var logoutButton: UIBarButtonItem!;
    
    
    /* Image picker */
    let imgPicker = UIImagePickerController();
    var canChangeProfilePic = false;
    var tap: UITapGestureRecognizer!;
    
    
    /* Firebase reference. */
    let fireRef: FIRDatabaseReference = FIRDatabase.database().reference();
    
    
    
    
    
    
    /********************************
     *
     *           METHODS
     *
     ********************************/
    
    override func viewDidLoad() {
        super.viewDidLoad();
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
        view.addSubview(followButton);
        
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
        followButton.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.centerX.equalTo(view.snp.centerX);
            maker.width.equalTo(view.width / 4.5);
            maker.height.equalTo(35);
            maker.top.equalTo(followingLabel.snp.bottom).offset(5);
        }
        collectionView?.snp.makeConstraints({ (maker: ConstraintMaker) in
            maker.width.equalTo(view.frame.width);
            maker.centerX.equalTo(view);
            maker.top.equalTo(followButton.snp.bottom).offset(10);
            maker.bottom.equalTo(view.snp.bottom);
        })
        
        /* Add the pull to refresh function. */
        var options = PullToRefreshOption();
        options.fixedSectionHeader = false;
        collectionView?.addPullRefresh(options: options, refreshCompletion: { (Void) in
            self.collectionView?.reloadData();
            self.nameLabel.text = "\(self.useUser.firstName) \(self.useUser.lastName)";
            self.followersLabel.text = "Followers: \(self.useUser.followers.count)";
            self.followingLabel.text = "Following: \(self.useUser.following.count)";
            self.profilePicture.image = self.useUser.profilepic;
            self.debug(message: "Size: \(self.useUser.posts.count)");
            
            self.collectionView?.stopPullRefreshEver();
        });
        
        
        /* Bar button item. */
        logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logout));
        logoutButton.tintColor = .white;
        navigationItem.leftBarButtonItem = logoutButton;
        
        
        /* Follow button. */
        followButton.addTarget(self, action: #selector(followUser), for: .touchUpInside);
        
        
        /* Profile pic image picker. */
        imgPicker.delegate = self;
        imgPicker.sourceType = .photoLibrary;
        tap = UITapGestureRecognizer(target: self, action: #selector(uploadProfilePic));
        profilePicture.addGestureRecognizer(tap);
        
        
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
        
        self.reloadLabels();
        
        if canChangeProfilePic == false {
            profilePicture.removeGestureRecognizer(tap);
        } else {
            profilePicture.addGestureRecognizer(tap);
        }
        
    } // End of viewDidAppear().
    
    
    func reloadLabels() {
        nameLabel.text = "\(useUser.firstName) \(useUser.lastName)";
        followersLabel.text = "Followers: \(useUser.followers.count)";
        followingLabel.text = "Following: \(useUser.following.count)";
        profilePicture.image = useUser.profilepic;
    }
    
    
    
    @objc func logout() {
        do {
            try FIRAuth.auth()?.signOut();
            currentUser = nil;
            feedPage.users.removeAll();
            feedPage.usernames.removeAll();
            feedPage.postFeed.removeAll();
            explorePage.listOfUsers.removeAll();
            explorePage.listOfUsers_fb.removeAllObjects();
            self.useUser = nil;
            
            let _ = navigationController?.popToRootViewController(animated: true);
            self.debug(message: "Signed out!");
            self.debug(message: "Logged out!");
        } catch {
            self.debug(message: "There was a problem signing out.");
        }
    }
    
    
    
    /* Makes the current user follow the user on this profile page.
     PRECONDITION: The user being displayed is NOT the current user.
     POSTCONDITION: It is always the CURRENT USER who has this user added to their following, and the useUse who gets the CURRENT USER added to their followers.*/
    @objc func followUser() {
        
        // First, check if the follower/following connection is already there. If not, continue...
        if(!currentUser.following.containsUsername(username: useUser.username) && !useUser.followers.containsUsername(username: currentUser.username)) {
            
            // Set the values of the objects.
            currentUser.following.append(useUser.username);
            useUser.followers.append(currentUser.username);
            
            // Update the button.
            self.followButton.setTitle("Unfollow", for: .normal);
            
            // Update both users in firebase.
            fireRef.child("Users").child(currentUser.username).setValue(currentUser.toDictionary());
            fireRef.child("Users").child(useUser.username).setValue(useUser.toDictionary());
        } else {
            
            // Set the values of the objects.
            currentUser.following.removeItem(item: useUser.username);
            useUser.followers.removeItem(item: currentUser.username);
            
            // Update the button.
            self.followButton.setTitle("Follow", for: .normal);
            
            // Update both users in firebase.
            fireRef.child("Users").child(currentUser.username).setValue(currentUser.toDictionary());
            fireRef.child("Users").child(useUser.username).setValue(useUser.toDictionary());
            
            // Remove all of the photos from the feed page that belong to this user.
            if feedPage.postFeed.count > 0 {
                for post in useUser.posts {
                    feedPage.postFeed.removeItem(item: post);
                }
            }
            
            feedPage.loadPhotos();
        }
        
        // Reload the labels.
        self.reloadLabels();
        
    } // End of followUser() method.
    
    
    
    
    
    
    
    
    
    
    /********************************
     *
     *       IMAGE PICKER
     *
     ********************************/
    
    @objc func uploadProfilePic() {
        show(imgPicker, sender: self);
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let photo = info[UIImagePickerControllerOriginalImage] as? UIImage {
                
                // Set the picture on the image view and also on the actual user object.
                profilePicture.image = photo;
                let id = useUser.profilePicName;
                useUser.profilepic = photo;
                
                
                // Delete the old picture from firebase, and replace it with the new one, but keep the same id.
                let storageRef = FIRStorageReference().child("\(useUser.username)/\(id!).jpg");
                storageRef.delete { error in
                    // If there's an error.
                    if let error = error {
                        self.debug(message: "There was an error deleting the image: \(error)");
                    } else {
                        
                        // Save the new image.
                        let data = UIImageJPEGRepresentation(photo, 100) as NSData?;
                        
                        let _ = storageRef.put(data! as Data, metadata: nil) { (metaData, error) in
                            
                            if (error == nil) {
                                
                                let post = Post(photo: photo, caption: "", Uploader: self.useUser, ID: id!);
                                post.isProfilePicture = true;
                                let postObj = post.toDictionary();
                                self.fireRef.child("Photos").child("\(self.useUser.username)").child("\(id!)").setValue(postObj);
                                self.debug(message: "Old profile picture was removed; replace with new one.");
                                
                            } else {
                                print(error.debugDescription);
                            }
                        }
                        
                    }
                }
                
                
                // Dismiss view controller.
                imgPicker.dismiss(animated: true, completion: nil);
                
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
