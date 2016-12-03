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
import AUNavigationMenuController
import SnapKit

class ProfileViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout , DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {


    
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
        l.text = currentUser.firstName! + " " + currentUser.lastName!;    // By the time you get here, current user will not be nil
        l.textAlignment = .center;
        l.textColor = UIColor.black;
        
        return l;
    }();
    
    
    // The label that says followers
    let followersLabel: UILabel = {
        let l = UILabel();
        l.translatesAutoresizingMaskIntoConstraints = false;
        l.text = "Followers: \(currentUser.followers.count)";
        l.textAlignment = .center;
        l.textColor = UIColor.black;
        
        return l;
    }();
    
    
    // The label that says followers
    let followingLabel: UILabel = {
        let l = UILabel();
        l.translatesAutoresizingMaskIntoConstraints = false;
        l.text = "Following: \(currentUser.following.count)";
        l.textAlignment = .center;
        l.textColor = UIColor.black;
        
        return l;
    }();
    
    
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
        
        
        // Add all the components
        view.addSubview(profilePic);
        view.addSubview(nameLabel);
        view.addSubview(followersLabel);
        view.addSubview(followingLabel);
        
 
        // SnapKit
        profilePic.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.width.height.equalTo(90);
            maker.top.equalTo(view).offset(80);
            maker.centerX.equalTo(view);
        }
        nameLabel.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.width.equalTo(view.frame.width);
            maker.height.equalTo(30);
            maker.centerX.equalTo(view);
            maker.top.equalTo(profilePic.snp.bottom).offset(10);
        }
        followersLabel.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.width.equalTo(view.frame.width);
            maker.height.equalTo(30);
            maker.centerX.equalTo(view);
            maker.top.equalTo(nameLabel.snp.bottom);
        }
        followingLabel.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.width.equalTo(view.frame.width);
            maker.height.equalTo(30);
            maker.centerX.equalTo(view);
            maker.top.equalTo(followersLabel.snp.bottom);
        }
        collectionView?.snp.makeConstraints({ (maker: ConstraintMaker) in
            maker.width.equalTo(view.frame.width);
            maker.centerX.equalTo(view);
            maker.top.equalTo(followingLabel.snp.bottom).offset(10);
            maker.bottom.equalTo(view.snp.bottom);
        })
        
        
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
        
        let colViewFrame = CGRect(x: 0, y: 0, width: 0, height: 0);
        
        collectionView = UICollectionView(frame: colViewFrame, collectionViewLayout: layout);
        collectionView?.register(ProfilePostCell.self, forCellWithReuseIdentifier: "Cell");
        collectionView?.backgroundColor = view.backgroundColor;
        collectionView?.emptyDataSetDelegate = self;
        collectionView?.emptyDataSetSource = self;
        collectionView?.delegate = self;
        collectionView?.dataSource = self;
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
                self.collectionView?.reloadData();
            }
        });
    }
    
    
    
    
    // Logs the user out and goes back to the landing page
    @objc private func Logout() {
        let nav = navigationController as! AUNavigationMenuController;
        nav.open = true;
        nav.togglePulldownMenu();
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
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    
    @available(iOS 6.0, *)
    override public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postsFromDB.count;
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ProfilePostCell;
        
        let aPost = postsFromDB[indexPath.item] as! [String: AnyObject];
        
        if let imgName = aPost["image"] as? String {
            var image: UIImage?;
            let imgRef = FIRStorage.storage().reference().child("\(currentUser.email!)/\(imgName)");
            imgRef.data(withMaxSize: 40 * 1024 * 1024, completion: { (data, error) in
                
                if error == nil {
                    image = UIImage(data: data!)!;
                    let cap = aPost["caption"] as? String ?? "";
                    let likes = aPost["likes"] as? Int ?? 0;
                    let actualPost = Post(img: image, caption: cap, user: currentUser);
                    actualPost.likes = likes;
                    
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
        return CGSize(width: 120, height: 120);
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5;
    }
}
