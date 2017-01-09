//
//  FollowRequestCellTableViewCell.swift
//  Pix
//
//  Created by Adeola Uthman on 1/8/17.
//  Copyright © 2017 Adeola Uthman. All rights reserved.
//

import UIKit
import SnapKit
import Firebase


class ActivityCell: UICollectionViewCell {
    
    /********************************
     *
     *          VARIABLES
     *
     ********************************/
    
    let titleLabel: UILabel = {
        let a = UILabel();
        a.translatesAutoresizingMaskIntoConstraints = false;
        a.numberOfLines = 0;
        a.textColor = .black;
        a.textAlignment = .left;
        
        return a;
    }();
    
    
    
    
    
    /********************************
     *
     *          METHODS
     *
     ********************************/
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        backgroundColor = .white;
        addSubview(titleLabel);
        
        titleLabel.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.left.equalTo(snp.left).offset(10);
            maker.top.equalTo(snp.top);
            maker.right.equalTo(snp.right);
            maker.bottom.equalTo(snp.bottom);
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
