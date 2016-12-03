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
import Firebase

class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout , DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {


    
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
    
    
    // The posts from the db
    let postsFromDB: NSMutableArray! = NSMutableArray();
    
    
    
    
    
    ///////////////////////////
    //
    // Methods
    //
    ///////////////////////////
    
    
    
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
        nameLabel.align(.underCentered, relativeTo: profilePic, padding: 10, width: view.frame.width, height: AutoHeight);
        followersLabel.align(.underCentered, relativeTo: nameLabel, padding: 0, width: view.frame.width, height: AutoHeight);
        followingLabel.align(.underCentered, relativeTo: followersLabel, padding: 0, width: view.frame.width, height: AutoHeight);
        photosCollectionView.anchorAndFillEdge(.bottom, xPad: 0, yPad: 0, otherSize: 300);
        
        
        let logoutBtn = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(Logout));
        logoutBtn.tintColor = UIColor.white;
        navigationItem.leftBarButtonItem = logoutBtn;
    }

    
    override func viewDidAppear(_ animated: Bool) {
        postsFromDB.removeAllObjects();
        loadCurrentUsersPhotos();
    }
    
    


    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout();
        layout.scrollDirection = .vertical;
        
        photosCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 300), collectionViewLayout: layout);
        photosCollectionView.register(ProfilePostCell.self, forCellWithReuseIdentifier: "Cell");
        photosCollectionView.backgroundColor = view.backgroundColor;
        photosCollectionView.backgroundColor = UIColor.blue;
        photosCollectionView.emptyDataSetDelegate = self;
        photosCollectionView.emptyDataSetSource = self;
        photosCollectionView.delegate = self;
        photosCollectionView.dataSource = self;
    }
    
    
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let s = NSAttributedString(string: "No photos to display.");
        return s;
    }
    
    
    
    
    // Grabs all of this user's photos from the database
    private func loadCurrentUsersPhotos() {
        
        // Observe the database elements.
        FIRDatabase.database().reference().child("Photos").child(currentUser.email!.substring(i: 0, j: currentUser.email!.length() - 4)).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let postDictionary = snapshot.value as? [String : AnyObject] {
                
                // Get each post from the database.
                for post in postDictionary {
                    self.postsFromDB.add(post.value);
                }
                self.photosCollectionView.reloadData();
            }
        });
    }
    
    
    
    
    // Logs the user out and goes back to the landing page
    @objc private func Logout() {
        navigationController?.pushViewController(LandingViewController(), animated: false);
        navigationController?.navigationBar.isHidden = true;
        
        currentUser = User(firstName: "", lastName: "", email: "");
        currentUser.id = "";
        currentUser.password = "";
        currentUser.followers = nil;
        currentUser.following = nil;
        currentUser.posts = nil;
        
    }

    
    
    
    
    /////////// Collection View Stuff ////////////
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    
    @available(iOS 6.0, *)
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postsFromDB.count;
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = photosCollectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ProfilePostCell;
        
        let aPost = postsFromDB[indexPath.item] as! [String: AnyObject];
        
        if let imgName = aPost["image"] as? String {
            var image: UIImage?;
            let imgRef = FIRStorage.storage().reference().child("\(currentUser.email!)/\(imgName)");
            imgRef.data(withMaxSize: 25 * 1024 * 1024, completion: { (data, error) in
                
                if error == nil {
                    image = UIImage(data: data!)!;
                    let cap = aPost["caption"] as? String ?? "";
                    let likes = aPost["likes"] as? Int ?? 0;
                    let actualPost = Post(img: image, caption: cap, user: currentUser);
                    actualPost.likes = likes;
                    
                    
                    if(currentUser.posts.contains(item: actualPost)) {
                        print("YES, Working!");
                    } else {
                        print("Not contained");
                    }
                    
                    
                    cell.post = actualPost;
                    cell.setupLayout();
                    
                } else {
                    print("ERROR LOADING IMAGE");
                    print(error.debugDescription);
                }
                
            })
        }
        
        return cell;
    }
 
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 120);
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20;
    }
}
