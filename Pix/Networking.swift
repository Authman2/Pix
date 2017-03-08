//
//  Networking.swift
//  PlanIt
//
//  This file contains methods that make saving, loading and just in general using Firebase easier. It
//  contains methods that perform very specific functions in our Firebase database, however they are
//  written so that anyone who isn't familiar with Firebase can still save and load data.
//
//  The class contains only static methods, which means that to use them you must call them by saying 
//  something like this:
//
//  func someFunction() {
//      Networking.methodName(parameters);
//  }
//
//
//  
//  Also note that some methods may return different values. These values can be used elsewhere in the 
//  app if it is deemed necessary.
//
//
//
//  Created by Adeola Uthman on 2/22/17.
//  Copyright © 2017 Miguel Guerrero. All rights reserved.
//

import Foundation
import UIKit
import Firebase


public class Networking {
    
    
    /***********************
     *                     *
     *                     *
     *      VARIABLES      *
     *                     *
     *                     *
     ***********************/
    
    /**
        The reference to the database that will be used to save/load files to/from there. This does not handle any data from the Authentication
        side or the Storage side of the app.
     */
    public static let fireRef: FIRDatabaseReference = FIRDatabase.database().reference();
    
    
    /**
        The reference to the media storage in Firebase. This is used for saving things like photos, videos, music, etc.
     */
    public static let storageRef: FIRStorageReference = FIRStorage.storage().reference();
    
    
    /**
        The currently logged in user in the form of a User object. This will allow us to get more information than just email, password, and userid.
     */
    public static var currentUser: User?;
    
    
    
    
    
    
    /**********************
    *                     *
    *                     *
    *       METHODS       *
    *                     *
    *                     *
    ***********************/
    
    
    /**
        Loads an object from Firebase as a JSON, then loads it into an NSDictionary. From there, you can use the extensions in the NSDictionary class to convert it to different objects.
     
        @parameters: {
            - path: The path, in Firebase, to the object you are trying to access.
            - success: When the program is able to successfully load an object.
            - failure: When the program fails to load an object.
        }
     */
    public static func loadObject(path: String, success: ((_ dictionary: NSDictionary)->Void)?, failure: (()->Void)?) {
        
        FIRDatabase.database().reference(withPath: path).observeSingleEvent(of: .value, with: { (snapshot: FIRDataSnapshot) in
            
            let value = snapshot.value as? NSDictionary;
            
            if let val = value {
                
                // Run the success block.
                if let s = success {
                    s(val);
                }
                
            } else {
                
                // Run the failure block.
                if let fail = failure {
                    fail();
                }
                
            }
        });
    }
    
    
    
    
    /**
        Handles saving an object to the Firebase database.
     
        @parameters: {
            - object: The object, as an NSDictionary, to be saved.
            - path: The path, in Firebase, to save the object to.
            - success: When the program is able to successfully load an object.
            - failure: When the program fails to load an object.
        }
     */
    public static func saveObject(object: NSDictionary, path: String, success: (()->Void)?, failure: ((_ err: Error)->Void)?) {
        
        FIRDatabase.database().reference(withPath: path).setValue(object) { (error: Error?, ref: FIRDatabaseReference) in
            
            if error == nil {
                
                // Run success block.
                if let s = success {
                    s();
                }
            } else {
                
                // Run failure block.
                if let fail = failure {
                    fail(error!);
                }
            }
            
        }
        
    }
    
    
    
}
