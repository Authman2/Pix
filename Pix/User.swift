//
//  User.swift
//  Pix
//
//  Created by Adeola Uthman on 12/22/16.
//  Copyright © 2016 Adeola Uthman. All rights reserved.
//

import Foundation




/* A global variable for the current user. */
var currentUser: User!;


public class User: NSObject {
    
    /********************************
     *
     *          VARIABLES
     *
     ********************************/
    
    /* The user's first name. */
    var firstName: String = String();
    
    
    /* THe user's last name. */
    var lastName: String = String();
    
    
    /* The user's email. */
    var email: String = String();
    
    
    /* The user's password. */
    var password: String = String();
    
    
    /* All of the user's followers. */
    var followers: [User] = [User]();
    
    
    /* All of the people this user is following. */
    var following: [User] = [User]();
    
    
    /* All of the user's posts (in the form of firebase data). */
    let posts_fb: NSMutableArray! = NSMutableArray();
    
    
    /* All of the user's posts (in the form of a Post object). */
    let posts: [Post] = [Post]();
    
    
    
    
    
    
    /********************************
     *
     *          METHODS
     *
     ********************************/
    
    init(first: String, last: String, email: String) {
        self.firstName = first;
        self.lastName = last;
        self.email = email;
    }
    
    
    
    func toDictionary() -> NSDictionary {
        let dict = NSDictionary(dictionary: ["first_name" : firstName,
                                             "last_name" : lastName,
                                             "email" : email,
                                             "password" : password,
                                             "followers" : followers,
                                             "following" : following]);
        return dict;
    }
    
        
}
