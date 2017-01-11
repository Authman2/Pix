//
//  BlockedUserCell.swift
//  Pix
//
//  Created by Adeola Uthman on 1/11/17.
//  Copyright © 2017 Adeola Uthman. All rights reserved.
//

import Foundation
import UIKit
import Neon



public class BlockedUserCell: UICollectionViewCell {
    
    
    var blockedLabel: UILabel = {
        let a = UILabel();
        a.translatesAutoresizingMaskIntoConstraints = false;
        a.textColor = .black;
        a.font = UIFont(name: (a.font?.fontName)!, size: 15);
        a.textAlignment = .left;
        
        return a;
    }();
    
    
    
    
    
    
    override public init(frame: CGRect) {
        super.init(frame: frame);
        
        addSubview(blockedLabel);
        blockedLabel.anchorToEdge(.left, padding: 10, width: width, height: height);
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
}
