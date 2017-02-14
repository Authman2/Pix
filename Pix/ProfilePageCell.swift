//
//  ProfilePageCell.swift
//  Pix
//
//  Created by Adeola Uthman on 12/23/16.
//  Copyright © 2016 Adeola Uthman. All rights reserved.
//

import UIKit
import SnapKit

class ProfilePageCell: UICollectionViewCell {
    
    /********************************
     *
     *          VARIABLES
     *
     ********************************/
    
    /* A Post object for data grabbing. */
    var post: Post!
    
    let imageView: UIImageView = {
        let a = UIImageView();
        a.translatesAutoresizingMaskIntoConstraints = false;
        a.backgroundColor = UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 1);
        a.isUserInteractionEnabled = true;
        
        return a;
    }();
    
    let captionLabel: UILabel = {
        let c = UILabel();
        c.translatesAutoresizingMaskIntoConstraints = false;
        c.textColor = .black;
        c.backgroundColor = UIColor(red: 239/255, green: 255/255, blue:245/255, alpha: 1);
        c.numberOfLines = 0;
        c.font = UIFont(name: c.font.fontName, size: 15);
        
        return c;
    }();
    
    let likesLabel: UILabel = {
        let l = UILabel();
        l.translatesAutoresizingMaskIntoConstraints = false;
        l.textColor = .black;
        l.backgroundColor = UIColor(red: 239/255, green: 255/255, blue:245/255, alpha: 1);
        
        return l;
    }();
    
    let uploaderLabel: UILabel = {
        let l = UILabel();
        l.translatesAutoresizingMaskIntoConstraints = false;
        l.textColor = .black;
        l.backgroundColor = UIColor(red: 239/255, green: 255/255, blue:245/255, alpha: 1);
        
        return l;
    }();

    
    
    
    public func setup() {
        addSubview(imageView);
        addSubview(captionLabel);
        addSubview(likesLabel);
        addSubview(uploaderLabel);
        
        sendSubview(toBack: captionLabel);
        sendSubview(toBack: likesLabel);
        sendSubview(toBack: uploaderLabel);
        
        imageView.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.width.equalTo(width);
            maker.height.equalTo(height);
            maker.centerX.equalTo(snp.centerX);
            maker.centerY.equalTo(snp.centerY);
        }
        uploaderLabel.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.width.equalTo(width);
            maker.height.equalTo(50);
            maker.top.equalTo(imageView.snp.bottom);
            maker.left.equalTo(snp.left);
            maker.right.equalTo(snp.right);
        }
        captionLabel.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.width.equalTo(width);
            maker.height.equalTo(50);
            maker.top.equalTo(uploaderLabel.snp.bottom);
            maker.left.equalTo(snp.left);
            maker.right.equalTo(snp.right);
        }
        likesLabel.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.width.equalTo(width);
            maker.height.equalTo(50);
            maker.top.equalTo(captionLabel.snp.bottom);
            maker.left.equalTo(snp.left);
            maker.right.equalTo(snp.right);
        }
    }
    
    
    
}
