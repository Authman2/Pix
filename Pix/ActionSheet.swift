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
        a.backgroundColor = UIColor(red: 128, green: 128, blue: 128, alpha: 1);
        
        return a;
    }();
    
    
    let flag: UIButton = {
        let a = UIButton();
        a.translatesAutoresizingMaskIntoConstraints = false;
        a.setTitle("Flag as Inappropriate", for: .normal);
        a.setTitleColor(.red, for: .normal);
        a.backgroundColor = UIColor(red: 128, green: 128, blue: 128, alpha: 1);
        
        return a;
    }();

    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad();
        view.backgroundColor = UIColor(white: 255, alpha: 0.5);
        
        view.addSubview(titleLabel);
        view.addSubview(cancel);
        view.addSubview(flag);
        
        
        titleLabel.anchorToEdge(.top, padding: 5, width: view.width, height: 15);
        flag.align(.underCentered, relativeTo: titleLabel, padding: 30, width: view.width, height: 30);
        cancel.align(.underCentered, relativeTo: flag, padding: 20, width: view.width, height: 30);
        
        cancel.addTarget(self, action: #selector(cancelMethod), for: .touchUpInside);
        flag.addTarget(self, action: #selector(flagMethod), for: .touchUpInside);
    }
    
    
    
    @objc func cancelMethod() {
        cancel.backgroundColor = UIColor(red: 170, green: 170, blue: 170, alpha: 1);
        dismiss(animated: true, completion: nil);
    }
    
    
    @objc func flagMethod() {
        flag.backgroundColor = UIColor(red: 170, green: 170, blue: 170, alpha: 1);
        self.post?.flags += 1;
        self.fireRef.child("Photos").child(self.post!.uploader.uid).child((self.post?.id!)!).updateChildValues(self.post?.toDictionary() as! [AnyHashable : Any]);
        
        cancelMethod();
    }
    
}
