//
//  EditProfilePage.swift
//  Pix
//
//  Created by Adeola Uthman on 1/5/17.
//  Copyright © 2017 Adeola Uthman. All rights reserved.
//

import Foundation
import UIKit
import Eureka
import Firebase

class EditProfilePage: FormViewController {

    /********************************
     *
     *          VARIABLES
     *
     ********************************/
    
    /* Firebase reference. */
    let fireRef: FIRDatabaseReference = FIRDatabase.database().reference();
    
    
    
    
    
    
    
    
    
    /********************************
     *
     *          METHODS
     *
     ********************************/
    
    override func viewDidLoad() {
        super.viewDidLoad();
        navigationItem.hidesBackButton = true;
        navigationItem.title = "Edit Profile";
        
        form = Section("Profile")
            <<< TextRow(){ row in
                row.tag = "UsernameRow";
                row.title = "Username";
                row.value = "\(currentUser.username)";
            }
            <<< TextRow(){ row in
                row.tag = "EmailRow";
                row.title = "Email";
                row.value = "\(currentUser.email)";
            }
            <<< TextRow() { row in
                row.tag = "FirstNameRow";
                row.title = "First Name";
                row.value = "\(currentUser.firstName)";
            }
            <<< TextRow() { row in
                row.tag = "LastRow";
                row.title = "Last Name";
                row.value = "\(currentUser.lastName)";
            }
            <<< TextRow() { row in
                row.tag = "PasswordRow";
                row.title = "Password";
                row.placeholder = "Enter new password.";
            }
            +++ Section("")
        
        
        
        let updateButton = UIBarButtonItem(title: "Update", style: .plain, target: self, action: #selector(updateProfile));
        updateButton.tintColor = .white;
        navigationItem.rightBarButtonItem = updateButton;
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(close));
        cancelButton.tintColor = .white;
        navigationItem.leftBarButtonItem = cancelButton;
    }
    
    
    
    @objc func close() {
        let _ = navigationController?.popViewController(animated: true);
    }
    
    
    
    @objc func updateProfile() {
        
        // Get the value of a single row
        let usernameRow: String? = form.rowBy(tag: "UsernameRow")?.value;
        let emailRow: String? = form.rowBy(tag: "EmailRow")?.value;
        let firstNameRow: String? = form.rowBy(tag: "FirstNameRow")?.value;
        let lastNameRow: String? = form.rowBy(tag: "LastNameRow")?.value;
        let passwordRow: String? = form.rowBy(tag: "PasswordRow")?.value;
        
        
        
        if let usrRow = usernameRow {
            currentUser.username = usrRow;
        }
        
        if let emRow = emailRow {
            currentUser.email = emRow;
        }
        
        if let firRow = firstNameRow {
            currentUser.firstName = firRow;
        }
     
        if let lasRow = lastNameRow {
            currentUser.lastName = lasRow;
        }
        
        if let passRow = passwordRow {
            currentUser.password = passRow;
        }
        
        
            
        self.fireRef.child("Users").child(currentUser.uid).setValue(currentUser.toDictionary());
        FIRAuth.auth()?.currentUser?.updateEmail(currentUser.email, completion: { (error: Error?) in
            self.debug(message: "There was an issue updating the email: \(error.debugDescription)");
        })
        FIRAuth.auth()?.currentUser?.updatePassword(currentUser.password, completion: { (error: Error?) in
            self.debug(message: "There was an issue updating the password: \(error.debugDescription)");
        })
        
        
        self.close();
    }
    
    
    
    
    
    
}
