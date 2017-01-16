//
//  OtherProfilePage.swift
//  Pix
//
//  Created by Adeola Uthman on 1/15/17.
//  Copyright © 2017 Adeola Uthman. All rights reserved.
//

import UIKit
import Foundation
import SnapKit
import Firebase
import PullToRefreshSwift
import OneSignal
import IGListKit

class OtherProfilePage: UIViewController, IGListAdapterDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
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
    var backButton: UIBarButtonItem!;
    
    
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
            
            //self.adapter.performUpdates(animated: true, completion: nil);
            self.adapter.reloadData(completion: { (b: Bool) in
                self.reloadLabels();
                self.collectionView.stopPullRefreshEver();
            })
        });
        
        /* Bar button item. */
        backButton = UIBarButtonItem(title: "< Back", style: .plain, target: self, action: #selector(goBack));
        backButton.tintColor = .white;
        navigationItem.leftBarButtonItem = backButton;
        
        
        /* Follow button. */
        followButton.addTarget(self, action: #selector(followUser), for: .touchUpInside);
        
        
    } // End of viewDidLoad().
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        self.adapter.performUpdates(animated: true, completion: nil);
        
        backButton.isEnabled = true;
        backButton.tintColor = .white;
            
        self.reloadLabels();
        
    } // End of viewDidAppear().
    
    
    func reloadLabels() {
        nameLabel.text = "\(useUser.firstName) \(useUser.lastName)";
        followersLabel.text = "Followers: \(useUser.followers.count)";
        followingLabel.text = "Following: \(useUser.following.count)";
        profilePicture.image = useUser.profilepic;
        
        privateLabel.text = "\(useUser.username) is private. Send a follow request to see their photos.";
        if useUser.isPrivate == false || (useUser.isPrivate == true && currentUser.following.containsUsername(username: useUser.uid)) {
            privateLabel.isHidden = true;
            collectionView.isHidden = false;
        } else {
            privateLabel.isHidden = false;
            collectionView.isHidden = true;
        }
        
        
        // Blocked users.
        // You cannot follow/unfollow or see the photos of users who you blocked.
        if currentUser.blockedUsers.containsUsername(username: useUser.uid) || useUser.blockedUsers.containsUsername(username: currentUser.uid) {
            
            collectionView.isHidden = true;
            followButton.isHidden = true;
            
        } else {
            
            collectionView.isHidden = false;
            followButton.isHidden = false;
            
        }
        
        profilePicture.image = useUser.profilepic;
    }
    
    
    @objc func goBack() {
        let _ = navigationController?.popViewController(animated: true);
    }
    
    
    
    
    
    
    
    
    /********************************
     *
     *     FOLLOWER/FOLLOWING
     *
     ********************************/
    
    /* Makes the current user follow the user on this profile page.
     PRECONDITION: The user being displayed is NOT the current user.
     POSTCONDITION: It is always the CURRENT USER who has this user added to their following, and the useUse who gets the CURRENT USER added to their followers.*/
    @objc func followUser() {
        
        // Unfollow
        if(self.followButton.titleLabel?.text == "Unfollow") {
            
            // Set the values of the objects.
            if currentUser.following.containsUsername(username: useUser.uid) {
                currentUser.following.removeItem(item: useUser.uid);
            }
            if useUser.followers.containsUsername(username: currentUser.uid) {
                useUser.followers.removeItem(item: currentUser.uid);
            }
            
            // Update the button.
            self.followButton.setTitle("Follow", for: .normal);
            
            // Update both users in firebase.
            fireRef.child("Users").child(currentUser.uid).setValue(currentUser.toDictionary());
            fireRef.child("Users").child(useUser.uid).setValue(useUser.toDictionary());
            
            //feedPage.loadPhotos();
            
            
            // Otherwise, check if the follower/following connection is already there. If not, continue...
        } else {
            
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
            
        }
        
        // Reload the labels.
        self.reloadLabels();
        
    } // End of followUser() method.
    
    
    
    public func acceptFollowRequest(user: User, followDirection: followDirection) {
        // Make sure it is not the same user.
        if user !== currentUser || user.uid != currentUser.uid {
            
            // Set the values of the objects.
            if followDirection == .toFrom {
                if(!currentUser.followers.containsUsername(username: user.uid)) {
                    currentUser.followers.append(user.uid);
                }
                if(!user.following.containsUsername(username: currentUser.uid)) {
                    user.following.append(currentUser.uid);
                }
            } else {
                if(!currentUser.following.containsUsername(username: user.uid)) {
                    currentUser.following.append(user.uid);
                }
                if(!user.followers.containsUsername(username: currentUser.uid)) {
                    user.followers.append(currentUser.uid);
                }
            }
            
            
            // Update the button.
            self.followButton.setTitle("Unfollow", for: .normal);
            
            // Update both users in firebase.
            fireRef.child("Users").child(currentUser.uid).setValue(currentUser.toDictionary());
            fireRef.child("Users").child(user.uid).setValue(user.toDictionary());
            
            
            // Update the current user object.
            //util.reloadCurrentUser();
            
            
            // Send notification.
            if(user.notification_ID != currentUser.notification_ID) {
                OneSignal.postNotification(["contents": ["en": "\(currentUser.username) started following you!"], "include_player_ids": ["\(user.notification_ID)"]], onSuccess: { (dict: [AnyHashable : Any]?) in
                    
                    self.debug(message: "Follow notification was sent!");
                    
                }, onFailure: { (error: Error?) in
                    self.debug(message: "There was an error sending the notification.");
                })
            }
            
            self.debug(message: "Follow request accepted!");
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
        return EmptyPhotoView(place: .top);
    }
    
}

