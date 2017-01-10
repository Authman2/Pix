//
//  AUNavigationMenuCell.swift
//  TestingAUNavMenuCont
//
//  Created by Adeola Uthman on 11/24/16.
//  Copyright © 2016 Adeola Uthman. All rights reserved.
//

import UIKit
import Neon

public class AUNavigationMenuCell: UICollectionViewCell {
    
    
    // The menu item object (used for grabbing data).
    public var navMenuItem: NavigationMenuItem!;
    
    
    
    // The image that displays what page this cell will take you to.
    public let imageView: UIImageView = {
        let im: UIImageView = UIImageView();
        im.translatesAutoresizingMaskIntoConstraints = false;
        
        return im;
    }();
    
    
    // The name of the page
    public let textLabel: UILabel = {
        let t = UILabel();
        t.translatesAutoresizingMaskIntoConstraints = false;
        t.isUserInteractionEnabled = false;
        t.textAlignment = .center;
        
        return t;
    }();
    
    
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame);    }
    
    public override func awakeFromNib() {    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    public func setupLayout() {
        addSubview(imageView);
        addSubview(textLabel);
        
        textLabel.text = navMenuItem.name;
        if let img = navMenuItem.image {
            imageView.image = img;
        }
        
        imageView.anchorAndFillEdge(.top, xPad: 0, yPad: 5, otherSize: frame.height - 25);
        textLabel.align(.underCentered, relativeTo: imageView, padding: 0, width: frame.width, height: AutoHeight);
        
        translatesAutoresizingMaskIntoConstraints = false;
    }
    
    
    
    
}
