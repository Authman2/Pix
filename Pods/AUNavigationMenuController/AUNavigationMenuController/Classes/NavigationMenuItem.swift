//
//  NavigationMenuItem.swift
//  TestingAUNavMenuCont
//
//  Created by Adeola Uthman on 11/25/16.
//  Copyright © 2016 Adeola Uthman. All rights reserved.
//

import Foundation
import UIKit


public class NavigationMenuItem: NSObject {
    
    // The name of the menu item.
    public var name: String!;
    
    
    // The iamge that goes along with the menu item.
    public var image: UIImage?;
    
    
    // The destination view controller for when this menu item is tapped.
    public var destination: UIViewController!;
    
    
    // The overall navigation controller.
    let navCont: AUNavigationMenuController!;
    
    
    // The completion method.
    var completion: (() -> Void)?;
    
    
    
    
    
    /////////////////////////
    //
    //  Methods
    //
    /////////////////////////
    
    init(name: String, image: UIImage?, navCont: AUNavigationMenuController, destination: UIViewController, completion: (() -> Void)?) {
        self.name = name;
        self.image = image;
        self.destination = destination;
        self.navCont = navCont;
        self.completion = completion;
        navCont.navigationItem.hidesBackButton = true;
    }
    
    
    
    /* Goes to the destination view controller.
     */
    public func goToDestination(toggle: Bool) {
        
        if navCont.topViewController != destination {
            
            navCont.popToRootViewController(animated: false);
            navCont.pushViewController(destination, animated: false);
            destination.navigationItem.hidesBackButton = true;
            
            if(toggle) {
                navCont.togglePulldownMenu();
            }
        } else {
            navCont.togglePulldownMenu();
        }
        
        if let comp = completion {
            comp();
        }
    }
    
}
