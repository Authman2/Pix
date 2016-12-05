//
//  DetailPostView.swift
//  Pix
//
//  Created by Adeola Uthman on 12/3/16.
//  Copyright © 2016 Adeola Uthman. All rights reserved.
//

import UIKit
import SnapKit
import Firebase

class DetailPostView: UIViewController {
    
    
    public var post: Post!;
    

    let imageView: UIImageView = {
        let img = UIImageView();
        img.translatesAutoresizingMaskIntoConstraints = false;
        img.contentMode = .scaleToFill;
        
        return img;
    }();
    let nameLabel: UILabel = {
        let l = UILabel();
        l.translatesAutoresizingMaskIntoConstraints = false;
        l.textColor = UIColor.black;
        l.backgroundColor = UIColor(red: 239/255, green: 255/255, blue:245/255, alpha: 1);
        l.textAlignment = .left;
        
        return l;
    }();
    let likeLabel: UILabel = {
        let l = UILabel();
        l.translatesAutoresizingMaskIntoConstraints = false;
        l.textColor = UIColor.black;
        l.backgroundColor = UIColor(red: 239/255, green: 255/255, blue:245/255, alpha: 1);
        l.textAlignment = .right;
        
        return l;
    }();
    let captionLabel: UILabel = {
        let l = UILabel();
        l.translatesAutoresizingMaskIntoConstraints = false;
        l.textColor = UIColor.black;
        l.backgroundColor = UIColor(red: 239/255, green: 255/255, blue:245/255, alpha: 1);
        l.textAlignment = .left;
        
        return l;
    }();
    
    
    
    public func setup() {
        imageView.image = post.image!;
        nameLabel.text = " \(post.user.firstName!) \(post.user.lastName!)";
        likeLabel.text = "Likes: \(post.likes)  ";
        captionLabel.text = " \(post.caption!)";
        
        // Add to the elements
        view.addSubview(imageView);
        view.addSubview(likeLabel);
        view.addSubview(captionLabel);
        view.addSubview(nameLabel);
        
        
        // Add constraints
        likeLabel.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.bottom.equalTo(view.snp.bottom);
            maker.height.equalTo(20);
            maker.right.equalTo(view.snp.right);
        }
        nameLabel.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.bottom.equalTo(view.snp.bottom);
            maker.height.equalTo(20);
            maker.left.equalTo(view.snp.left);
            maker.right.equalTo(likeLabel.snp.left);
        }
        captionLabel.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.bottom.equalTo(nameLabel.snp.top);
            maker.width.equalTo(view.frame.width);
            maker.height.equalTo(50);
            maker.left.equalTo(view.snp.left);
        }
        imageView.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.width.equalTo(view.frame.width);
            maker.left.equalTo(view.snp.left);
            maker.right.equalTo(view.snp.right);
            maker.top.equalTo(view.snp.top);
            maker.bottom.equalTo(nameLabel.snp.top);
        }
        
        
        // Add a doubel tap gesture for liking the photo
        let tap = UITapGestureRecognizer(target: self, action: #selector(like));
        tap.numberOfTapsRequired = 2;
        view.addGestureRecognizer(tap);
    }
    
    
    
    @objc private func like() {
        if (post.canLike == true) {
            post.addLike();
            likeLabel.text = "Likes: \(post.likes)  ";
            post.canLike = false;
            
            let emailTrimmed = currentUser.email!.substring(i: 0, j: currentUser.email!.length() - 4);
            var likesNum = 0;
            FIRDatabase.database().reference().child("Photos").child(emailTrimmed).child(post.id!).observeSingleEvent(of: .value, with: { (snapshot: FIRDataSnapshot) in
                
                let item = snapshot.value as? NSDictionary;
                let val = item?["likes"] as? Int ?? 0;
                
                likesNum = val;
            });
            
            FIRDatabase.database().reference().child("Photos").child(emailTrimmed).child(post.id!).child("likes").setValue(likesNum+1);
        }
    } // Like method
    
}
