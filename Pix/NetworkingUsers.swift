//
//  NetworkingUsers.swift
//  PlanIt
//
//  Created by Adeola Uthman on 2/25/17.
//  Copyright © 2017 Miguel Guerrero. All rights reserved.
//

import Foundation
import UIKit
import Firebase



/** This extension handles user operations. */
public extension Networking {
    
    /**
     Creates a new user in the Firebase database and authentication.
     
     @parameters: {
     - user --> The User object to save to Firebase.
     - success --> An optional success block. Whatever code is inside of the success block will be executed once the user is successfully created.
     - failure --> An optional failure block. If, for some reason, the program is not able to create a user successfully, it will carry out whatever code is contained in this failure block.
     }
     */
    public static func createUser(user: User, success: (()->Void)?, failure: (()->Void)?) {
        // First, create a user using Firebase Auth.
        FIRAuth.auth()?.createUser(withEmail: user.email, password: user.password, completion: { (final_usr: FIRUser?, err: Error?) in
            
            // If there is an error, run the failure block (if it is not nil).
            if err != nil {
                if let fail = failure {
                    fail();
                }
            }
                
                // Otherwise, add the user to the database, as well. Then run the success block if it has been configured.
            else {
                
                // First, remember to set the user id from Firebase.
                user.uid = (final_usr?.uid)!;
                //user.profilePicName = (final_usr?.photoURL?.absoluteString)!;
                user.profilepic = UIImage(named: "friends_icon@3x.png");
                
                // Now save to the database.
                fireRef.child("Users").child(user.uid).setValue(user.toDictionary(), withCompletionBlock: { (err2: Error?, ref: FIRDatabaseReference) in
                    
                    if err2 == nil {
                        // Run the success block.
                        if let s = success {
                            s();
                        }
                    }
                    
                }); // End of database saving.
            }
            
        });
    }
    
    
    
    
    /**
     Creates a new user in the Firebase database and authentication.
     
     @parameters: {
     - username: The username that the user will choose upon registration.
     - password: The password that the user will choose upon registration.
     - email: The user's email address.
     - success: An optional success block. Whatever code is inside of the success block will be executed once the user is successfully created.
     - failure: An optional failure block. If, for some reason, the program is not able to create a user successfully, it will carry out whatever code is contained in this failure block.
     }
     */
    public static func createUser(firstName: String, lastName: String, username: String, password: String, email: String, success: (()->Void)?, failure: (()->Void)?) {
        // First, create a user using Firebase Auth.
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (final_usr: FIRUser?, err: Error?) in
            
            // If there is an error, run the failure block (if it is not nil).
            if err != nil {
                if let fail = failure {
                    fail();
                }
            }
                
                // Otherwise, add the user to the database, as well. Then run the success block if it has been configured.
            else {
                
                // Make a user object.
                let user = User(first: firstName, last: lastName, username: username, email: email);
                user.password = password;
                user.profilePicName = (final_usr?.photoURL?.absoluteString)!;
                
                // Now save to the database.
                fireRef.child("Users").child(user.uid).setValue(user.toDictionary(), withCompletionBlock: { (err2: Error?, ref: FIRDatabaseReference) in
                    
                    if err2 == nil {
                        // Run the success block.
                        if let s = success {
                            s();
                        }
                    }
                    
                }); // End of database saving.
            }
            
        });
    }
    
    
    
    
    /**
     Signs the user into the Firebase authentication. ALso updates the "currentUser" variable so that the iOS device has a reference to the current user object.
     
     @parameters: {
     - withEmail: The email of the user that you are trying to sign in.
     - andPassword: The password of the user that you are trying to sign in.
     - success: The block of code that will run when the user is successfully signed in.
     - failure: The block of code to be executed when there is a problem signing in.
     }
     */
    public static func loginUser(withEmail: String, andPassword: String, success: (()->Void)?, failure: (()->Void)?) {
        
        FIRAuth.auth()?.signIn(withEmail: withEmail, password: andPassword, completion: { (user: FIRUser?, error: Error?) in
            
            // If there was an error signing in, run the failure block.
            if error != nil {
                if let fail = failure {
                    fail();
                }
            }
                // Otherwise, if there was no error, log the user in and update the currentUser variable.
            else {
                
                if let usr = user {
                    // Try loading the information for the user with the specified id. If it works, run the success block, otherwise run the failure block.
                    self.loadUserWithId(id: usr.uid, success: { (loadedUser: User) in
                        currentUser = loadedUser;
                        
                        if let s = success {
                            s();
                        }
                    }, failure: {
                        if let f = failure {
                            f();
                        }
                    });
                }
            }
        })
        
    }
    
    
    
    
    
    /**
     Updates a user in Firebase. This doesn't handle changing any information. Instead, it just takes a User object (with information that could have been changed elsewhere) and updates it in the database.
     @parameters: {
     - user: The User object to be updated.
     }
     */
    public static func updateUserInFirebase(user: User) {
        fireRef.child("Users").child(user.uid).updateChildValues(user.toDictionary() as! [AnyHashable : Any]);
    }
    
    
    
    
    /** Refreshes a User object so that it has all of the current information from Firebase.
     
     @parameters: {
     - user: The User object that needs to have it's information refreshed.
     - success: For when the user was successfully refreshed. Uses a "User in" callback so that you can do something with the user object that was just refreshed.
     - failure: For when the program fails to refresh the user.
     }
     */
    public static func refreshUser(user: User, success: ((_ user: User)->Void)?, failure: (()->Void)?) {
        self.loadUserWithId(id: user.uid, success: { (usr: User) in
            if let s = success {
                s(user);
            }
        }, failure: {
            if let fail = failure {
                fail();
            }
        });
    }
    
    
    
    
    /**
     Updates the current user in the database.
     */
    public static func updateCurrentUserInFirebase() {
        if let cUser = currentUser {
            self.updateUserInFirebase(user: cUser);
            FIRAuth.auth()?.currentUser?.updateEmail(cUser.email, completion: { (err: Error?) in
                
            })
            FIRAuth.auth()?.currentUser?.updatePassword(cUser.password, completion: { (err: Error?) in
                
            })
        }
    }
    
    
    
    
    /**
     Refreshes the curret user object so that it has all of the current information from Firebase.
     
     @parameters: {
     - success: When the current user was successfully refreshed.
     - failure: When there is a problem refreshing the current user.
     }
     */
    public static func refreshCurrentUser(success: ((_ user: User)->Void)?, failure: (()->Void)?) {
        if let cUser = currentUser {
            self.refreshUser(user: cUser, success: success, failure: failure);
        }
    }
    
    
    
    
    /**
     Handles loading a user with the specified email address. Based on the structure of our database, this method would search through each user until it finds the one with the right email.
     
     @parameters: {
     - email: The email of the user you are trying to find.
     - success: The block to run when the user is successfully loaded. It uses a "User in" callback so that you can perform actions with the user that is loaded.
     - failure: For when the program fails to load a user for whatever reason.
     }
     */
    public static func loadUserWithEmail(email: String, success: ((_ user: User)->Void)?, failure: (()->Void)?) {
        fireRef.child("Users").observeSingleEvent(of: .value, with: { (snapshot: FIRDataSnapshot) in
            let userDictionary = snapshot.value as? [String : AnyObject] ?? [:];
            
            for user in userDictionary {
                let value = user.value as? NSDictionary ?? [:];
                let usr = value.toUser();
                
                if usr.email == email {
                    if let s = success {
                        s(usr);
                        break;
                    }
                }
                
            } // End of user for-loop.
        }) { (err: Error) in
            if let fail = failure {
                fail();
            }
        }
    }
    
    
    
    /**
     Handles loading a user with the specified user id. This method should be much faster than the "loadUserWithEmail" method because of the structure of our database.
     
     @parameters: {
     - id: The user id of the user you are trying to load.
     - success: What to do when a user is successfully loaded. It uses a "User in" callback so that you can perform actions with the user that is loaded.
     - failure: What to do when Firebase fails to load the user.
     }
     */
    public static func loadUserWithId(id: String, success: ((_ user: User)->Void)?, failure: (()->Void)?) {
        fireRef.child("Users").child(id).observeSingleEvent(of: .value, with: { (snapshot: FIRDataSnapshot) in
            
            let value = snapshot.value as? NSDictionary;
            
            if let v = value {
                let user = v.toUser();
                
                if let s = success {
                    s(user);
                }
            }
            
        });
    }
    
    
}
