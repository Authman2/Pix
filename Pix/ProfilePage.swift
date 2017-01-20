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
        collectionView.snp.makeConstraints({ (maker: ConstraintMaker) in
            maker.width.equalTo(view.frame.width);
            maker.centerX.equalTo(view);
            maker.top.equalTo(followingLabel.snp.bottom).offset(10);
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
        editProfileButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editProfile));
        editProfileButton.tintColor = .white;
        navigationItem.rightBarButtonItem = editProfileButton;
        
        /* Profile pic image picker. */
        imgPicker.delegate = self;
        imgPicker.sourceType = .photoLibrary;
        tap = UITapGestureRecognizer(target: self, action: #selector(uploadProfilePic));
        profilePicture.addGestureRecognizer(tap);
        
        
    } // End of viewDidLoad().
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        //self.adapter.performUpdates(animated: true, completion: nil);
        self.adapter.reloadData { (b: Bool) in
//            self.debug(message: "PHOTOS: \(currentUser.posts)");
        }
        
        editProfileButton.isEnabled = true;
        editProfileButton.tintColor = .white;
        
        self.reloadLabels();
        
        profilePicture.addGestureRecognizer(tap);
        
    } // End of viewDidAppear().
    
    
    func reloadLabels() {
        nameLabel.text = "\(currentUser.firstName) \(currentUser.lastName)";
        followersLabel.text = "Followers: \(currentUser.followers.count)";
        followingLabel.text = "Following: \(currentUser.following.count)";
        profilePicture.image = currentUser.profilepic;
        
        privateLabel.text = "\(currentUser.username) is private. Send a follow request to see their photos.";
        
        privateLabel.isHidden = true;
        collectionView.isHidden = false;
        profilePicture.image = currentUser.profilepic;
    }
    
    
    @objc func logout() {
        do {
            try FIRAuth.auth()?.signOut();
            currentUser = nil;
            feedPage.followingUsers.removeAll();
            feedPage.postFeed.removeAll();
            explorePage.listOfUsers.removeAll();
            explorePage.listOfUsers_fb.removeAllObjects();
            
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
            let id = currentUser.profilePicName;
            currentUser.profilepic = photo;
            
            
            // Delete the old picture from firebase, and replace it with the new one, but keep the same id.
            let storageRef = FIRStorageReference().child("\(currentUser.uid)/\(id!).jpg");
            storageRef.delete { error in
                // If there's an error.
                if let error = error {
                    self.debug(message: "There was an error deleting the image: \(error)");
                } else {
                    // Save the new image.
                    let data = UIImageJPEGRepresentation(photo, 100) as NSData?;
                    
                    let _ = storageRef.put(data! as Data, metadata: nil) { (metaData, error) in
                        
                        if (error == nil) {
                            
                            let post = Post(photo: photo, caption: "", Uploader: currentUser, ID: id!);
                            post.isProfilePicture = true;
                            let postObj = post.toDictionary();
                            self.fireRef.child("Photos").child("\(currentUser.uid)").child("\(id!)").setValue(postObj);
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
        return currentUser.posts;
    }
    
    func listAdapter(_ listAdapter: IGListAdapter, sectionControllerFor object: Any) -> IGListSectionController {
        return ProfileSectionController(vc: self);
    }
    
    func emptyView(for listAdapter: IGListAdapter) -> UIView? {
        return EmptyPhotoView(place: .top);
    }
    
}
