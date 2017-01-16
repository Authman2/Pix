//
//  EmptyView.swift
//  Pix
//
//  Created by Adeola Uthman on 1/7/17.
//  Copyright © 2017 Adeola Uthman. All rights reserved.
//

import UIKit
import Neon

class EmptyPhotoView: UIView {

    let titleLabel: UILabel = {
        let a = UILabel();
        a.translatesAutoresizingMaskIntoConstraints = false;
        a.text = "No photos to display";
        a.textAlignment = .center;
        a.textColor = UIColor(red: 41/255, green: 200/255, blue: 153/255, alpha: 1);
        
        return a;
    }();
    
    enum placement {
        case top;
        case center;
    }
    
    
    var place: placement?;
    
    
    init(place: placement) {
        super.init(frame: CGRect.zero);
        self.place = place;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        addSubview(titleLabel);
        
        if place == .center {
            titleLabel.anchorInCenter(width: width, height: height);
        } else {
            titleLabel.anchorToEdge(.top, padding: 0, width: width, height: height);
        }
    }
    
}

class EmptyActivityView: UIView {
    
    let titleLabel: UILabel = {
        let a = UILabel();
        a.translatesAutoresizingMaskIntoConstraints = false;
        a.text = "No recent activity";
        a.textAlignment = .center;
        a.textColor = .black;
        
        return a;
    }();
    
    
    
    
    override func layoutSubviews() {
        addSubview(titleLabel);
        titleLabel.anchorInCenter(width: width, height: height);
    }
    
}

