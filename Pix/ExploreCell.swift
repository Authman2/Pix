//
//  ExploreCell.swift
//  Pix
//
//  Created by Adeola Uthman on 12/25/16.
//  Copyright © 2016 Adeola Uthman. All rights reserved.
//

import UIKit
import SnapKit
import Firebase

class ExploreCell: UITableViewCell {

    /********************************
     *
     *          VARIABLES
     *
     ********************************/
    
    
    /* The user object for data grabbing. */
    var user: User!;
    
    
    /* The user, but in the form of firebase data. */
    var user_fb: Any!;
    
    
    /* Displays the name of the user. */
    let nameLabel: UILabel = {
        let n = UILabel();
        n.translatesAutoresizingMaskIntoConstraints = false;
        n.textColor = .black;
        
        return n;
    }();
    
    
    /* The image view that displays that user's profile picture. */
    let profilePicture: UIImageView = {
        let a = UIImageView();
        a.translatesAutoresizingMaskIntoConstraints = false;
        a.backgroundColor = .gray;
        a.layer.cornerRadius = 15;
        
        return a;
    }();
    
    
    
    
    
    
    
    /********************************
     *
     *           METHODS
     *
     ********************************/
    
    override func awakeFromNib() {
        super.awakeFromNib();
    }
    
    public func setup(u_fb: Any, u: User) {
        user_fb = u_fb;
        user = u;
        
        // Get the data.
        nameLabel.text = "\(self.user.firstName) \(self.user.lastName)";
        profilePicture.image = self.loadProfilePicture();
        
        
        // Setup the view
        addSubview(nameLabel);
        addSubview(profilePicture);
        
        
        // Snapkit
        profilePicture.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.left.equalTo(snp.left).offset(10);
            maker.centerY.equalTo(snp.centerY);
            maker.width.equalTo(width / 10);
            maker.height.equalTo(height - 14);
        }
        nameLabel.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.left.equalTo(profilePicture.snp.right).offset(5);
            maker.right.equalTo(snp.right);
            maker.height.equalTo(height);
        }
    }
    
    
    
    
    func loadProfilePicture() -> UIImage {
        var returner = UIImage();
        
        // Load all of the photo objects from the database.
        let emailTrimmed = self.user.email.substring(i: 0, j: self.user.email.indexOf(string: "@"));
        let fireRef = FIRDatabase.database().reference();
        fireRef.child("Photos").child("\(emailTrimmed)").queryOrderedByPriority().observe(FIRDataEventType.value, with: { (snapshot) in
            
            // First, make sure there is a value for the posts. If so, then load all of them.
            let postDictionary = snapshot.value as? [String : AnyObject] ?? [:];
            
            
            // Get each post from the database (in the form of json data).
            for post in postDictionary {
                
                // Get each individual post as a dictionary of elements with the form [key : value].
                let aPost = post.value as! [String : AnyObject];
                
                
                // Get the name of the photo that is used to identify it.
                let imgName = aPost["image"] as? String;
                
                
                // Get a reference to the firebase media storage.
                let imgRef = FIRStorage.storage().reference().child("\(self.user.email)/\(imgName!)");
                imgRef.data(withMaxSize: 50 * 1024 * 1024, completion: { (data: Data?, error: Error?) in
                    
                    if error == nil {
                        
                        // Get the value of each important piece of information.
                        let image = UIImage(data: data!);
                        let isProfilePic = aPost["is_profile_picture"] as? Bool ?? false;
                        
                        
                        // Make sure it is not the profile picture. Otherwise just set that for the user here.
                        if(isProfilePic == true) {
                            
                            returner = image!;
                        
                        }
                        
                    } else {
                        print("There was an error loading profile picture: \(error)");
                    }
                    
                }); // End of access to media storage.
                
            } // End of for loop for each post.
            
        });

        return returner;
    } // End of method.
    
    
}
