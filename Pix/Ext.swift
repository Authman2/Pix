//
//  Ext.swift
//  Pix
//
//  Created by Adeola Uthman on 11/15/16.
//  Copyright © 2016 Adeola Uthman. All rights reserved.
//
//
// An extension to the String class
//
//

import Foundation
import UIKit
import Spring


public extension String {
    
    /* Returns the length of the string. */
    public func length() -> Int {
        var l = 0;
        
        // Loop through each character and add 1.
        for _ in self.characters {
            l += 1;
        }
        
        return l;
    }
    
    
    
    /* Returns an integer of the index of the given string. */
    public mutating func indexOf(string: String) -> Int {
        var ind = -1;
        var i = -1;
        
        for s in self.characters {
            i += 1;
            if(s.description == string) {
                ind = i;
                break;
            }
        }
        
        return ind;
    }
    
    
    
    /* Returns a certain part of the string */
    public mutating func substring(i: Int, j: Int) -> String {
        var result = "";
        var chars = Array(self.characters);
        var indx = i;
        
        for _ in i...j-1 {
            result += "\(chars[indx])";
            indx += 1;
        }
        
        return result;
    }
    
}


public extension SpringButton {
    
    public func animateButtonClick() {
        self.animation = "pop";
        self.curve = "spring";
        self.duration = 1.0;
        self.animate();
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [], animations: {
            
            self.backgroundColor = self.backgroundColor?.darkened();
            
        }, completion: { (bool: Bool) in
            
            UIView.animate(withDuration: 0.2, delay: 0.0, options: [], animations: {
                
                self.backgroundColor = self.backgroundColor?.lighter();
                
            }, completion: nil);
            
        });
    }
    
    
}


public extension Array {
    
    public func contains(item: AnyObject) -> Bool {
        var b = false;
        var s = "";
        let target = "\(item)";
        
        for itm in self {
            s += "\(itm)";
        }
        
        if(s.contains(target)) {
            b = true;
        }
        
        
        
        return b;
    }
    
    
}
