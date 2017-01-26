//
//  BasicAlertView.swift
//  Pix
//
//  Created by Adeola Uthman on 1/25/17.
//  Copyright © 2017 Adeola Uthman. All rights reserved.
//

import Foundation
import UIKit
import Neon

class BasicAlertView: UIViewController {
    
    let titleLabel: UILabel = {
        let a = UILabel();
        a.translatesAutoresizingMaskIntoConstraints = false;
        a.textAlignment = .center;
        a.textColor = UIColor(red: 41/255, green: 200/255, blue: 153/255, alpha: 1);
        
        return a;
    }();

    
    
    public func setup() {
        view.backgroundColor = .white;
        view.addSubview(titleLabel);
        titleLabel.anchorInCenter(width: view.width, height: view.height);
    }
    
}
