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
    public func indexOf(string: String) -> Int {
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
    public func substring(i: Int, j: Int) -> String {
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



public extension NSObject {
    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func ==(lhs: NSObject, rhs: NSObject) -> Bool {
        if lhs.isEqual(rhs) {
            return true;
        }
        
        return false;
    }

}


public extension Array {
    
    /// Returns whether or not the array contains the given object.
    public func contains(item: NSObject) -> Bool {
        var b = false;
        
        for itm in self {
            let tempItm = itm as! NSObject;
            
            if tempItm.isEqual(item) {
                b = true;
                break;
            }
        }
        
        
        return b;
    }
    
    
}
