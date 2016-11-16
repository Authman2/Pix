//
//  StringExt.swift
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
    
    /// Returns the length of the string.
    public func length() -> Int {
        var l = 0;
        
        // Loop through each character and add 1.
        for _ in self.characters {
            l += 1;
        }
        
        return l;
    }
    
    
}
