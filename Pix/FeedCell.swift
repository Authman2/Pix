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
        a.backgroundColor = UIColor.gray;
        a.contentMode = .scaleToFill;
        
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

    
    
    
    
    
    
    
    
    
    /********************************
     *
     *          METHODS
     *
     ********************************/
    
    public func setup() {
        // Get the important info.
        imageView.image = post.photo.image!;
        captionLabel.text = "\(post.caption.text!)";
        likesLabel.text = "Likes: \(post.likes)";
        uploaderLabel.text = "\(post.uploader.firstName) \(post.uploader.lastName)";
        
        
        /* Layout the components. */
        addSubview(imageView);
        let bottomView = UIView();
        bottomView.backgroundColor = .white;
        bottomView.addSubview(captionLabel);
        bottomView.addSubview(likesLabel);
        bottomView.addSubview(uploaderLabel);
        addSubview(bottomView);
        
        
        /* Layout with Neon */
        imageView.anchorToEdge(.top, padding: 0, width: width, height: height / 1.25);
        bottomView.align(.underCentered, relativeTo: imageView, padding: 0, width: width, height: height - (height / 1.25));
        
        
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
            maker.right.equalTo(likesLabel.snp.left);
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
    
    
    
    
    
    
    
    
}