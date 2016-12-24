//
//  UploadPhotosViewController.swift
//  Pix
//
//  Created by Adeola Uthman on 12/23/16.
//  Copyright © 2016 Adeola Uthman. All rights reserved.
//

import UIKit
import Firebase
import Neon
import SnapKit

class UploadPhotosViewController: UIViewController {
    
    /********************************
     *
     *          VARIABLES
     *
     ********************************/
    
    /* The post associated with this view controller. */
    var post: Post!;
    
    
    /* The image */
    let imageView: UIImageView = {
        let img = UIImageView();
        img.contentMode = .scaleAspectFit;
        img.translatesAutoresizingMaskIntoConstraints = false;
        
        return img;
    }();
    
    
    /* A place for a caption */
    let textArea: UITextView = {
        let t = UITextView();
        t.translatesAutoresizingMaskIntoConstraints = false;
        t.autocorrectionType = .no;
        t.text = "Caption";
        t.font = UIFont(name: "Avenir", size: 20);
        
        return t;
    }();
    
    
    /* The reference to the firebase database. */
    let fireRef: FIRDatabaseReference = FIRDatabase.database().reference();
    
    
    
    
    
    
    
    /********************************
     *
     *          METHODS
     *
     ********************************/

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 239/255, green: 255/255, blue:245/255, alpha: 1);
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard));
        view.addGestureRecognizer(tap);
        
        
        /* View layout stuff. */
        imageView.image = post.photo.image;
        view.addSubview(imageView);
        view.addSubview(textArea);
        
        imageView.align(.underCentered, relativeTo: (navigationController?.navigationBar)!, padding: 10, width: view.width - 50, height: view.height / 2);
        textArea.align(.underCentered, relativeTo: imageView, padding: 10, width: view.width, height: 500);
        
        
        /* Bar buttons. */
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel));
        let postButton = UIBarButtonItem(title: "Upload", style: .plain, target: self, action: #selector(uploadPost));
        cancelButton.tintColor = UIColor.white;
        postButton.tintColor = UIColor.white;
        navigationItem.leftBarButtonItem = cancelButton;
        navigationItem.rightBarButtonItem = postButton;
    }
    
    
    
    @objc func dismissKeyboard() {
        view.endEditing(true);
    }
    
    
    @objc func cancel() {
        let _ = navigationController?.popViewController(animated: true);
    }
    
    
    @objc func uploadPost() {
        post.caption.text = textArea.text!;
        
        let randomName = self.randomName();
        let storageRef = FIRStorageReference().child("\(currentUser.email)/\(randomName).jpg");
        let data = UIImageJPEGRepresentation(self.post.photo.image!, 100) as NSData?;
        let emailTrimmed = currentUser.email.substring(i: 0, j: currentUser.email.indexOf(string: "@"));
        let imageFileName = "\(randomName).jpg";
        
        let _ = storageRef.put(data! as Data, metadata: nil) { (metaData, error) in
            
            if (error == nil) {
                
                self.debug(message: "Photo Uploaded!");
                let postObj = self.post.toDictionary(img: imageFileName);
                self.fireRef.child("Photos").child("\(emailTrimmed)").child("\(randomName)").setValue(postObj);
                self.cancel();
                
            } else {
                print(error.debugDescription);
            }
        }
        
    } // End of upload method.
    
    
    /* A random id for each post. */
    private func randomName() -> String {
        var id = "";
        let arr: [String] = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","1","2","3","4","5","6","7","8","9","0"];
        
        while id.length() < 15 {
            let random = arc4random_uniform(UInt32(arr.count));
            id += arr[Int(random)];
        }
        
        return id;
    }
    
    
    

}
