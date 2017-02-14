//
//  Ext.swift
//  Pix
//
//  Created by Adeola Uthman on 11/15/16.
//  Copyright © 2016 Adeola Uthman. All rights reserved.
//
//

import Foundation
import UIKit
import Spring
import DynamicColor
import IGListKit
import Hero


/* IDs that have already been used. */
var usedIds: [String] = [String]();

/* An array for displaying the user's activity. */
var notificationActivityLog: [NSDictionary] = [NSDictionary]();

let animations: [HeroDefaultAnimationType] = [.zoom, .zoomOut, .none];


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


extension UILabel: IGListDiffable {
    
    public func diffIdentifier() -> NSObjectProtocol {
        return self;
    }
    
    
    public func isEqual(toDiffableObject object: IGListDiffable?) -> Bool {
        return isEqual(object);
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

    /// Prints a debug message using a nice looking format.
    public func debug(message: Any) {
        print("----------> \(message)");
    }
}


public extension Array {
    
    public mutating func removeItem(item: String) {
        
        var i: Int = 0;
        for itm in self {
            
            i += 1;
            let s = itm as! String;
            
            if s == item {
                break;
            }
        }
        i -= 1;
        
        remove(at: i);
    }
    
    
    public mutating func removeItem(item: Post) {
        var i: Int = 0;
        for itm in self {
            
            i += 1;
            let s = itm as! Post;
            
            if s.id! == item.id! {
                break;
            }
        }
        i -= 1;
        
        remove(at: i);
    }
    
    
    public mutating func removePost(uid: String) {
        var i: Int = 0;
        for itm in self {
            
            i += 1;
            let s = itm as! Post;
            
            if s.id! == uid {
                break;
            }
        }
        i -= 1;
        
        remove(at: i);
    }
    
    
    public mutating func removePost(byUserWithID uid: String) {
        var i: Int = 0;
        for itm in self {
            
            i += 1;
            let s = itm as! Post;
            
            if s.uploader.uid == uid {
                break;
            }
        }
        i -= 1;
        
        remove(at: i);
    }
    
    
    public mutating func removeItem(item: Activity) {
        var i: Int = 0;
        for itm in self {
            
            i += 1;
            let s = itm as! Activity;
            
            if s.isEqual(toDiffableObject: item) {
                break;
            }
        }
        i -= 1;
        
        remove(at: i);
    }
    
    
    public mutating func removeUser(with uid: String) {
        var i: Int = 0;
        for itm in self {
            
            i += 1;
            let s = itm as! User;
            
            if s.uid == uid {
                break;
            }
        }
        i -= 1;
        
        remove(at: i);
    }
    
    
    
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
    
    /* Returns true or false if the array contains a Post object that has the id specified in the parameter. */
    public func containsID(id: String) -> Bool {
        
        for itm in self {
            let temp = itm as! Post;
            
            if temp.id == id {
                return true;
            }
        }
        
        return false;
    }
    
    
    /* Returns whether or not this array contains a user with this username. */
    public func containsUsername(username: String) -> Bool {
        
        for itm in self {
            let temp = itm as! String;
            
            if temp == username {
                return true;
            }
        }
        
        return false;
    }
    
    /* Returns whether or not this array contains a user with this username. */
    public func containsUser(username: String) -> Bool {
        
        for itm in self {
            let temp = itm as! User;
            
            if temp.username == username {
                return true;
            }
        }
        
        return false;
    }
    
    
    
    /* Returns the index of the element. */
    public func indexOf(activity: Activity) -> Int {
        var i = 0;
        for itm in self {
            let temp = itm as! NSDictionary;
            let actObj = temp.toActivity();
            
            if actObj.id! == activity.id! {
                return i;
            }
            i += 1;
        }

        return -1;
    }
    
    
    /* Returns whether or not an activity is already in the array. */
    public func containsActivity(activity: Activity) -> Bool {
        
        for itm in self {
            let temp = itm as! Activity;
            
            if temp.isEqual(toDiffableObject: activity) {
                return true;
            }
        }
        
        return false;
    }
    
    
}


public extension NSDictionary {
    
    /* Converts an NSDictionary into a User object. */
    public func toUser() -> User {
        let firstName = value(forKey: "first_name") as? String ?? "";
        let lastName = value(forKey: "last_name") as? String ?? "";
        let uid = value(forKey: "userid") as? String ?? "";
        let username = value(forKey: "username") as? String ?? "";
        let em = value(forKey: "email") as? String ?? "";
        let pass = value(forKey: "password") as? String ?? "";
        let profPic = value(forKey: "profile_picture") as? String ?? "";
        let followers = value(forKey: "followers") as? [String] ?? [];
        let following = value(forKey: "following") as? [String] ?? [];
        let likedPhotos = value(forKey: "liked_photos") as? [String] ?? [];
        let blocked = value(forKey: "blocked") as? [String] ?? [];
        let notifID = value(forKey: "notification_id") as? String ?? "";
        let privateAcc = value(forKey: "is_private") as? Bool ?? false;
        
        
        let user = User(first: firstName, last: lastName, username: username, email: em);
        user.uid = uid;
        user.password = pass;
        user.profilePicName = profPic;
        user.followers = followers;
        user.following = following;
        user.likedPhotos = likedPhotos;
        user.blockedUsers = blocked;
        user.notification_ID = notifID;
        user.isPrivate = privateAcc;
    
        return user;
    }
    
    
    /* Converts an NSDictionary into a Post object. Requires the uploader of the post to be passed in as a parameter. Does NOT set the profile picture image. */
    public func toPost(user: User) -> Post {
        let id = value(forKey: "id") as? String ?? "";
        let caption = value(forKey: "caption") as? String ?? "";
        let likes = value(forKey: "likes") as? Int ?? 0;
        let isProfPic = value(forKey: "is_profile_picture") as? Bool ?? false;
        let flags = value(forKey: "flags") as? Int ?? 0;
        
        
        let post = Post(photo: nil, caption: caption, Uploader: user, ID: id);
        post.isProfilePicture = isProfPic;
        post.flags = flags;
        post.likes = likes;
        
        return post;
    }
    
    
    /* Converts an NSDictionary into an Activity object. */
    public func toActivity() -> Activity {
        let t = value(forKey: "text") as? String ?? "";
        let id = value(forKey: "id") as? String ?? "";
        let iReq = value(forKey: "interaction_required") as? Bool ?? false;
        let iWith = value(forKey: "interacted_with") as? Bool ?? false;
        
        let temp = value(forKey: "user") as? NSDictionary ?? [:];
        let user = temp.toUser();
        
        let act = Activity(text: t, interactionRequired: iReq);
        act.id = id;
        act.interactedWith = iWith;
        act.user = user;
        
        return act;
    }
}


public enum followDirection {
    
    case toFrom; // The one who clicks the follow button gets the next user added to their FOLLOWING.
    case fromTo; // The one who clicks the follow button gets the next user added to their FOLLOWERS.
    
}
