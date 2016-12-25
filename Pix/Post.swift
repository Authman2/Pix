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
    
    
    
    
    
    
    
    
    
    /********************************
     *
     *          METHODS
     *
     ********************************/
    
    init(photo: UIImage?, caption: String?, Uploader: User?) {
        self.photo.image = photo;
        self.caption.text = caption;
        self.uploader = Uploader;
    }
    
    
    
    func toDictionary(img: String) -> NSDictionary {
        let dict = NSDictionary(dictionary: ["image" : img,
                                             "caption" : caption.text!,
                                             "likes" : 0]);
        return dict;
    }
    
    
    
    func toString() -> String {
        return "caption=\(caption.text!),likes=\(likes)";
    }
    
    
    
}
