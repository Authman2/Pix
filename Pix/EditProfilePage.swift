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
import Presentr


var formBackgroundColor: UIColor?;


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
        formBackgroundColor = view.backgroundColor;
        
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
            <<< ButtonRow() { row in
                row.title = "Liked Photos"
                }.onCellSelection({ (btn: ButtonCellOf<String>, btnRow: ButtonRowOf<String>) in
                    self.navigationController?.pushViewController(LikedPhotosPage(), animated: true);
                })
            +++ Section("Privacy")
            <<< SwitchRow() { row in
                row.title = "Private Account"
                row.value = currentUser.isPrivate;
                }.onChange { row in
                    currentUser.isPrivate = (row.value ?? false) ? true : false;
                    row.updateCell()
                }.cellSetup { cell, row in
                    cell.backgroundColor = .white
                }.cellUpdate { cell, row in
                    cell.textLabel?.font = cell.textLabel?.font;
            }
            <<< ButtonRow() { row in
                    row.title = "Blocked Users"
                }.onCellSelection({ (btn: ButtonCellOf<String>, btnRow: ButtonRowOf<String>) in
                    self.navigationController?.pushViewController(BlockedUsersPage(), animated: true);
                })
            +++ Section("Logout")
            <<< ButtonRow() { row in
                row.title = "Logout";
                }.onCellSelection({ (btn: ButtonCellOf<String>, btnRow: ButtonRowOf<String>) in
                    profilePage.logout();
                })
        
        
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
        
        
        var usrn = currentUser.username;
        var em = currentUser.email;
        var first = currentUser.firstName;
        var last = currentUser.lastName;
        var pass = currentUser.password;
        
        
        if let usrRow = usernameRow {
            usrn = usrRow;
        }
        
        if let emRow = emailRow {
            em = emRow;
        }
        
        if let firRow = firstNameRow {
            first = firRow;
        }
     
        if let lasRow = lastNameRow {
            last = lasRow;
        }
        
        if let passRow = passwordRow {
            pass = passRow;
        }
        
        
        
        
        currentUser.email = em;
        currentUser.firstName = first;
        currentUser.lastName = last;
        currentUser.password = pass;
        
        self.checkUsernameTaken(username: usrn, taken: {
            // Taken.
        }) { 
            currentUser.username = usrn;
            self.updateIt();
        }
        
        self.checkEmailTaken(email: em, taken: { 
            // Taken.
        }) { 
            currentUser.email = em;
            self.updateIt();
        }
        
        self.close();
    }
    
    
    private func updateIt() {
        self.fireRef.child("Users").child(currentUser.uid).setValue(currentUser.toDictionary());
        FIRAuth.auth()?.currentUser?.updateEmail(currentUser.email, completion: { (error: Error?) in
            if error == nil {
                self.debug(message: "Email was reset!");
            } else {
                self.debug(message: "There was an issue updating the email: \(error.debugDescription)");
            }
        })
        FIRAuth.auth()?.currentUser?.updatePassword(currentUser.password, completion: { (error: Error?) in
            if error == nil {
                self.debug(message: "Password was reset!");
            } else {
                self.debug(message: "There was an issue updating the password: \(error.debugDescription)");
            }
        })
        
        self.fireRef.child("Users").child(currentUser.uid).updateChildValues(currentUser.toDictionary() as! [AnyHashable : Any]);
    }
    
    
    
    private func checkUsernameTaken(username: String, taken: (()->Void)?, available: (()->Void)?) {
        fireRef.child("Users").observeSingleEvent(of: .value, with: { (snapshot: FIRDataSnapshot) in
            
            let userDictionary = snapshot.value as? [String : AnyObject] ?? [:];
            var tkn = false;
            for user in userDictionary {
                let aUser = user.value as! NSDictionary;
                let usr = aUser.toUser();
                
                if usr.username == username {
                    tkn = true;
                    if let t = taken {
                        t();
                    }
                    return;
                }
            }
            
            if tkn == false {
                if let a = available {
                    a();
                }
            }
        }); // End of checking for existing username.
    }
    
    private func checkEmailTaken(email: String, taken: (()->Void)?, available: (()->Void)?) {
        fireRef.child("Users").observeSingleEvent(of: .value, with: { (snapshot: FIRDataSnapshot) in
            
            let userDictionary = snapshot.value as? [String : AnyObject] ?? [:];
            var tkn = false;
            for user in userDictionary {
                let aUser = user.value as! NSDictionary;
                let usr = aUser.toUser();
                
                if usr.email == email {
                    tkn = true;
                    if let t = taken {
                        t();
                    }
                    return;
                }
            }
            
            if tkn == false {
                if let a = available {
                    a();
                }
            }
        }); // End of checking for existing email.
    }
    
    
}
