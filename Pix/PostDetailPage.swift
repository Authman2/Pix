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

class PostDetailPage: UIViewController {

    /********************************
     *
     *          VARIABLES
     *
     ********************************/
    
    
    /* Displays the photo on the post. */
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





    
    /********************************
     *
     *          METHODS
     *
     ********************************/
    
    /* Setup the look of the view. In other words, arrange the components. 
     @param post -- The Post object that all of the information is grabbed from. */
    public func setup(post: Post) {
        
        // Get the important info.
        imageView.image = post.photo.image!;
        captionLabel.text = "\(post.caption.text!)";
        likesLabel.text = "Likes: \(post.likes)";
        uploaderLabel.text = "\(post.uploader.firstName) \(post.uploader.lastName)";
        
        /* Layout the components. */
        view.addSubview(imageView);
        
        let bottomView = UIView();
        bottomView.backgroundColor = UIColor(red: 239/255, green: 255/255, blue:245/255, alpha: 1);
        bottomView.addSubview(captionLabel);
        bottomView.addSubview(likesLabel);
        bottomView.addSubview(uploaderLabel);
        view.addSubview(bottomView);
        
        
        /* Layout with Neon */
        imageView.anchorToEdge(.top, padding: 0, width: view.width, height: view.height / 1.25);
        bottomView.align(.underCentered, relativeTo: imageView, padding: 0, width: view.width, height: view.height - (view.height / 1.25));
        
        
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
            maker.width.equalTo(view.frame.width);
            maker.left.equalTo(view.snp.left);
            maker.right.equalTo(view.snp.right);
            maker.top.equalTo(view.snp.top);
            maker.bottom.equalTo(uploaderLabel.snp.top);
        }
        
    } // End of setup method.
    
    
    
    
    
    

}
