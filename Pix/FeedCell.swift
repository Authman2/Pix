//
//  FeedCell.swift
//  Pix
//
//  Created by Adeola Uthman on 12/28/16.
//  Copyright © 2016 Adeola Uthman. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import Neon
import Firebase

class FeedCell: UICollectionViewCell, UIScrollViewDelegate {
    
    /********************************
     *
     *          VARIABLES
     *
     ********************************/
    
    /* The post that this collection view cell will use to grab data from. */
    var post: Post!;
    
    
    /* The image view to display the photo. */
    let imageView: UIImageView = {
        let a = UIImageView();
        a.translatesAutoresizingMaskIntoConstraints = false;
        a.backgroundColor = .white;
        a.contentMode = .scaleAspectFit;
        
        return a;
    }();
    
    
    /* The scroll view. */
    let scrollView: UIScrollView = {
        let s = UIScrollView();
        s.backgroundColor = .white;
        s.alwaysBounceVertical = true;
        s.alwaysBounceHorizontal = true;
        s.flashScrollIndicators();
        s.minimumZoomScale = 1.0;
        s.maximumZoomScale = 6.0;
        
        return s;
    }();
    
    
    /* The label that displays the caption. */
    let captionLabel: UILabel = {
        let c = UILabel();
        c.translatesAutoresizingMaskIntoConstraints = false;
        c.textColor = .black;
        c.backgroundColor = .white;
        c.numberOfLines = 0;
        c.font = UIFont(name: c.font.fontName, size: 15);
        
        return c;
    }();
    
    
    /* The label that shows the number of likes. */
    let likesLabel: UILabel = {
        let l = UILabel();
        l.translatesAutoresizingMaskIntoConstraints = false;
        l.textColor = .black;
        l.backgroundColor = .white;
        
        return l;
    }();
    
    
    /* The label that shows the name of the person who uploaded the photo. */
    let uploaderLabel: UILabel = {
        let l = UILabel();
        l.translatesAutoresizingMaskIntoConstraints = false;
        l.textColor = .black;
        l.backgroundColor = .white;
        
        return l;
    }();

    
    /* Firebase database reference. */
    let fireRef: FIRDatabaseReference = FIRDatabase.database().reference();
    
    
    
    
    
    
    
    /********************************
     *
     *          METHODS
     *
     ********************************/
    
    public func setup() {
        scrollView.delegate = self;
        
        // Tap gesture
        let tap = UITapGestureRecognizer(target: self, action: #selector(likePhoto));
        tap.numberOfTapsRequired = 2;
        imageView.addGestureRecognizer(tap);
        addGestureRecognizer(tap);
        
        
        // Get the important info.
        imageView.image = post.photo.image!;
        captionLabel.text = "\(post.caption.text!)";
        likesLabel.text = "Likes: \(post.likes)";
        uploaderLabel.text = "\(post.uploader.firstName) \(post.uploader.lastName)";
        
        
        /* Layout the components. */
        scrollView.addSubview(imageView);
        addSubview(scrollView);
        let bottomView = UIView();
        bottomView.backgroundColor = .white;
        bottomView.addSubview(captionLabel);
        bottomView.addSubview(likesLabel);
        bottomView.addSubview(uploaderLabel);
        addSubview(bottomView);
        
        
        /* Layout with Neon */
        scrollView.anchorToEdge(.top, padding: 0, width: width, height: height / 1.25);
        bottomView.align(.underCentered, relativeTo: scrollView, padding: 0, width: width, height: height - (height / 1.25));
        
        
        /* Layout with Snapkit */
        likesLabel.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.bottom.equalTo(snp.bottom);
            maker.height.equalTo(20);
            maker.right.equalTo(snp.right);
        }
        uploaderLabel.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.bottom.equalTo(snp.bottom);
            maker.height.equalTo(20);
            maker.left.equalTo(snp.left);
        }
        captionLabel.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.bottom.equalTo(uploaderLabel.snp.top);
            maker.width.equalTo(frame.width);
            maker.height.equalTo(50);
            maker.left.equalTo(snp.left);
            maker.right.equalTo(snp.right);
        }
        imageView.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.width.equalTo(frame.width);
            maker.left.equalTo(snp.left);
            maker.right.equalTo(snp.right);
            maker.top.equalTo(snp.top);
            maker.bottom.equalTo(uploaderLabel.snp.top);
        }

    }
    
    
    
    
    @objc public func likePhoto() {
        
        // If the id for this photo is not already in the current user's list of liked photos, then add it and update firebase.
        // Otherwise, unlike it.
        if !currentUser.likedPhotos.containsUsername(username: self.post.id!) {
            
            currentUser.likedPhotos.append(self.post.id!);
            post.likes += 1;
            fireRef.child("Users").child(currentUser.username).setValue(currentUser.toDictionary());
            fireRef.child("Photos").child(post.uploader.username).child(post.id!).setValue(post.toDictionary());
            
        } else {
            
            if currentUser.likedPhotos.count > 0 {
                currentUser.likedPhotos.removeItem(item: self.post.id!);
                post.likes -= 1;
                fireRef.child("Users").child(currentUser.username).setValue(currentUser.toDictionary());
                fireRef.child("Photos").child(post.uploader.username).child(post.id!).setValue(post.toDictionary());
            }
        }
        
        likesLabel.text = "Likes: \(post.likes)";
    }
    
    
    
}
