//
//  Post.swift
//  Pix
//
//  Created by Adeola Uthman on 12/23/16.
//  Copyright © 2016 Adeola Uthman. All rights reserved.
//

import Foundation
import UIKit
import IGListKit

public class Post: NSObject, IGListDiffable {
    
    /********************************
     *
     *          VARIABLES
     *
     ********************************/
    
    /* The image view of the photo that is uploaded on this post. */
    var photo: UIImageView = {
        let p = UIImageView();
        p.translatesAutoresizingMaskIntoConstraints = false;
        
        return p;
    }();
    
    
    /* The caption on the photo. */
    var caption: UILabel = {
        let c = UILabel();
        c.translatesAutoresizingMaskIntoConstraints = false;
        c.textColor = UIColor.black;
        
        return c;
    }();
    
    
    /* The number of likes on this post. */
    var likes: Int = Int();
    
    
    /* The user who uploaded this post. */
    var uploader: User!;
    
    
    /* The id used to specify this particular Post object. */
    var id: String!;
    
    
    /* Whether or not this is the user's profile picture. */
    var isProfilePicture = false;
    
    
    
    
    
    
    /********************************
     *
     *          METHODS
     *
     ********************************/
    
    init(photo: UIImage?, caption: String?, Uploader: User?, ID: String?) {
        self.photo.image = photo;
        self.caption.text = caption;
        self.uploader = Uploader;
        self.id = ID;
    }
    
    
    
    /* Turns the post object into a format that can be read by firebase. */
    func toDictionary() -> NSDictionary {
        let dict = NSDictionary(dictionary: ["image" : id+".jpg",
                                             "id" : id,
                                             "caption" : caption.text!,
                                             "likes" : likes,
                                             "is_profile_picture" : isProfilePicture]);
        return dict;
    }
    
    
    
    func toString() -> String {
        return "id=\(id!), caption=\(caption.text!), likes=\(likes), profile picture?: \(isProfilePicture)";
    }
    
    
    public func diffIdentifier() -> NSObjectProtocol {
        return self;
    }
    
    
    public func isEqual(toDiffableObject object: IGListDiffable?) -> Bool {
        if let obj = object as! Post? {
            return id == obj.id;
        }
        return false;
    }
}
