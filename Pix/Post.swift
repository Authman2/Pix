//
//  Post.swift
//  Pix
//
//  Created by Adeola Uthman on 11/15/16.
//  Copyright © 2016 Adeola Uthman. All rights reserved.
//
//  This is the data that a typical post would contain.
//  - An image (the picture that was uploaded)
//  - A caption
//  - The uploader
//  - Number of likes
//  - Number of favorites
//


import Foundation
import UIKit


class Post: NSObject {
    
    // The uploaded image
    var image: UIImage?;
    
    
    // The caption on the photo
    var caption: String?;
    
    
    // The user who uploaded the image
    var user: User!;
    
    
    // The number of likes the post has
    var likes: Int = Int();
    
    
    // Whether or not you can like this photo.
    var canLike: Bool = true;
    
    
    // The number of favorites the post has
    var favorites: Int = Int();
    
    
    // The id from the Firebase database.
    var id: String!;
    
    
    
    
    
    
    ///////// Constructors /////////
    
    override init() {}
    
    init(img: UIImage?, caption: String, user: User) {
        self.image = img;
        self.caption = caption;
        self.user = user;
    }
    
    
    
    
    
    
    ///////// Setters /////////
    
    
    public func addLike() {
        self.likes += 1;
    }
    
    
    
    public func addFavorite() {
        self.favorites += 1;
    }
    
    
    
    
    ///////// Getters /////////
    
    public func getUploader() -> User {
        return user!;
    }

}
