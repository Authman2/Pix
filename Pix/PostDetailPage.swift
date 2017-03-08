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
import Presentr
import Hero
import ChameleonFramework
import DynamicColor
import Spring

class PostDetailPage: UIViewController, UIScrollViewDelegate {

    /********************************
     *
     *          VARIABLES
     *
     ********************************/
    
    /* A Post object for data grabbing. */
    var post: Post!
    static let backgroundColor = UIColor.flatForestGreen.lighten(byPercentage: 0.35);
    
    
    let back: UIButton = {
        let a = UIButton(type: UIButtonType.custom);
        a.setImage(UIImage(named: "back_btn@3x.png"), for: .normal);
        a.transform = a.transform.rotated(by: CGFloat(M_PI_2));
        a.transform = a.transform.rotated(by: CGFloat(M_PI_2));
        a.transform = a.transform.rotated(by: CGFloat(M_PI_2));
        a.setTitleColor(.white, for: .normal);
        a.tintColor = .white;
        
        return a;
    }();
    
    
    var scrollView: UIScrollView!;
    
    
    /* The image view. */
    let imageView: UIImageView = {
        var imageView = UIImageView();
        imageView.translatesAutoresizingMaskIntoConstraints = false;
        imageView.backgroundColor = .clear;
        imageView.clipsToBounds = false;
        imageView.contentMode = .scaleToFill;
        
        return imageView;
    }();
    
    
    /* The label that displays the caption. */
    let captionLabel: UILabel = {
        let c = UILabel();
        c.translatesAutoresizingMaskIntoConstraints = false;
        c.textColor = .white;
        c.backgroundColor = .clear;
        c.numberOfLines = 0;
        c.font = UIFont(name: c.font.fontName, size: 15);
        
        return c;
    }();

    
    /* The label that shows the number of likes. */
    let likesLabel: UILabel = {
        let l = UILabel();
        l.translatesAutoresizingMaskIntoConstraints = false;
        l.textColor = .white;
        l.backgroundColor = .clear;
        l.font = UIFont(name: l.font.fontName, size: 15);
        
        return l;
    }();

    
    /* The label that shows the name of the person who uploaded the photo. */
    let uploaderLabel: UILabel = {
        let l = UILabel();
        l.translatesAutoresizingMaskIntoConstraints = false;
        l.textColor = .white;
        l.backgroundColor = .clear;
        l.font = UIFont(name: l.font.fontName, size: 15);
        
        return l;
    }();
    
    
    /* The button to open the comments page. */
    let commentsBtn: SpringButton = {
        let a = SpringButton();
        a.setTitle("Comments", for: .normal);
        a.backgroundColor = PostDetailPage.backgroundColor?.darkened();
        a.titleLabel?.font = UIFont(name: (a.titleLabel?.font.fontName)!, size: 15);
        
        return a;
    }();


    /* Firebase database reference. */
    let fireRef: FIRDatabaseReference = FIRDatabase.database().reference();
    



    
    /********************************
     *
     *          METHODS
     *
     ********************************/
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.view.backgroundColor = PostDetailPage.backgroundColor;
        self.configureGestures();
        
        scrollView = UIScrollView(frame: view.bounds);
        scrollView.backgroundColor = PostDetailPage.backgroundColor;
        scrollView.translatesAutoresizingMaskIntoConstraints = false;
        scrollView.alwaysBounceVertical = true;
        scrollView.alwaysBounceHorizontal = false;
        imageView.frame = scrollView.frame;
        scrollView.contentSize = imageView.frame.size;
        scrollView.delegate = self;
        
        
        // Get the important info.
        imageView.image = post.photo;
        captionLabel.text = "\(post.caption!)";
        likesLabel.text = "Likes: \(post.likes)";
        uploaderLabel.text = "\(post.uploader.firstName) \(post.uploader.lastName)";
        
        
        /* Layout the components. */
        scrollView.addSubview(back);
        scrollView.addSubview(imageView);
        scrollView.addSubview(captionLabel);
        scrollView.addSubview(likesLabel);
        scrollView.addSubview(uploaderLabel);
        scrollView.addSubview(commentsBtn);
        scrollView.bringSubview(toFront: back);
        view.addSubview(scrollView);
        
        
        /* Layout with Snapkit */
        scrollView.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.top.equalTo(view.snp.top);
            maker.height.equalTo(1000);
            maker.left.equalTo(view.snp.left);
            maker.right.equalTo(view.snp.right);
        }
        imageView.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.left.equalTo(scrollView.snp.left);
            maker.right.equalTo(view.snp.right);
            maker.top.equalTo(scrollView.snp.top).offset(-20);
            maker.height.equalTo(500);
        }
        uploaderLabel.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.left.equalTo(5);
            maker.top.equalTo(imageView.snp.bottom).offset(10);
            maker.width.equalTo(view.width);
            maker.height.equalTo(30);
        }
        likesLabel.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.left.equalTo(5);
            maker.top.equalTo(uploaderLabel.snp.bottom);
            maker.width.equalTo(100);
            maker.height.equalTo(30);
        }
        captionLabel.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.top.equalTo(likesLabel.snp.bottom);
            maker.left.equalTo(5);
            maker.right.equalTo(view.snp.right).offset(10);
        }
        back.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.left.equalTo(5);
            maker.top.equalTo(10);
            maker.width.equalTo(50);
            maker.height.equalTo(50);
        }
        commentsBtn.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.left.equalTo(scrollView.snp.left);
            maker.top.equalTo(captionLabel.snp.bottom).offset(30);
            maker.right.equalTo(view.snp.right);
            maker.height.equalTo(35);
        }
        
    } // End of setup method.
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
    }
    

    @objc func goBack() {
        UIView.animate(withDuration: 0.4, delay: 0, options: [], animations: {
            self.navigationController?.navigationBar.isHidden = false;
            self.navigationController?.navigationBar.alpha = 1;
            lastProfile.navigationItem.titleView?.isHidden = false;
            lastProfile.navigationItem.titleView?.alpha = 1;
            
        }, completion: { (finished: Bool) in
            lastProfile.navigationItem.title = lastProfile.viewcontrollerName;
        });
        
        Hero.shared.setDefaultAnimationForNextTransition(animations[1]);
        Hero.shared.setContainerColorForNextTransition(view.backgroundColor);
        
        hero_replaceViewController(with: lastProfile);
    }
    
    func configureGestures() {
        // Tap gesture
        let tap = UITapGestureRecognizer(target: self, action: #selector(likePhoto));
        tap.numberOfTapsRequired = 2;
        imageView.addGestureRecognizer(tap);
        view.addGestureRecognizer(tap);
        
        // Long press
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(openActionSheet));
        imageView.addGestureRecognizer(longPress);
        view.addGestureRecognizer(longPress);
        
        back.addTarget(self, action: #selector(goBack), for: .touchUpInside);
        commentsBtn.addTarget(self, action: #selector(goToComments), for: .touchUpInside);
    }
    
    
    @objc func goToComments() {
        commentsBtn.animateButtonClick();
        
        let presenter: Presentr = {
            let pres = Presentr(presentationType: .bottomHalf);
            pres.dismissOnSwipe = true;
            pres.dismissAnimated = true;
            pres.backgroundOpacity = 0.7;
            return pres;
        }();
        
        let commVC = CommentsPage(post: self.post);
        customPresentViewController(presenter, viewController: commVC, animated: true, completion: nil);
    }
    
    
    @objc func likePhoto() {
        
        if let cUser = Networking.currentUser {
            // If the id for this photo is not already in the current user's list of liked photos, then add it and update firebase.
            // Otherwise, unlike it.
            if !cUser.likedPhotos.containsUsername(username: "\(self.post.uploader.uid) \(self.post.id!)") {
                
                cUser.likedPhotos.append("\(self.post!.uploader!.uid) \(self.post!.id!)");
                post.likes += 1;
                
                Networking.updateCurrentUserInFirebase();
                fireRef.child("Photos").child(post.uploader.uid).child(post.id!).setValue(post.toDictionary());
                
                // Send notification.
                if(self.post.uploader.notification_ID != cUser.notification_ID) {
                    OneSignal.postNotification(["contents": ["en": "\(cUser.username) liked your photo!"], "include_player_ids": ["\(self.post.uploader.notification_ID)"]], onSuccess: { (dict: [AnyHashable : Any]?) in
                        
                        self.debug(message: "Follow notification was sent!");
                        
                    }, onFailure: { (error: Error?) in
                        self.debug(message: "There was an error sending the notification.");
                    });
                }
                
            } else {
                
                if cUser.likedPhotos.count > 0 {
                    cUser.likedPhotos.removeItem(item: self.post.id!);
                    post.likes -= 1;
                    Networking.updateCurrentUserInFirebase();
                    fireRef.child("Photos").child(post.uploader.uid).child(post.id!).setValue(post.toDictionary());
                    
                }
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
        
        customPresentViewController(presenter, viewController: detailView, animated: true, completion: nil);
    }
    
    
    
}
