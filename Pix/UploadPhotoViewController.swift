//
//  UploadPhotoViewController.swift
//  Pix
//
//  Created by Adeola Uthman on 11/28/16.
//  Copyright © 2016 Adeola Uthman. All rights reserved.
//

import UIKit
import Neon
import Firebase


class UploadPhotoViewController: UIViewController {

    // Firebase reference
    let ref: FIRDatabaseReference! = FIRDatabase.database().reference();
    
    // The actual post object.
    var post: Post!;
    
    
    // The image
    public let imageView: UIImageView = {
        let img = UIImageView();
        img.contentMode = .scaleAspectFit;
        img.translatesAutoresizingMaskIntoConstraints = false;
        
        return img;
    }();
    
    
    // A place for a caption
    let textArea: UITextView = {
        let t = UITextView();
        t.translatesAutoresizingMaskIntoConstraints = false;
        t.autocorrectionType = .no;
        t.text = "Caption";
        t.font = UIFont(name: "Avenir", size: 20);
        
        return t;
    }();
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView();
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard));
        view.addGestureRecognizer(tap);
        
        
        imageView.image = post.image;
        view.addSubview(imageView);
        view.addSubview(textArea);
        
        
        imageView.align(.underCentered, relativeTo: (navigationController?.navigationBar)!, padding: 5, width: view.frame.width - 30, height: 200);
        textArea.align(.underCentered, relativeTo: imageView, padding: 5, width: view.frame.width, height: 300);
        
        
        // Add a navigation item to add upload a photo
        let uploadBarButton = UIBarButtonItem(title: "Upload", style: .plain, target: self, action: #selector(uploadPhoto));
        uploadBarButton.tintColor = UIColor.white;
        let cancelBarButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel));
        cancelBarButton.tintColor = UIColor.white;
        navigationItem.rightBarButtonItem = uploadBarButton;
        navigationItem.leftBarButtonItem = cancelBarButton;
    }
    
    
    private func setupView() {
        view.backgroundColor = UIColor(red: 239/255, green: 255/255, blue:245/255, alpha: 1);
        navigationItem.title = "Upload";
        navigationItem.hidesBackButton = true;
    }
    
    
    // A random id for each post.
    private func randomName() -> String {
        return currentUser.createId();
    }
    
    
    // Save the image in Storage and in Database.
    // Storage: Saved under a folder called "\(user's email)" and the title "photo_\(number of posts by user)"
    // Database: Saved under the user's email in Photos.
    @objc private func uploadPhoto() {
        post.caption = textArea.text!;
        currentUser.posts.append(post);
        
        let randomName = self.randomName();
        let storageRef = FIRStorageReference().child("\(currentUser.email!)/\(randomName).jpg");
        let data = UIImagePNGRepresentation(post.image!)! as NSData;
        let emailTrimmed = currentUser.email!.substring(i: 0, j: currentUser.email!.length() - 4);
        var imageFileName = "";
        
        _ = storageRef.put(data as Data, metadata: nil) { metaData, error in
            
            if (error == nil) {
                print("Upload Working!");
                imageFileName = "\(randomName).jpg";
                let postObj: NSMutableDictionary = ["image":imageFileName,
                                                    "caption":self.post.caption!,
                                                    "likes":0];
                self.ref.child("Photos").child("\(emailTrimmed)").child("\(randomName)").setValue(postObj);
                
            } else {
                print(error.debugDescription);
            }
            
        }
        cancel();
    }
    
    
    
    // Close this view controller
    @objc private func cancel() {
        let _ = navigationController?.popViewController(animated: true);
    }
    
    
    
    // Close the keyboard
    @objc private func dismissKeyboard() {
        view.endEditing(true);
    }
    
    
    
}
