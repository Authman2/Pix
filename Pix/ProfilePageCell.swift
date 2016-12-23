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
    
    let imageView: UIImageView = {
        let a = UIImageView();
        a.translatesAutoresizingMaskIntoConstraints = false;
        a.backgroundColor = UIColor.gray;
        a.isUserInteractionEnabled = true;
        
        return a;
    }();
    
    
    
    
    
    public func setup() {
        addSubview(imageView);
        imageView.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.width.equalTo(width);
            maker.height.equalTo(height);
            maker.centerX.equalTo(snp.centerX);
            maker.centerY.equalTo(snp.centerY);
        }
    }
    
    
    
}
