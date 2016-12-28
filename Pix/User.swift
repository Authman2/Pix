//
//  User.swift
//  Pix
//
//  Created by Adeola Uthman on 12/22/16.
//  Copyright © 2016 Adeola Uthman. All rights reserved.
//

import Foundation
import UIKit



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
    
    
    /* The user's username. */
    var username: String = String();
    
    
    /* The user's email. */
    var email: String = String();
    
    
    /* The user's password. */
    var password: String = String();
    
    
    /* All of the user's followers. */
    var followers: [String] = [String]();
    
    
    /* All of the people this user is following. */
    var following: [String] = [String]();
    
    
    /* All of the user's posts (in the form of firebase data). */
    let posts_fb: NSMutableArray! = NSMutableArray();
    
    
    /* All of the user's posts (in the form of a Post object). */
    var posts: [Post] = [Post]();
    
    
    /* An image for the profile picture. */
    var profilepic: UIImage!;
    var profilePicName: String!;
    
    
    
    
    
    /********************************
     *
     *          METHODS
     *
     ********************************/
    
    init(first: String, last: String, username: String, email: String) {
        super.init();
        self.firstName = first;
        self.lastName = last;
        self.username = username;
        self.email = email;
        self.profilePicName = self.randomName();
        self.profilepic = UIImage(named: "friends_icon@3x.png");
    }
    
    
    
    func toDictionary() -> NSDictionary {
        let dict = NSDictionary(dictionary: ["first_name" : firstName,
                                             "last_name" : lastName,
                                             "username" : username,
                                             "email" : email,
                                             "password" : password,
                                             "profile_picture" : profilePicName,
                                             "followers" : followers,
                                             "following" : following]);
        return dict;
    }
    
    
    func toString() -> String {
        return "Name: \(firstName) \(lastName), Username: \(username), Email: \(email), Password: \(password)";
    }
    
    
    
    /* A random id for each post. */
    private func randomName() -> String {
        var id = "";
        let arr: [String] = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","1","2","3","4","5","6","7","8","9","0"];
        
        while id.length() < 15 {
            let random = arc4random_uniform(UInt32(arr.count));
            id += arr[Int(random)];
        }
        
        return id;
    }
        
}
