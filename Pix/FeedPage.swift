//
//  FeedPage.swift
//  Pix
//
//  Created by Adeola Uthman on 12/23/16.
//  Copyright © 2016 Adeola Uthman. All rights reserved.
//

import UIKit
import PullToRefreshSwift
import Firebase

class FeedPage: UICollectionViewController, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    /********************************
     *
     *          VARIABLES
     *
     ********************************/
    
    /* Image picker */
    let imgPicker = UIImagePickerController();
    
    
    /* An array of posts to display on the news feed. */
    var postFeed: [Post] = [Post]();
    
    
    // Temporary array for the users that currentUser is following.
    var usernames: [String] = [String]();
    var users: [User] = [User]();
    
    
    /* The firebase database reference. */
    var fireRef: FIRDatabaseReference = FIRDatabase.database().reference();
    
    
    
    
    
    /********************************
     *
     *          METHODS
     *
     ********************************/

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 239/255, green: 255/255, blue:245/255, alpha: 1);
        navigationController?.navigationBar.isHidden = false;
        navigationItem.hidesBackButton = true;
        navigationItem.title = "Feed";
        setupCollectionView();
        
        
        // Image Picker.
        imgPicker.delegate = self;
        imgPicker.sourceType = .photoLibrary;
        
        
        // Add a button for uploading photos.
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(uploadPhoto));
        addButton.tintColor = UIColor.white;
        navigationItem.rightBarButtonItem = addButton;
        
        
        // Pull to refresh
        var options = PullToRefreshOption();
        options.fixedSectionHeader = false;
        collectionView?.addPullRefresh(options: options, refreshCompletion: { (Void) in
            self.copyOverAndReload();
            self.collectionView?.stopPullRefreshEver();
        });
        
    } // End of viewDidLoad().

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        navigationController?.navigationBar.isHidden = false;
        navigationItem.hidesBackButton = true;
        navigationItem.title = "Feed";
        
        self.copyOverAndReload();
    } // End of viewDidAppear().
    
    
    // Setup the collection view.
    func setupCollectionView() {
        collectionView!.register(FeedCell.self, forCellWithReuseIdentifier: "Cell");
        collectionView?.backgroundColor = view.backgroundColor;
        collectionView?.alwaysBounceVertical = true;
        collectionView?.delegate = self;
        collectionView?.dataSource = self;
    }
    
    
    
    
    /* Loads the photos for all of the people that this user is following. */
    public func loadPhotos() {
       
        // Observe the users.
        fireRef.child("Users").child(currentUser.username).observeSingleEvent(of: .value) { (snapshot: FIRDataSnapshot) in
            
            let value = snapshot.value as? [String : AnyObject] ?? [:];
            let following = value["following"] as? [String] ?? [];
            
            for name in following {
                if !self.usernames.containsUsername(username: name) {
                    self.usernames.append(name);
                }
            }
            
        } // End of observe following block.
        
        
        // Observe the info for each user that is in following and create User objects.
        fireRef.child("Users").observeSingleEvent(of: .value, with: { (snapshot: FIRDataSnapshot) in
            
            // Get the snapshot
            let userDictionary = snapshot.value as? [String : AnyObject] ?? [:];
            
            // Look through each user.
            for user in userDictionary {
                
                // Get the username.
                let username = user.value["username"] as? String ?? "";
                
                // Make sure that this is a user we need to be looking at.
                if(self.usernames.containsUsername(username: username)) {
                    
                    let em = user.value["email"] as? String ?? "";
                    let firstName = user.value["first_name"] as? String ?? "";
                    let lastName = user.value["last_name"] as? String ?? "";
                    let pass = user.value["password"] as? String ?? "";
                    let followers = user.value["followers"] as? [String] ?? [];
                    let following = user.value["following"] as? [String] ?? [];
                    let likedPhotos = user.value["liked_photos"] as? [String] ?? [];
                    let notifID = user.value["notification_id"] as? String ?? "";
                    
                    
                    // Create a user and add it to the array.
                    let usr = User(first: firstName, last: lastName, username: username, email: em);
                    usr.password = pass;
                    usr.followers = followers;
                    usr.following = following;
                    usr.likedPhotos = likedPhotos;
                    usr.notification_ID = notifID;
                    
                    if !self.users.containsUser(username: usr.username) {
                        self.users.append(usr);
                    }
                    
                } // End of if statement.
                
            } // End of user for loop.
            
            
            // Observe the photos.
            for user in self.users {
            
                landingPage.loadUsersPhotos(user: user, completion: nil);
                self.copyOverAndReload();
            
            } // End of getting users' photos for loop.
            
            
        }) // End of observe.
        
    } // End of load photos method.
    
    
    
    /* Puts all of the photos from each user into the overall array. */
    public func copyOverAndReload() {
        // Load all of the photos.
        for user in users {
            
            // Go through each post.
            for post in user.posts {
                
                // If the post is not already in the array, add it. 
                if !self.postFeed.containsID(id: post.id) {
                    
                    self.postFeed.append(post);
                    
                }
            }
        }
        self.collectionView?.reloadData();
    }
    
    
    
    
    
    
    /********************************
     *
     *       IMAGE PICKER
     *
     ********************************/
    
    @objc func uploadPhoto() {
        show(imgPicker, sender: self);
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let photo = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            let vc = UploadPhotosViewController();
            let post = Post(photo: photo, caption: "", Uploader: currentUser, ID: nil);
            vc.post = post;
            vc.imageView.image = photo;
            navigationController?.pushViewController(vc, animated: true);
            imgPicker.dismiss(animated: true, completion: nil);
            
        }
    }
    
    
    
    
    
    
    
    /********************************
     *
     *       COLLECTION VIEW
     *
     ********************************/

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postFeed.count;
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! FeedCell;
    
        cell.post = postFeed[indexPath.item];
        cell.setup();
    
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 20, height: 300);
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0);
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20;
    }
}
