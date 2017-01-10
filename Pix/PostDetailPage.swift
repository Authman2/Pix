//
//  PostDetailPage.swift
//  Pix
//
//  Created by Adeola Uthman on 12/24/16.
//  Copyright © 2016 Adeola Uthman. All rights reserved.
//

import UIKit
import SnapKit
import Neon
import Firebase
import OneSignal

class PostDetailPage: UIViewController {

    /********************************
     *
     *          VARIABLES
     *
     ********************************/
    
    /* A Post object for data grabbing. */
    var post: Post!
    
    
    /* The image view. */
    let imageView: UIImageView = {
        var imageView = UIImageView();
        imageView.translatesAutoresizingMaskIntoConstraints = false;
        imageView.backgroundColor = UIColor(red: 239/255, green: 255/255, blue:245/255, alpha: 1);
        imageView.contentMode = .scaleAspectFit;
        imageView.clipsToBounds = false;
        
        return imageView;
    }();
    
    
    /* The label that displays the caption. */
    let captionLabel: UILabel = {
        let c = UILabel();
        c.translatesAutoresizingMaskIntoConstraints = false;
        c.textColor = .black;
        c.backgroundColor = UIColor(red: 239/255, green: 255/255, blue:245/255, alpha: 1);
        c.numberOfLines = 0;
        c.font = UIFont(name: c.font.fontName, size: 15);
        
        return c;
    }();

    
    /* The label that shows the number of likes. */
    let likesLabel: UILabel = {
        let l = UILabel();
        l.translatesAutoresizingMaskIntoConstraints = false;
        l.textColor = .black;
        l.backgroundColor = UIColor(red: 239/255, green: 255/255, blue:245/255, alpha: 1);
        
        return l;
    }();

    
    /* The label that shows the name of the person who uploaded the photo. */
    let uploaderLabel: UILabel = {
        let l = UILabel();
        l.translatesAutoresizingMaskIntoConstraints = false;
        l.textColor = .black;
        l.backgroundColor = UIColor(red: 239/255, green: 255/255, blue:245/255, alpha: 1);
        
        return l;
    }();


    /* Firebase database reference. */
    let fireRef: FIRDatabaseReference = FIRDatabase.database().reference();
    



    
    /********************************
     *
     *          METHODS
     *
     ********************************/
    
    /* Setup the look of the view. In other words, arrange the components. 
     @param post -- The Post object that all of the information is grabbed from. */
    public func setup(post: Post) {
        self.post = post;
        
        // Tap gesture
        let tap = UITapGestureRecognizer(target: self, action: #selector(likePhoto));
        tap.numberOfTapsRequired = 2;
        imageView.addGestureRecognizer(tap);
        view.addGestureRecognizer(tap);
        
        // Long press
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(openActionSheet));
        longPress.minimumPressDuration = 2;
        imageView.addGestureRecognizer(longPress);
        view.addGestureRecognizer(longPress);

        
        // Get the important info.
        imageView.image = post.photo.image!;
        captionLabel.text = "\(post.caption.text!)";
        likesLabel.text = "Likes: \(post.likes)";
        uploaderLabel.text = "\(post.uploader.firstName) \(post.uploader.lastName)";
        
        /* Layout the components. */
        view.addSubview(imageView);
        
        view.addSubview(captionLabel);
        view.addSubview(likesLabel);
        view.addSubview(uploaderLabel);
        
        
        /* Layout with Snapkit */
        likesLabel.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.bottom.equalTo(view.snp.bottom);
            maker.height.equalTo(20);
            maker.right.equalTo(view.snp.right);
        }
        uploaderLabel.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.bottom.equalTo(view.snp.bottom);
            maker.height.equalTo(20);
            maker.left.equalTo(view.snp.left);
            maker.right.equalTo(likesLabel.snp.left);
        }
        captionLabel.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.bottom.equalTo(uploaderLabel.snp.top);
            maker.width.equalTo(view.frame.width);
            maker.height.equalTo(50);
            maker.left.equalTo(view.snp.left);
            maker.right.equalTo(view.snp.right);
        }
        imageView.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.left.equalTo(0);
            maker.right.equalTo(view.snp.right);
            maker.top.equalTo(0);
            maker.bottom.equalTo(captionLabel.snp.top);
        }
        
    } // End of setup method.
    
    
    
    @objc func likePhoto() {
        
        // If the id for this photo is not already in the current user's list of liked photos, then add it and update firebase.
        // Otherwise, unlike it.
        if !currentUser.likedPhotos.containsUsername(username: self.post.id!) {
            
            currentUser.likedPhotos.append(self.post.id!);
            post.likes += 1;
            fireRef.child("Users").child(currentUser.uid).setValue(currentUser.toDictionary());
            fireRef.child("Photos").child(post.uploader.uid).child(post.id!).setValue(post.toDictionary());
            
            // Send notification.
            if(self.post.uploader.notification_ID != currentUser.notification_ID) {
                OneSignal.postNotification(["contents": ["en": "\(currentUser.username) liked your photo!"], "include_player_ids": ["\(self.post.uploader.notification_ID)"]], onSuccess: { (dict: [AnyHashable : Any]?) in
                    
                    self.debug(message: "Follow notification was sent!");
                    
                }, onFailure: { (error: Error?) in
                    self.debug(message: "There was an error sending the notification.");
                });
            }
            
        } else {
            
            if currentUser.likedPhotos.count > 0 {
                currentUser.likedPhotos.removeItem(item: self.post.id!);
                post.likes -= 1;
                fireRef.child("Users").child(currentUser.uid).setValue(currentUser.toDictionary());
                fireRef.child("Photos").child(post.uploader.uid).child(post.id!).setValue(post.toDictionary());
                
            }
        }
        
        likesLabel.text = "Likes: \(post.likes)";
    }

    
    
    @objc func openActionSheet() {
        
        let actionSheet = UIAlertController(title: "Photo Options", message: nil, preferredStyle: .actionSheet);
        let flagAction = UIAlertAction(title: "Flag as Inappropriate", style: .destructive) { (action: UIAlertAction) in
            self.post.flags += 1;
            self.fireRef.child("Photos").child(currentUser.uid).child(self.post.id!).updateChildValues(self.post.toDictionary() as! [AnyHashable : Any]);
        }
        
        actionSheet.addAction(flagAction);
        
        present(actionSheet, animated: true, completion: nil);
    }
    
    
    
}
