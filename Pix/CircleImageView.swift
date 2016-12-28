//
//  CircleImageView.swift
//  Pix
//
//  Created by Adeola Uthman on 12/28/16.
//  Copyright © 2016 Adeola Uthman. All rights reserved.
//

import Foundation
import UIKit


class CircleImageView: UIImageView {

    
    override func layoutSubviews() {
        super.layoutSubviews();
        
        layer.cornerRadius = min(self.frame.width/2 , self.frame.height/2)
        clipsToBounds = true;
    }
    
    
    
}
