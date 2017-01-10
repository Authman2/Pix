//
//  AUNavigationMenuOptions.swift
//  Pods
//
//  Created by Adeola Uthman on 1/4/17.
//
//

import Foundation
import UIKit


public class AUNavigationMenuOptions: NSObject {
    
    /// Color of the text. Black by default.
    public var itemTextColor: UIColor?;
    
    
    /// The amount of spacing between menu cells.
    public var itemSpacing: CGFloat?;
    
    
    /// The size of the menu items.
    public var itemSize: CGSize?;
    
    
    /// How far down the menu will drop from the top of the screen.
    public var pullAmount: CGFloat?;
    
    
    
    
    public override init() {
        super.init();
    }
    
    
    
}
