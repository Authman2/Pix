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
import IGListKit

class FeedPage: UIViewController, IGListAdapterDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    /********************************
     *
     *          VARIABLES
     *
     ********************************/
    
    /* Image picker */
    let imgPicker = UIImagePickerController();
    
    
    /* The IG adapter. */
    lazy var adapter: IGListAdapter = {
        return IGListAdapter(updater: IGListAdapterUpdater(), viewController: self, workingRangeSize: 1);
    }();
    
    
    /* The collection view. */
    let collectionView: IGListCollectionView = {
        let layout = UICollectionViewFlowLayout();
        layout.minimumLineSpacing = 20;
        layout.minimumInteritemSpacing = 20;
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0);
        
        let view = IGListCollectionView(frame: CGRect.zero, collectionViewLayout: layout);
        view.alwaysBounceVertical = true;
        
        return view;
    }();

    
    
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
        view.addSubview(collectionView);
        
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
        collectionView.addPullRefresh(options: options, refreshCompletion: { (Void) in
            self.copyOverAndReload();
            self.adapter.performUpdates(animated: true, completion: nil);
            self.collectionView.stopPullRefreshEver();
        });
        
    } // End of viewDidLoad().
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews();
        collectionView.frame = view.bounds;
    } // End of viewDidLayoutSubviews().

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        navigationController?.navigationBar.isHidden = false;
        navigationItem.hidesBackButton = true;
        navigationItem.title = "Feed";
        
        self.copyOverAndReload();
        self.adapter.performUpdates(animated: true, completion: nil);
    } // End of viewDidAppear().
    
    
    // Setup the collection view.
    func setupCollectionView() {
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: "Cell");
        collectionView.backgroundColor = view.backgroundColor;
        
        adapter.collectionView = collectionView;
        adapter.dataSource = self;
    }
    
    
    
    
    /* Loads the photos for all of the people that this user is following. */
    public func loadPhotos() {
       
        // Observe the users.
        fireRef.child("Users").child(currentUser.uid).observe(.value) { (snapshot: FIRDataSnapshot) in
        
            let value = snapshot.value as? [String : AnyObject] ?? [:];
            let following = value["following"] as? [String] ?? [];
            
            for name in following {
                if !self.usernames.containsUsername(username: name) {
                    self.usernames.append(name);
                }
            }
            
        } // End of observe following block.
        
        
        // Observe the info for each user that is in following and create User objects.
        fireRef.child("Users").observe(.value, with: { (snapshot: FIRDataSnapshot) in
            
            // Get the snapshot
            let userDictionary = snapshot.value as? [String : AnyObject] ?? [:];
            
            // Look through each user.
            for user in userDictionary {
                let value = user.value as? NSDictionary ?? [:];
                
                let usr = value.toUser();
                
                
                // Make sure that this is a user we need to be looking at.
                if(self.usernames.containsUsername(username: usr.uid)) {
                                        
                    if !self.users.containsUser(username: usr.uid) {
                        self.users.append(usr);
                    }
                    
                } // End of if statement.
                
            } // End of user for loop.
            
            
            // Observe the photos.
            for user in self.users {
            
                landingPage.loadUsersPhotos(user: user, continous: true, completion: nil);
                self.copyOverAndReload();
            
            } // End of getting users' photos for loop.
            
            
        }) // End of observe.
        
    } // End of load photos method.
    
    
    
    /* Puts all of the photos from each user into the overall array. 
     Don't be afraid to call this method more than once; it is not grabbing any data over a network, so
     you don't have to worry about it being slow or anything. */
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

    func objects(for listAdapter: IGListAdapter) -> [IGListDiffable] {
        return postFeed;
    }
    
    func listAdapter(_ listAdapter: IGListAdapter, sectionControllerFor object: Any) -> IGListSectionController {
        return FeedSectionController(vc: self);
    }
    
    func emptyView(for listAdapter: IGListAdapter) -> UIView? {
        return EmptyPhotoView();
    }
    
}
