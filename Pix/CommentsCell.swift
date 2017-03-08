//
//  CommentsCell.swift
//  Pix
//
//  Created by Adeola Uthman on 2/16/17.
//  Copyright © 2017 Adeola Uthman. All rights reserved.
//

import UIKit
import SnapKit
import ChameleonFramework

class CommentsCell: UICollectionViewCell {
    
    /********************************
     *
     *          VARIABLES
     *
     ********************************/
    
    var commentString: String!;

    
    var nameLabel: UILabel = {
        let a = UILabel();
        a.translatesAutoresizingMaskIntoConstraints = false;
        a.textColor = UIColor.flatWhite;
        a.numberOfLines = 0;
        a.font = UIFont(name: a.font.fontName, size: 12);
        
        return a;
    }();
    
    var commentLabel: UILabel = {
        let a = UILabel();
        a.translatesAutoresizingMaskIntoConstraints = false;
        a.textColor = UIColor.flatWhite;
        a.numberOfLines = 0;
        a.font = UIFont(name: a.font.fontName, size: 12);
        
        return a;
    }();
    
    
    
    /********************************
     *
     *          METHODS
     *
     ********************************/
    
    public func setup(string: String?) {

        if let s = string {
            /* Get all the data needed. */
            self.commentString = s;
            let id = commentString.substring(i: 0, j: self.commentString.indexOf(string: " "));
            let comment = commentString.substring(i: self.commentString.indexOf(string: " ")+1, j: self.commentString.length());
            var name = "";
            
            /* Quickly get a user object. */
            Networking.loadUserWithId(id: id, success: { (usr: User) in
                name = "\(usr.firstName) \(usr.lastName)";
                
                /* Put the right text on the labels. */
                self.nameLabel.text = "\(name)";
                self.commentLabel.text = "\(comment)";
                
            }, failure: nil);
            
        }
        backgroundColor = UIColor.flatGrayDark;
        
        /* Add the elements to the view. */
        addSubview(nameLabel);
        addSubview(commentLabel);
        
        
        /* Layout with SnapKit. */
        nameLabel.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.left.equalTo(snp.left).offset(5);
            maker.top.equalTo(snp.top).offset(5);
            maker.width.equalTo(snp.width);
            maker.height.equalTo(20);
        }
        commentLabel.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.left.equalTo(snp.left).offset(5);
            maker.top.equalTo(nameLabel.snp.bottom);
            maker.width.equalTo(snp.width);
            maker.bottom.equalTo(snp.bottom);
        }
    }
    
    
    
}
