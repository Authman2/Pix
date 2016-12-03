//
//  DetailPostView.swift
//  Pix
//
//  Created by Adeola Uthman on 12/3/16.
//  Copyright © 2016 Adeola Uthman. All rights reserved.
//

import UIKit
import SnapKit

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
    let likeButton: UIButton = {
        let btn = UIButton();
        btn.titleLabel?.text = "Like";
        btn.setTitle("Like", for: .normal);
        btn.translatesAutoresizingMaskIntoConstraints = false;
        btn.backgroundColor = UIColor(red: 239/255, green: 255/255, blue:245/255, alpha: 1);
        
        return btn;
    }();;
    
    
    
    override func viewDidLoad() {
        imageView.image = post.image!;
        nameLabel.text = "  \(post.user.firstName!) \(post.user.lastName!)";
        likeLabel.text = "Likes: \(post.likes)  ";
        captionLabel.text = "   \(post.caption!)";
        likeButton.addTarget(self, action: #selector(like), for: .touchUpInside);
        
        
        // Add to the elements
        view.addSubview(imageView);
        view.addSubview(likeLabel);
        view.addSubview(captionLabel);
        view.addSubview(likeButton);
        view.addSubview(nameLabel);
        
        
        // Add constraints
        likeLabel.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.bottom.equalTo(view.snp.bottom);
            maker.height.equalTo(50);
            maker.right.equalTo(view.snp.right);
        }
        
        likeButton.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.bottom.equalTo(view.snp.bottom);
            maker.width.equalTo(view.frame.width);
            maker.height.equalTo(40);
        }
        nameLabel.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.bottom.equalTo(likeButton.snp.bottom);
            maker.height.equalTo(50);
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
            maker.bottom.equalTo(captionLabel.snp.top);
        }
    }
    
    
    
    @objc private func like() {
        if (post.canLike == true) {
            post.addLike();
            likeLabel.text = "Likes: \(post.likes)  ";
            post.canLike = false;
        }
    }
    
}
