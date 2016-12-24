//
//  PostDetailPage.swift
//  Pix
//
//  Created by Adeola Uthman on 12/24/16.
//  Copyright © 2016 Adeola Uthman. All rights reserved.
//

import UIKit
import SnapKit

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
        a.isUserInteractionEnabled = true;
        
        return a;
    }();


    /* The label that displays the caption. */
    let captionLabel: UILabel = {
        let c = UILabel();
        c.translatesAutoresizingMaskIntoConstraints = false;
        c.textColor = .black;
        
        return c;
    }();

    
    /* The label that shows the number of likes. */
    let likesLabel: UILabel = {
        let l = UILabel();
        l.translatesAutoresizingMaskIntoConstraints = false;
        l.textColor = .black;
        
        return l;
    }();

    
    /* The label that shows the name of the person who uploaded the photo. */
    let uploaderLabel: UILabel = {
        let l = UILabel();
        l.translatesAutoresizingMaskIntoConstraints = false;
        l.textColor = .black;
        
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
        
        
        // Layout the components.
        view.addSubview(imageView);
        let bottomView = UIView();
        bottomView.addSubview(captionLabel);
        bottomView.addSubview(likesLabel);
        bottomView.addSubview(uploaderLabel);
        view.addSubview(bottomView);
        
        imageView.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.top.equalTo(view.snp.top);
            maker.width.equalTo(view.width);
            maker.centerX.equalTo(view.snp.centerX);
        }
        bottomView.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.top.equalTo(imageView.snp.bottom);
            maker.width.equalTo(view.width);
            maker.left.equalTo(view.snp.left);
        }
        captionLabel.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.top.equalTo(bottomView.snp.top);
            maker.width.equalTo(bottomView.width);
            maker.left.equalTo(bottomView.snp.left);
        }
        likesLabel.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.top.equalTo(captionLabel.snp.bottom);
            maker.width.equalTo(bottomView.width);
            maker.left.equalTo(bottomView.snp.left);
        }
        uploaderLabel.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.top.equalTo(likesLabel.snp.bottom);
            maker.width.equalTo(bottomView.width);
            maker.left.equalTo(bottomView.snp.left);
        }
        
        
    } // End of setup method.
    
    
    
    
    
    

}
