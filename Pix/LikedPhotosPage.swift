//
//  LikedPhotosPage.swift
//  Pix
//
//  Created by Adeola Uthman on 1/19/17.
//  Copyright © 2017 Adeola Uthman. All rights reserved.
//

import Foundation
import UIKit
import IGListKit
import SnapKit
import Firebase
import PullToRefreshSwift

class LikedPhotosPage: ProfileDisplayPage, IGListAdapterDataSource {
    
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

    
    /* The array that holds all of the user's liked photos. */
    var users: [User] = [User]();
    var liked: [Post] = [Post]();
    
    
    
    
    
    
    
    
    /********************************
     *
     *          METHODS
     *
     ********************************/
    
    override func viewDidLoad() {
        super.viewDidLoad();
        navigationItem.title = "Liked Photos";
        
        collectionView.register(ProfilePageCell.self, forCellWithReuseIdentifier: "Cell");
        collectionView.backgroundColor = UIColor(red: 239/255, green: 255/255, blue:245/255, alpha: 1);
        adapter.collectionView = collectionView;
        adapter.dataSource = self;
        
        view.addSubview(collectionView);
        collectionView.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.top.equalTo(view.snp.top);
            maker.left.equalTo(view.snp.left);
            maker.right.equalTo(view.snp.right);
            maker.bottom.equalTo(view.snp.bottom);
        }
        
        
        
        var options = PullToRefreshOption();
        options.fixedSectionHeader = false;
        collectionView.addPullRefresh(options: options, refreshCompletion: { (Void) in
            
            if !currentUser.likedPhotos.isEmpty {
                self.loadPhotosForEachUser(completion: {
                    self.adapter.performUpdates(animated: true, completion: { (b: Bool) in
                        self.collectionView.stopPullRefreshEver();
                    })
                })
            } else {
                self.adapter.performUpdates(animated: true, completion: { (b: Bool) in
                    self.collectionView.stopPullRefreshEver();
                })
            }
        });
        
        
        let cancelButton = UIBarButtonItem(title: "< Back", style: .plain, target: self, action: #selector(close));
        cancelButton.tintColor = .white;
        navigationItem.leftBarButtonItem = cancelButton;
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        lastProfile = self;
        viewcontrollerName = "Liked Photos";
    }
    
    
    @objc func close() {
        let _ = navigationController?.popViewController(animated: true);
    }
    
    
    
    
    
    
    public func loadPhotosForEachUser(completion: (()->Void)?) {
        
        // Go through each element in the liked photos.
        for user_post_pair in currentUser.likedPhotos {
            
            // Separate it into the user id and the photo id.
            let components = user_post_pair.components(separatedBy: " ");
            var UID = "";
            var PHOTOID = "";
            if components.count == 0 || components.count == 1 {
                continue;
            } else if components.count == 2 {
                UID = components[0];
                PHOTOID = components[1];
            }
            
            // Load that photo data in firebase.
            let fireRef = FIRDatabase.database().reference();
            fireRef.child("Users").child(UID).observeSingleEvent(of: .value, with: { (snapshot: FIRDataSnapshot) in
                
                // Get the user who the photo belongs to.
                let value = snapshot.value as? NSDictionary ?? [:];
                let usr = value.toUser();
                
                // Load only that photo.
                var singlePost: Post = Post(photo: nil, caption: "", Uploader: usr, ID: PHOTOID);
                util.loadSinglePost(user: usr, withPostID: PHOTOID, loadInto: &singlePost, success: {
                    if !self.liked.containsID(id: PHOTOID) {
                        self.liked.append(singlePost);
                    }
                    
                    if let comp = completion {
                        comp();
                    }
                }, error: {
                    // Remove the photos from liked posts if it no longer exists and update the user in firebase.
                    currentUser.likedPhotos.removeItem(item: user_post_pair);
                    fireRef.child("Users").child(currentUser.uid).updateChildValues(currentUser.toDictionary() as! [AnyHashable : AnyObject]);
                    
                    if let comp = completion {
                        comp();
                    }
                });
            })
        }
        
    }
    
    
    
    
    
    /********************************
     *
     *       COLLECTION VIEW
     *
     ********************************/
    
    
    func objects(for listAdapter: IGListAdapter) -> [IGListDiffable] {
        return self.liked;
    }
    
    func listAdapter(_ listAdapter: IGListAdapter, sectionControllerFor object: Any) -> IGListSectionController {
        // Here you can just use the same section controller used in the profile page.
        return ProfileSectionController(vc: self);
    }
    
    func emptyView(for listAdapter: IGListAdapter) -> UIView? {
        return EmptyPhotoView(place: .center);
    }
}
