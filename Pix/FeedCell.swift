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
import OneSignal
import Presentr

class FeedCell: UICollectionViewCell {
    
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
        a.clipsToBounds = false;
        
        return a;
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
    
    
    /* A reference to the view controller. */
    var vc: UIViewController?;
    
    
    
    
    
    
    /********************************
     *
     *          METHODS
     *
     ********************************/
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        // Tap gesture
        let tap = UITapGestureRecognizer(target: self, action: #selector(likePhoto));
        tap.numberOfTapsRequired = 2;
        imageView.addGestureRecognizer(tap);
        addGestureRecognizer(tap);
        
        // Long press
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(openActionSheet));
        imageView.addGestureRecognizer(longPress);
        addGestureRecognizer(longPress);
        
        
        /* Layout the components. */
        addSubview(imageView);
        addSubview(captionLabel);
        addSubview(likesLabel);
        addSubview(uploaderLabel);

        
        /* Layout with Snapkit */
        imageView.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.top.equalTo(snp.top);
            maker.centerX.equalTo(snp.centerX);
            maker.width.equalTo(snp.width);
            maker.height.equalTo(300);
        }
        captionLabel.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.top.equalTo(imageView.snp.bottom);
            maker.centerX.equalTo(snp.centerX);
            maker.width.equalTo(snp.width);
            maker.height.equalTo(40);
        }
        uploaderLabel.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.top.equalTo(captionLabel.snp.bottom);
            maker.height.equalTo(20);
            maker.left.equalTo(snp.left);
            maker.right.equalTo(likesLabel.snp.left);
        }
        likesLabel.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.top.equalTo(captionLabel.snp.bottom);
            maker.height.equalTo(20);
            maker.right.equalTo(snp.right);
            maker.width.equalTo(100);
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    @objc public func likePhoto() {
        
        // If the id for this photo is not already in the current user's list of liked photos, then add it and update firebase.
        // Otherwise, unlike it.
        if !Networking.currentUser!.likedPhotos.containsUsername(username: "\(self.post.uploader.uid) \(self.post.id!)") {
            
            Networking.currentUser!.likedPhotos.append("\(self.post.uploader.uid) \(self.post.id!)");
            post.likes += 1;
            fireRef.child("Users").child(Networking.currentUser!.uid).updateChildValues(Networking.currentUser!.toDictionary() as! [AnyHashable : Any]);
            fireRef.child("Photos").child(post.uploader.uid).child(post.id!).updateChildValues(post.toDictionary() as! [AnyHashable : Any]);
            
            // Send notification.
            if(self.post.uploader.notification_ID != Networking.currentUser!.notification_ID) {
                OneSignal.postNotification(["contents": ["en": "\(Networking.currentUser!.username) liked your photo!"], "include_player_ids": ["\(self.post.uploader.notification_ID)"]], onSuccess: { (dict: [AnyHashable : Any]?) in
                    
                    print("----------> Like notification was sent!");
                    
                }, onFailure: { (error: Error?) in
                    print("----------> There was an error sending the notification.");
                });
            }
            
        } else {
            
            if Networking.currentUser!.likedPhotos.count > 0 {
                Networking.currentUser!.likedPhotos.removeItem(item: self.post.id!);
                post.likes -= 1;
                fireRef.child("Users").child(Networking.currentUser!.uid).updateChildValues(Networking.currentUser!.toDictionary() as! [AnyHashable : Any]);
                fireRef.child("Photos").child(post.uploader.uid).child(post.id!).updateChildValues(post.toDictionary() as! [AnyHashable : Any]);
                
            }
        }
        
        likesLabel.text = "Likes: \(post.likes)";
    }
    
    
    @objc func openActionSheet() {
        
        let presenter: Presentr = {
            let pres = Presentr(presentationType: .bottomHalf);
            pres.dismissOnSwipe = true;
            pres.dismissAnimated = true;
            pres.backgroundOpacity = 0.7;
            return pres;
        }();
        
        let detailView = ActionSheet();
        detailView.post = self.post;
        
        vc?.customPresentViewController(presenter, viewController: detailView, animated: true, completion: nil);
    }
}
