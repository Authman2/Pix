//
//  CommentsCell.swift
//  Pix
//
//  Created by Adeola Uthman on 2/16/17.
//  Copyright © 2017 Adeola Uthman. All rights reserved.
//

import UIKit
import SnapKit

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
        a.textColor = navContr.navigationBar.tintColor;
        a.backgroundColor = .white;
        a.numberOfLines = 0;
        a.font = UIFont(name: a.font.fontName, size: 12);
        
        return a;
    }();
    
    var commentLabel: UILabel = {
        let a = UILabel();
        a.translatesAutoresizingMaskIntoConstraints = false;
        a.textColor = navContr.navigationBar.tintColor;
        a.backgroundColor = .white;
        a.numberOfLines = 0;
        a.font = UIFont(name: a.font.fontName, size: 12);
        
        return a;
    }();
    
    
    
    /********************************
     *
     *          METHODS
     *
     ********************************/
    
    public func setup(string: String) {
        /* Get all the data needed. */
        self.commentString = string;
        let comps = commentString.components(separatedBy: " ");
        
        
        /* Put the right text on the labels. */
        nameLabel.text = "\(comps[0])";
        commentLabel.text = "\(comps[1])";
        
        
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
