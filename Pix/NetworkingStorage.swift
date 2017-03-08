//
//  NetworkingStorage.swift
//  PlanIt
//
//  Created by Adeola Uthman on 2/25/17.
//  Copyright © 2017 Miguel Guerrero. All rights reserved.
//

import Foundation
import UIKit
import Firebase



/** This extension handles media storage. */
public extension Networking {
    
    
    /**
     Takes a UIImage as the input and saves it into the Firebase storage under the folder (userID)/imageID.     
     @parameters: {
     - img: The UIImage that is to be saved.
     - toUser: The user who needs to have the photo saved to.
     - success: When the image is successfully saved.
     - failure: When there is an error saving the image.
     }
     */
    public static func saveImageToFirebase(img: UIImage, toUser: User, success: (()->Void)?, failure: (()->Void)?) {
        
        let ref = storageRef.child("\(toUser.uid)/\(toUser.profilePicName!).jpg");
        let data = UIImageJPEGRepresentation(img, 100) as NSData?;
        
        let _ = ref.put(data! as Data, metadata: nil) { (metaData, error) in
            
            if error == nil {
                
                fireRef.child("Users").child(toUser.uid).setValue(toUser.toDictionary(), withCompletionBlock: { (err: Error?, ref: FIRDatabaseReference) in
                    
                    if err == nil {
                        
                        // Run the success block
                        if let s = success {
                            s();
                        }
                        
                    } else {
                        
                        // Also run the failure block if it can't save to the database.
                        if let fail = failure {
                            fail();
                        }
                        
                    }
                    
                });
                
            } else {
                
                // Run the failure block.
                if let fail = failure {
                    fail();
                }
                
            }
        }
    }
    
    
    
    
    /**
     Loads the image with the specified ID from a user. There is a 50gb limit on loading photos. This can be changed easily, however I am not currently sure how this will affect performance. The success block has a UIImage callback so that you can do something with the loaded image.
     
     @parameters: {
     - withID: The id of the photo.
     - fromUser: The user who owns the photo.
     - success: When the image is successfully loaded.
     - failure: When there is an error saving the image.
     }
     */
    public static func loadImage(withID: String, fromUser: User, success: ((_ img: UIImage)->Void)?, failure: (()->Void)?) {
        let imgRef = storageRef.child("\(fromUser.uid)/\(withID).jpg");
        imgRef.data(withMaxSize: 50 * 1024 * 1024, completion: { (data: Data?, err2: Error?) in
            
            if err2 == nil {
                
                if let d = data {
                    
                    // Set the image of the post.
                    let loadedImage = UIImage(data: d)!;
                    
                    // Run the success block
                    if let s = success {
                        s(loadedImage);
                    }
                    
                }
                
            } else {
                // Run the failure block
                if let fail = failure {
                    fail();
                }
            }
        });
    }
    
    
    
}
