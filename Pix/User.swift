//
//  User.swift
//  Pix
//
//  Created by Adeola Uthman on 11/15/16.
//  Copyright © 2016 Adeola Uthman. All rights reserved.
//
//  This class represents a single user. Contains all of the data necessary to define what a user is.
//  - First name
//  - Last name
//  - Email
//  - The user ID
//

import Foundation
import UIKit


class User {
    
    // The first name of the user
    var firstName: String!;
    
    
    // The last name of the user
    var lastName: String!;
    
    
    // The email of the user
    var email: String!;
    
    
    // The user's unique ID
    var id: String?;
    
    
    
    
    
    
    ///////// Constructors /////////
    
    init() {
        id = createId();
    }
    
    init(firstName: String, lastName: String, email: String) {
        self.firstName = firstName;
        self.lastName = lastName;
        self.email = email;
        self.id = createId();
    }
    
    
    
    
    
    
    
    ///////// Setters /////////
    
    private func createId() -> String {
        var id = "";
        let arr: [String] = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","1","2","3","4","5","6","7","8","9","0"];
        
        while id.length() < 15 {
            let random = arc4random_uniform(UInt32(arr.count));
            id += arr[Int(random)];
        }
        
        return id;
    }
    
}
