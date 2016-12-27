//
//  Post.swift
//  Pix
//
//  Created by Adeola Uthman on 12/23/16.
//  Copyright © 2016 Adeola Uthman. All rights reserved.
//

import Foundation
import UIKit

public class Post: NSObject {
    
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
                                             "likes" : 0]);
        return dict;
    }
    
    
    
    func toString() -> String {
        return "id=\(id!), caption=\(caption.text!),likes=\(likes)";
    }
    
    
    
}
