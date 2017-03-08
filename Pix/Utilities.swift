//
//  Utilities.swift
//  Pix
//
//  Created by Adeola Uthman on 1/14/17.
//  Copyright © 2017 Adeola Uthman. All rights reserved.
//

import Foundation
import UIKit
import Firebase


// A global reference to the utilities class.
let util = Utilities();


class Utilities: NSObject {

    let fireRef: FIRDatabaseReference = FIRDatabase.database().reference();
    
    
    
    /** Loads all of the current user's photos from the firebase database. This method is public, and
     therefore should be used in any other class that needs to refresh the user's posts.
     PRECONDITION: current user is already initialized to the user that just logged in. */
    public func loadUsersPhotos(user: User, continous: Bool, completion: (()->Void)?) {
        
        // Start from the beginning.
        //user.posts.removeAll();
        
        // Profile picture stuff.
        var profPicPost: Post?;
        
        
        // Load all of the photo objects from the database.
        if continous == false {
            fireRef.child("Photos").child(user.uid).queryOrderedByPriority().observeSingleEvent(of: .value) { (snapshot: FIRDataSnapshot) in
                
                // First, make sure there is a value for the posts. If so, then load all of them.
                let postDictionary = snapshot.value as? [String : AnyObject] ?? [:];
                
                
                // Get each post from the database (in the form of json data).
                for post in postDictionary {
                    
                    // Get each individual post as a dictionary of elements with the form [key : value].
                    let value = post.value as? NSDictionary;
                    
                    // Get a post object.
                    let aPost = value?.toPost(user: user);
                    
                    // Check if the user object already has this post. If so, update it and move on.
                    // Otherwise, load it up from firebase.
                    if user.posts.containsID(id: aPost!.id!) {
                        
                        continue;
                        
                        
                    } else {
                        // Load the image for the post.
                        aPost?.photo = self.loadPostImage(user: user, aPost: aPost, success: {
                            self.debug(message: "[Loaded the image data for \(aPost!.id!)]");
                        }, error: nil);
                        
                        // If this post (determined by the id variable) is not already in the array, add it.
                        if(!user.posts.containsID(id: aPost!.id!)) {
                            
                            // Make sure it is not the profile picture. Otherwise just set that for the user here.
                            if(aPost?.isProfilePicture == false) {
                                
                                user.posts.append(aPost!);
                                self.debug(message: "Loaded: \(aPost!.toString())");
                                
                            } else {
                                
                                profPicPost = aPost;
                                
                            }
                        }
                    }
                } // End of for loop for each post.
                
                
                // Load the profile picture.
                if let prof = profPicPost {
                    let _ = self.loadPostImage(user: user, aPost: prof, success: {
                        
                        user.profilepic = prof.photo;
                        user.profilePicName = prof.id;
                        self.debug(message: "Sucessfully loaded profile picture!");
                        
                        // Run the completion block.
                        if let comp = completion {
                            comp();
                        }
                        
                    }, error: nil); // End of loading the profile picture.
                    
                } // End of the profile picture checker.
                else {
                    // Run the completion block.
                    if let comp = completion {
                        comp();
                    }
                }
            };
        } else {
            
            fireRef.child("Photos").child(user.uid).queryOrderedByPriority().observe(.value) { (snapshot: FIRDataSnapshot) in
                
                // First, make sure there is a value for the posts. If so, then load all of them.
                let postDictionary = snapshot.value as? [String : AnyObject] ?? [:];
                
                
                // Get each post from the database (in the form of json data).
                for post in postDictionary {
                    
                    // Get each individual post as a dictionary of elements with the form [key : value].
                    let value = post.value as? NSDictionary;
                    
                    // Get a post object.
                    let aPost = value?.toPost(user: user);
                    
                    // Check if the user object already has this post. If so, update it and move on.
                    // Otherwise, load it up from firebase.
                    if user.posts.containsID(id: aPost!.id!) {
                        
                        continue;
                        
                        
                    } else {
                        // Load the image for the post.
                        aPost?.photo = self.loadPostImage(user: user, aPost: aPost, success: {
                            self.debug(message: "[Loaded the image data for \(aPost!.id!)]");
                        }, error: nil);
                        
                        // If this post (determined by the id variable) is not already in the array, add it.
                        if(!user.posts.containsID(id: aPost!.id!)) {
                            
                            // Make sure it is not the profile picture. Otherwise just set that for the user here.
                            if(aPost?.isProfilePicture == false) {
                                
                                user.posts.append(aPost!);
                                self.debug(message: "Loaded: \(aPost!.toString())");
                                
                            } else {
                                
                                profPicPost = aPost;
                                
                            }
                        }
                    }
                    
                } // End of for loop for each post.
                
                
                // Load the profile picture.
                if let prof = profPicPost {
                    let _ = self.loadPostImage(user: user, aPost: prof, success: {
                        
                        user.profilepic = prof.photo;
                        user.profilePicName = prof.id;
                        self.debug(message: "Sucessfully loaded profile picture!");
                        
                        // Run the completion block.
                        if let comp = completion {
                            comp();
                        }
                        
                    }, error: nil); // End of loading the profile picture.
                    
                } // End of the profile picture checker.
                else {
                    // Run the completion block.
                    if let comp = completion {
                        comp();
                    }
                }
            };
            
        }
        
    } // End of the loadUsersPhotos() method.
    
    
    
    
    /** Loads all of the current user's photos from the firebase database. This method is public, and
     therefore should be used in any other class that needs to refresh the user's posts. This method loads just the Post objects; it does not load any of the image data for those posts. This method is used for when you want to load the image data only after the Post objects have been loaded OR if you want to wait until the image data is loaded before calling the completion block.
     PRECONDITION: current user is already initialized to the user that just logged in. */
    public func loadUsersPhotos(withoutImageData user: User, continous: Bool, completion: (()->Void)?) {
        
        // Start from the beginning.
        //user.posts.removeAll();
        
        // Profile picture stuff.
        var profPicPost: Post?;
        
        
        // Load all of the photo objects from the database.
        if continous == false {
            fireRef.child("Photos").child(user.uid).queryOrderedByPriority().observeSingleEvent(of: .value) { (snapshot: FIRDataSnapshot) in
                
                // First, make sure there is a value for the posts. If so, then load all of them.
                let postDictionary = snapshot.value as? [String : AnyObject] ?? [:];
                
                
                // Get each post from the database (in the form of json data).
                for post in postDictionary {
                    
                    // Get each individual post as a dictionary of elements with the form [key : value].
                    let value = post.value as? NSDictionary;
                    
                    // Get a post object.
                    let aPost = value?.toPost(user: user);
                    
                    // Check if the user object already has this post. If so, update it and move on.
                    // Otherwise, load it up from firebase.
                    if user.posts.containsID(id: aPost!.id!) {
                        
                        continue;
                        
                        
                    } else {
                        
                        // If this post (determined by the id variable) is not already in the array, add it.
                        if(!user.posts.containsID(id: aPost!.id!)) {
                            
                            // Make sure it is not the profile picture. Otherwise just set that for the user here.
                            if(aPost?.isProfilePicture == false) {
                                
                                user.posts.append(aPost!);
                                self.debug(message: "Loaded: \(aPost!.toString())");
                                
                            } else {
                                
                                profPicPost = aPost;
                                
                            }
                        }
                    }
                } // End of for loop for each post.
                
                
                // Load the profile picture.
                if let prof = profPicPost {
                    let _ = self.loadPostImage(user: user, aPost: prof, success: {
                        
                        user.profilepic = prof.photo;
                        user.profilePicName = prof.id;
                        self.debug(message: "Sucessfully loaded profile picture!");
                        
                        // Run the completion block.
                        if let comp = completion {
                            comp();
                        }
                        
                    }, error: nil); // End of loading the profile picture.
                    
                } // End of the profile picture checker.
                else {
                    // Run the completion block.
                    if let comp = completion {
                        comp();
                    }
                }
            };
        } else {
            
            fireRef.child("Photos").child(user.uid).queryOrderedByPriority().observe(.value) { (snapshot: FIRDataSnapshot) in
                
                // First, make sure there is a value for the posts. If so, then load all of them.
                let postDictionary = snapshot.value as? [String : AnyObject] ?? [:];
                
                
                // Get each post from the database (in the form of json data).
                for post in postDictionary {
                    
                    // Get each individual post as a dictionary of elements with the form [key : value].
                    let value = post.value as? NSDictionary;
                    
                    // Get a post object.
                    let aPost = value?.toPost(user: user);
                    
                    // Check if the user object already has this post. If so, update it and move on.
                    // Otherwise, load it up from firebase.
                    if user.posts.containsID(id: aPost!.id!) {
                        
                        continue;
                        
                        
                    } else {
                        
                        // If this post (determined by the id variable) is not already in the array, add it.
                        if(!user.posts.containsID(id: aPost!.id!)) {
                            
                            // Make sure it is not the profile picture. Otherwise just set that for the user here.
                            if(aPost?.isProfilePicture == false) {
                                
                                user.posts.append(aPost!);
                                self.debug(message: "Loaded: \(aPost!.toString())");
                                
                            } else {
                                
                                profPicPost = aPost;
                                
                            }
                        }
                    }
                    
                } // End of for loop for each post.
                
                
                // Load the profile picture.
                if let prof = profPicPost {
                    let _ = self.loadPostImage(user: user, aPost: prof, success: {
                        
                        user.profilepic = prof.photo;
                        user.profilePicName = prof.id;
                        self.debug(message: "Sucessfully loaded profile picture!");
                        
                        // Run the completion block.
                        if let comp = completion {
                            comp();
                        }
                        
                    }, error: nil); // End of loading the profile picture.
                    
                } // End of the profile picture checker.
                else {
                    // Run the completion block.
                    if let comp = completion {
                        comp();
                    }
                }
            };
            
        }
        
    } // End of the loadUsersPhotos() method.
    
    
    
    
    /** Loads the image data for the Post object in the parameter. That image data gets put into the same Post object so that it can be displayed in a UIImage later on. */
    public func loadPostImage(user: User, aPost: Post?, success: (()->Void)?, error: (()->Void)?) -> UIImage? {
        
        // Get a reference to the firebase media storage.
        let imgRef = FIRStorage.storage().reference().child("\(user.uid)/\(aPost!.id!).jpg");
        imgRef.data(withMaxSize: 50 * 1024 * 1024, completion: { (data: Data?, err2: Error?) in
            
            if err2 == nil {
                
                // Set the image of the post.
                let image = UIImage(data: data!);
                aPost?.photo = image!;
                
                if let s = success {
                    s();
                }
            } else {
                self.debug(message: "There was an error: \(err2.debugDescription)");
                if let er = error {
                    er();
                }
            }
        }); // End of access to media storage.
        
        return aPost?.photo;
    } // End of method.
    

    
    
    /** Loads a single post by the user and adds it to their array of posts. */
    public func loadSinglePost(user: User, withPostID id: String, loadInto post: inout Post, success: (()->Void)?, error: (()->Void)?) {
        
        let tempPost = post;
        
        fireRef.child("Photos").child(user.uid).child(id).observeSingleEvent(of: .value) { (snapshot: FIRDataSnapshot) in
            
            // Create a post object from the database.
            let val = snapshot.value as? NSDictionary ?? [:];
            let aPost = val.toPost(user: user);
            
            // Get the image data for that post.
            aPost.photo = self.loadPostImage(user: user, aPost: aPost, success: {
                
                // Once you have the image data, copy it into tempPost.
                tempPost.copy(post: aPost);
                
                if let comp = success {
                    comp();
                }
                return;
            }, error: {
               
                // Still copy whatever data was there.
                tempPost.copy(post: aPost);
                if let err = error {
                    err();
                }
                return;
            });
        };
        
    } // End of method.
    
    
    
    
    public func loadUsedIDs() {
        
        fireRef.child("UsedIDs").observeSingleEvent(of: .value) { (snapshot: FIRDataSnapshot) in
            let array = snapshot.value as? [String] ?? [];
            usedIds.append(contentsOf: array);
        }
        
    } // End of loading ids method.



    public func loadActivity() {
        notificationActivityLog.removeAll();
        
        //        UserDefaults.standard.removeObject(forKey: "\(currentUser.uid)_activity_log");
        
        // Load up all of the current user's activity.
        if let defVal = UserDefaults.standard.array(forKey: "\(Networking.currentUser!.uid)_activity_log") {
            notificationActivityLog = defVal as! [NSDictionary];
        }
        
        
    }


    public func reloadCurrentUser() {
        // Search in the database for the user.
        Networking.refreshCurrentUser(success: { (usr: User) in
            Networking.currentUser = usr;
        }, failure: {
            
        });
//        self.fireRef.child("Users").child(currentUser.uid).observeSingleEvent(of: .value, with: { (snapshot) in
//            
//            let value = snapshot.value as? NSDictionary ?? [:];
//            
//            let usr = value.toUser();
//            currentUser = usr;
//        });
    }

}
