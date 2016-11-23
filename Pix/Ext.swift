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
