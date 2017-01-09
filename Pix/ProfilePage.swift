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
import PullToRefreshSwift
import OneSignal
import IGListKit

class ProfilePage: UIViewController, IGListAdapterDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    /********************************
     *
     *          VARIABLES
     *
     ********************************/
    
    /* The user to use for displaying data on this profile page.*/
    var useUser: User!;
    
    
    /* The adapter. */
    lazy var adapter: IGListAdapter = {
        return IGListAdapter(updater: IGListAdapterUpdater(), viewController: self, workingRangeSize: 1);
    }();
    
    
    /* The collection view. */
    let collectionView: IGListCollectionView = {
        let layout = IGListGridCollectionViewLayout();
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        let view = IGListCollectionView(frame: CGRect.zero, collectionViewLayout: layout);
        view.alwaysBounceVertical = true;
        
        return view;
    }();
    
    
    /* The image view that displays the profile picture. */
    let profilePicture: CircleImageView = {
        let i = CircleImageView();
        i.translatesAutoresizingMaskIntoConstraints = false;
        i.isUserInteractionEnabled = true;
        i.backgroundColor = UIColor.gray;
        
        return i;
    }();
    
    
    /* A label to display whether or not this user is private. */
    let privateLabel: UILabel = {
        let a = UILabel();
        a.translatesAutoresizingMaskIntoConstraints = false;
        a.isUserInteractionEnabled = false;
        a.font = UIFont(name: a.font.fontName, size: 15);
        a.numberOfLines = 0;
        a.textColor = UIColor(red: 21/255, green: 180/255, blue: 133/255, alpha: 1).lighter();
        a.textAlignment = .center;
        a.isHidden = true;
        
        return a;
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
    
    
    /* The button used for editing the profile. */
    var editProfileButton: UIBarButtonItem!;
    
    
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
        view.addSubview(collectionView)
        
        
        /* Setup/Layout the view. */
        view.addSubview(privateLabel);
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
        privateLabel.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.centerX.equalTo(view.snp.centerX);
            maker.bottom.equalTo(profilePicture.snp.top).offset(-10);
            maker.width.equalTo(view.width);
            maker.height.equalTo(50);
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
            maker.width.equalTo(view.width / 4.2);
            maker.height.equalTo(35);
            maker.top.equalTo(followingLabel.snp.bottom).offset(5);
        }
        collectionView.snp.makeConstraints({ (maker: ConstraintMaker) in
            maker.width.equalTo(view.frame.width);
            maker.centerX.equalTo(view);
            maker.top.equalTo(followButton.snp.bottom).offset(10);
            maker.bottom.equalTo(view.snp.bottom);
        })
        
        /* Add the pull to refresh function. */
        var options = PullToRefreshOption();
        options.fixedSectionHeader = false;
        collectionView.addPullRefresh(options: options, refreshCompletion: { (Void) in
            self.adapter.performUpdates(animated: true, completion: nil);
            self.reloadLabels();
            
            self.collectionView.stopPullRefreshEver();
        });
        
        
        /* Bar button item. */
        logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logout));
        logoutButton.tintColor = .white;
        navigationItem.leftBarButtonItem = logoutButton;
        editProfileButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editProfile));
        editProfileButton.tintColor = .white;
        navigationItem.rightBarButtonItem = editProfileButton;
        
        
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
        self.adapter.performUpdates(animated: true, completion: nil);
        
        if useUser !== currentUser {
            logoutButton.isEnabled = false;
            logoutButton.tintColor = navigationController?.navigationBar.barTintColor;
            editProfileButton.isEnabled = false;
            editProfileButton.tintColor = navigationController?.navigationBar.barTintColor;
        } else {
            logoutButton.isEnabled = true;
            logoutButton.tintColor = .white;
            editProfileButton.isEnabled = true;
            editProfileButton.tintColor = .white;
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
        
        privateLabel.text = "\(useUser.username) is private. Send a follow request to see their photos.";
        if useUser !== currentUser {
            if useUser.isPrivate == false || (useUser.isPrivate == true && currentUser.following.containsUsername(username: profilePage.useUser.uid)) {
                privateLabel.isHidden = true;
                collectionView.isHidden = false;
            } else {
                privateLabel.isHidden = false;
                collectionView.isHidden = true;
            }
        }
        
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
    
    
    @objc func editProfile() {
        navigationController?.pushViewController(EditProfilePage(), animated: true);
    }
    
    
    
    /* Makes the current user follow the user on this profile page.
     PRECONDITION: The user being displayed is NOT the current user.
     POSTCONDITION: It is always the CURRENT USER who has this user added to their following, and the useUse who gets the CURRENT USER added to their followers.*/
    @objc func followUser() {
        
        // First, check if the follower/following connection is already there. If not, continue...
        if(!currentUser.following.containsUsername(username: useUser.uid) && !useUser.followers.containsUsername(username: currentUser.uid)) {
            
            // If the user is not private then just follow them. Otherwise send a follow request. 
            if useUser.isPrivate == false {
                
                self.acceptFollowRequest(user: useUser, followDirection: .fromTo);
                
            } else {
            
                if followButton.titleLabel?.text != "Requested" && followButton.titleLabel?.text != "Unfollow" {
                    
                    // Update the button.
                    self.followButton.setTitle("Requested", for: .normal);
                    
                    // Send a follow request.
                    if(useUser.notification_ID != currentUser.notification_ID) {
                        OneSignal.postNotification(["contents": ["en": "\(currentUser.username) wants to follow you!"], "include_player_ids": ["\(useUser.notification_ID)"]], onSuccess: { (dict: [AnyHashable : Any]?) in
                            
                            self.debug(message: "Follow request notification was sent!");
                            
                        }, onFailure: { (error: Error?) in
                            self.debug(message: "There was an error sending the notification.");
                        })
                    }
                }
            }
            
        } else {
            
            // Set the values of the objects.
            currentUser.following.removeItem(item: useUser.uid);
            useUser.followers.removeItem(item: currentUser.uid);
            
            // Update the button.
            self.followButton.setTitle("Follow", for: .normal);
            
            // Update both users in firebase.
            fireRef.child("Users").child(currentUser.uid).setValue(currentUser.toDictionary());
            fireRef.child("Users").child(useUser.uid).setValue(useUser.toDictionary());
            
            // Remove all of the photos from the feed page that belong to this user.
            if feedPage.postFeed.count > 0 {
                for post in useUser.posts {
                    feedPage.postFeed.removeItem(item: post);
                }
            }
            
            //feedPage.loadPhotos();
        }
        
        // Reload the labels.
        self.reloadLabels();
        
    } // End of followUser() method.
    
    
    
    public func acceptFollowRequest(user: User, followDirection: followDirection) {
        // Make sure it is not the same user.
        if user !== currentUser || user.uid != currentUser.uid {
            
            // Set the values of the objects.
            if followDirection == .toFrom {
                currentUser.followers.append(user.uid);
                user.following.append(currentUser.uid);
            } else {
                currentUser.following.append(user.uid);
                user.followers.append(currentUser.uid);
            }
            
            // Update the button.
            self.followButton.setTitle("Unfollow", for: .normal);
            
            // Update both users in firebase.
            fireRef.child("Users").child(currentUser.uid).setValue(currentUser.toDictionary());
            fireRef.child("Users").child(user.uid).setValue(user.toDictionary());
            
            // Send notification.
            if(user.notification_ID != currentUser.notification_ID) {
                OneSignal.postNotification(["contents": ["en": "\(currentUser.username) started following you!"], "include_player_ids": ["\(user.notification_ID)"]], onSuccess: { (dict: [AnyHashable : Any]?) in
                    
                    self.debug(message: "Follow notification was sent!");
                    
                }, onFailure: { (error: Error?) in
                    self.debug(message: "There was an error sending the notification.");
                })
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
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
                let storageRef = FIRStorageReference().child("\(useUser.uid)/\(id!).jpg");
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
                                self.fireRef.child("Photos").child("\(self.useUser.uid)").child("\(id!)").setValue(postObj);
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
        collectionView.register(ProfilePageCell.self, forCellWithReuseIdentifier: "Cell");
        collectionView.backgroundColor = view.backgroundColor;
        
        adapter.collectionView = collectionView;
        adapter.dataSource = self;
    }
    
    
    func objects(for listAdapter: IGListAdapter) -> [IGListDiffable] {
        return useUser.posts;
    }
    
    func listAdapter(_ listAdapter: IGListAdapter, sectionControllerFor object: Any) -> IGListSectionController {
        return ProfileSectionController(vc: self);
    }
    
    func emptyView(for listAdapter: IGListAdapter) -> UIView? {
        return EmptyPhotoView();
    }
    
}
