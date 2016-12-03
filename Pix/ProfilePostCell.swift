//
//  ProfilePostCell.swift
//  Pix
//
//  Created by Adeola Uthman on 12/2/16.
//  Copyright © 2016 Adeola Uthman. All rights reserved.
//

import UIKit
import Neon

class ProfilePostCell: UICollectionViewCell {
    
    // The post object where all of the data is stored
    public var post: Post = Post();
    
    
    // The photo that is being uploaded
    private let photoView: UIImageView = {
        let img = UIImageView();
        img.contentMode = .scaleToFill;
        img.translatesAutoresizingMaskIntoConstraints = false;
        
        return img;
    }();
    
    
    
    
    
    
    /* DO NOT call this method UNTIL you set the post variable. */
    public func setupLayout() {
        addSubview(photoView);
        
        photoView.image = post.image!;
        
        photoView.anchorInCenter(width: frame.width, height: frame.height);
    }
    
    
}
