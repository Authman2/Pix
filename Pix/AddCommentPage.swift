//
//  AddCommentBox.swift
//  Pix
//
//  Created by Adeola Uthman on 2/16/17.
//  Copyright © 2017 Adeola Uthman. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import Neon
import SnapKit
import Firebase
import Presentr


class AddCommentPage: UIViewController {
    
    /********************************
     *
     *          VARIABLES
     *
     ********************************/
    
    /* The post object. */
    var post: Post!;
    
    /* The comments page. */
    var commentsPage: CommentsPage!;
    
    /* Firebase reference. */
    var fireRef: FIRDatabaseReference = FIRDatabase.database().reference();
    
    
    /* The text area. */
    let textArea: UITextView = {
        let a = UITextView();
        a.translatesAutoresizingMaskIntoConstraints = false;
        a.placeholderText = "Add a comment";
        a.backgroundColor = .white;
        a.textAlignment = .left;
        a.font = UIFont(name: "Arial", size: 12);
        
        return a;
    }();
    
    
    /* The send button.*/
    let sendBtn: UIButton = {
        let s = UIButton();
        s.backgroundColor = .clear;
        s.setImage(UIImage(named: "SendBtn.png"), for: .normal);
        
        return s;
    }();
    
    
    
    /********************************
     *
     *          METHODS
     *
     ********************************/
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        view.addSubview(textArea);
        view.addSubview(sendBtn);
        view.bringSubview(toFront: sendBtn);

        self.setupLayout();
        self.sendBtn.addTarget(self, action: #selector(sendComment), for: .touchUpInside);
    }
    
    
    public func setupLayout() {
        textArea.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.left.equalTo(view.snp.left);
            maker.top.equalTo(view.snp.top);
            maker.right.equalTo(view.snp.right);
            maker.bottom.equalTo(view.snp.bottom);
        }
        sendBtn.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.bottom.equalTo(view.snp.bottom).offset(-10);
            maker.right.equalTo(view.snp.right).offset(-10);
            maker.width.equalTo(30);
            maker.height.equalTo(30);
        }
    }
    
    
    
    @objc func sendComment() {
        self.post.comments?.append("\(Networking.currentUser!.uid) \(textArea.text!)");
        self.fireRef.child("Photos").child(self.post.uploader.uid).child(self.post.id).updateChildValues(self.post.toDictionary() as! [AnyHashable : Any]);
        commentsPage.adapter.performUpdates(animated: true, completion: nil);
        dismiss(animated: true, completion: nil);
    }
}
