//
//  ActionSheet.swift
//  Pix
//
//  Created by Adeola Uthman on 1/10/17.
//  Copyright © 2017 Adeola Uthman. All rights reserved.
//

import UIKit
import Neon
import Presentr
import Firebase

class ActionSheet: UIViewController {

    var post: Post?;
    var presenter: Presentr?;
    var fireRef: FIRDatabaseReference = FIRDatabase.database().reference();
    
    
    let titleLabel: UILabel = {
        let a = UILabel();
        a.translatesAutoresizingMaskIntoConstraints = false;
        a.text = "Options";
        a.textColor = .black;
        a.textAlignment = .center;
        
        return a;
    }();
    
    let cancel: UIButton = {
        let a = UIButton();
        a.translatesAutoresizingMaskIntoConstraints = false;
        a.setTitle("Cancel", for: .normal);
        a.setTitleColor(.black, for: .normal);
        a.backgroundColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1);
        
        return a;
    }();
    
    
    let flag: UIButton = {
        let a = UIButton();
        a.translatesAutoresizingMaskIntoConstraints = false;
        a.setTitle("Flag as Inappropriate", for: .normal);
        a.setTitleColor(.red, for: .normal);
        a.backgroundColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1);
        
        return a;
    }();

    let delete: UIButton = {
        let a = UIButton();
        a.translatesAutoresizingMaskIntoConstraints = false;
        a.setTitle("Delete", for: .normal);
        a.setTitleColor(.black, for: .normal);
        a.backgroundColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1);
        
        return a;
    }();
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad();
        view.backgroundColor = UIColor(white: 255, alpha: 0.5);
        
    
        if(self.post!.uploader.uid == currentUser.uid) {
            view.addSubview(titleLabel);
            view.addSubview(cancel);
            view.addSubview(delete);
            view.addSubview(flag);
            
            titleLabel.anchorToEdge(.top, padding: 5, width: view.width, height: 15);
            flag.align(.underCentered, relativeTo: titleLabel, padding: 50, width: view.width, height: 30);
            delete.align(.underCentered, relativeTo: flag, padding: 20, width: view.width, height: 30);
            cancel.align(.underCentered, relativeTo: delete, padding: 20, width: view.width, height: 30);
        } else {
            view.addSubview(titleLabel);
            view.addSubview(cancel);
            view.addSubview(flag);
            
            titleLabel.anchorToEdge(.top, padding: 5, width: view.width, height: 15);
            flag.align(.underCentered, relativeTo: titleLabel, padding: 50, width: view.width, height: 30);
            cancel.align(.underCentered, relativeTo: flag, padding: 20, width: view.width, height: 30);
        }
        
        
        cancel.addTarget(self, action: #selector(cancelMethod), for: .touchUpInside);
        delete.addTarget(self, action: #selector(deletePost), for: .touchUpInside);
        flag.addTarget(self, action: #selector(flagMethod), for: .touchUpInside);
    }
    
    
    
    @objc func cancelMethod() {
        cancel.backgroundColor = UIColor(red: 170, green: 170, blue: 170, alpha: 1);
        dismiss(animated: true, completion: nil);
    }
    
    
    @objc func deletePost() {
        self.fireRef.child("Photos").child(currentUser.uid).child(self.post!.id!).removeValue { (error: Error?, ref: FIRDatabaseReference) in
            
            if let err = error {
                self.debug(message: "Error deleting post: \(err)");
            } else {
                
                // Delete the image data.
                let storageRef = FIRStorageReference().child("\(currentUser.uid)/\(self.post!.id!).jpg");
                storageRef.delete(completion: { (error: Error?) in
                    if let e = error {
                        self.debug(message: "Error deleting image data: \(e)");
                        return;
                    }
                });
                                
                currentUser.posts.removePost(uid: self.post!.id!);
                self.cancelMethod();
                return;
            }
        }
    }
    
    
    @objc func flagMethod() {
        flag.backgroundColor = UIColor(red: 170, green: 170, blue: 170, alpha: 1);
        self.post?.flags += 1;
        self.fireRef.child("Photos").child(self.post!.uploader.uid).child((self.post?.id!)!).updateChildValues(self.post?.toDictionary() as! [AnyHashable : Any]);
        
        cancelMethod();
    }
    
}
