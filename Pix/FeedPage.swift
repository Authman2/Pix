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
    var followingUsers: [User] = [User]();
    
    
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
            
            self.gatherUsers(completion: {
                //self.debug(message: "FOLLOWING: \(self.followingUsers)");
                
                if !currentUser.following.isEmpty {
                    
                    self.loadFollowingPhotos(eachCompletion: {
                        //self.debug(message: "POSTS: \(self.postFeed)");
                        
                        self.refreshFeed();
                    });
                    
                } else {
                    self.refreshFeed();
                }
            });
        
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
        
        
        // Remove any posts that belong to people you have unfollowed recently.
        self.removeUnfollowedPosts(completion: nil);
        
    } // End of viewDidAppear().
    
    
    // Setup the collection view.
    func setupCollectionView() {
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: "Cell");
        collectionView.backgroundColor = view.backgroundColor;
        
        adapter.collectionView = collectionView;
        adapter.dataSource = self;
    }
    
    
    
    
    /********************************
     *
     *          FEED DATA
     *
     ********************************/
    
    
    /**
     Finds all of the users that the current user is following.
     */
    public func gatherUsers(completion: (()->Void)?) {
        self.followingUsers.removeAll();
        
        
        // Find that user in firebase.
        fireRef.child("Users").observeSingleEvent(of: .value, with: { (snapshot: FIRDataSnapshot) in
            
            let userDictionary = snapshot.value as? [String : AnyObject] ?? [:];
            
            for user in userDictionary {
                
                // Get a user object.
                let value = user.value as? NSDictionary;
                let usr = User(dictionary: value!);
                
                
                // Add to the array if it has the same uid.
                if currentUser.following.contains(usr.uid) {
                    self.followingUsers.append(usr);
                }
            }
            
            if let comp = completion {
                comp();
            }
        });
        
    } // End of method.
    
    
    
    /**
     Loads all of the photos for each person that the current user is following.
     */
    public func loadFollowingPhotos(eachCompletion: (()->Void)?) {
        
        for user in self.followingUsers {
            
            util.loadUsersPhotos(withoutImageData: user, continous: false, completion: {
                
                for post in user.posts {
                    
                    post.photo = util.loadPostImage(user: user, aPost: post, success: { 
                       
                        if !self.postFeed.containsID(id: post.id) {
                            self.postFeed.append(post);
                        }
                        
                        if let comp = eachCompletion {
                            comp();
                        }
                        
                    }, error: nil);
                    
                }
                
            })
            
        } // End of for loop.
        
    }
    
    
    
    /**
     Reload the collection view so that all of the correct photos are displayed.
     */
    public func refreshFeed() {
        self.adapter.performUpdates(animated: true) { (b: Bool) in
            self.collectionView.stopPullRefreshEver();
        }
    }
    
    
    
    /**
     Removes any posts from the news feed that belong to people the current user may have unfollowed since the last refresh. Also removes posts from people you have blocked since the last refresh.
     */
    public func removeUnfollowedPosts(completion: (()->Void)?) {
        
        for post in self.postFeed {
            
            if !currentUser.following.containsUsername(username: post.uploader.uid) {
                
                self.postFeed.removeItem(item: post);
                
            }
            
        } // End of for loop.
        
        if let comp = completion {
            comp();
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
        return EmptyPhotoView(place: .center);
    }
    
}
