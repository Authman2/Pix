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
    var photo: UIImage!;
    
    /* The caption on the photo. */
    var caption: String!;
    
    
    /* The number of likes on this post. */
    var likes: Int = Int();
    
    
    /* The user who uploaded this post. */
    var uploader: User!;
    
    
    /* The id used to specify this particular Post object. */
    var id: String!;
    
    
    /* Whether or not this is the user's profile picture. */
    var isProfilePicture = false;
    
    
    /* The number of times this post has been flagged as inappropriate. */
    var flags: Int = 0;
    
    
    /* All of the comments on the picture. */
    var comments: [String]!;
    
    
    
    
    /********************************
     *
     *          METHODS
     *
     ********************************/
    
    init(photo: UIImage?, caption: String?, Uploader: User?, ID: String?) {
        self.photo = photo;
        self.caption = caption;
        self.uploader = Uploader;
        self.id = ID;
        self.comments = [String]();
    }
    
    
    
    /* Turns the post object into a format that can be read by firebase. */
    func toDictionary() -> NSDictionary {
        let dict = NSDictionary(dictionary: ["image" : id+".jpg",
                                             "id" : id,
                                             "caption" : caption,
                                             "likes" : likes,
                                             "is_profile_picture" : isProfilePicture,
                                             "flags" : flags,
                                             "comments" : comments]);
        return dict;
    }
    
    
    func copy(post: Post) {
        self.photo = post.photo;
        self.caption = post.caption;
        self.uploader = post.uploader;
        self.id = post.id;
        self.flags = post.flags;
        self.likes = post.likes;
        self.isProfilePicture = post.isProfilePicture;
        self.comments = post.comments;
    }
    
    
    
    
    func toString() -> String {
        return "id=\(id!), caption=\(caption), likes=\(likes), profile picture?: \(isProfilePicture)";
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
