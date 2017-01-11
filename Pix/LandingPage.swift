//
//  LandingPage.swift
//  Pix
//
//  Created by Adeola Uthman on 12/21/16.
//  Copyright © 2016 Adeola Uthman. All rights reserved.
//

import UIKit
import SnapKit
import Firebase
import Spring

class LandingPage: UIViewController {
    
    
    /********************************
     *
     *          VARIABLES
     *
     ********************************/
    

    /* The title of the app, Pix. */
    let titleLabel: UILabel = {
        let t = UILabel();
        t.translatesAutoresizingMaskIntoConstraints = false;
        t.text = "Pix";
        t.textColor = UIColor.white;
        t.font = UIFont(name: t.font.fontName, size: 35);
        t.isUserInteractionEnabled = false;
        
        return t;
    }();
    

    /* The email text field. */
    let emailField: UITextField = {
        let e = UITextField();
        e.translatesAutoresizingMaskIntoConstraints = false;
        e.placeholder = "Email";
        e.backgroundColor = UIColor.white;
        e.textAlignment = .center;
        e.autocorrectionType = .no;
        e.autocapitalizationType = .none;
        e.keyboardType = .emailAddress;
        
        return e;
    }();
    
    
    /* The password text field. */
    let passwordField: UITextField = {
        let p = UITextField();
        p.translatesAutoresizingMaskIntoConstraints = false;
        p.placeholder = "Password";
        p.backgroundColor = UIColor.white;
        p.textAlignment = .center;
        p.isSecureTextEntry = true;
        p.autocorrectionType = .no;
        p.autocapitalizationType = .none;
        
        return p;
    }();
    
    
    /* The sign up button. */
    let signupButton: UIButton = {
        let s = UIButton();
        s.setTitle("Sign Up", for: .normal);
        s.backgroundColor = UIColor(red: 21/255, green: 180/255, blue: 133/255, alpha: 1);
        s.layer.cornerRadius = 25;
        s.titleLabel?.font = UIFont(name: (s.titleLabel?.font.fontName)!, size: 15);
        
        return s;
    }();
    
    
    /* The login button. */
    let loginButton: SpringButton = {
        let s = SpringButton();
        s.setTitle("Login", for: .normal);
        s.backgroundColor = UIColor(red: 21/255, green: 180/255, blue: 133/255, alpha: 1);
        s.layer.cornerRadius = 25;
        s.titleLabel?.font = UIFont(name: (s.titleLabel?.font.fontName)!, size: 15);
        
        return s;
    }();
    
    
    /* Displays the status of loggin in. */
    let statusLabel: UILabel = {
        let s = UILabel();
        s.translatesAutoresizingMaskIntoConstraints = false;
        s.textColor = UIColor.red;
        s.isHidden = true;
        s.isUserInteractionEnabled = false;
        s.textAlignment = .center;
        
        return s;
    }();
    
    
    
    
    /* The firebase database reference. */
    let fireRef: FIRDatabaseReference! = FIRDatabase.database().reference();
    
    
    
    
    
    /********************************
     *
     *          METHODS
     *
     ********************************/
    
    override func viewDidLoad() {
        super.viewDidLoad();
        view.backgroundColor = UIColor(red: 41/255, green: 200/255, blue: 153/255, alpha: 1);
        navigationController?.navigationBar.isHidden = true;
        
        /* Set up the view. */
       
        view.addSubview(titleLabel);
        view.addSubview(emailField);
        view.addSubview(passwordField);
        
        let btnView = UIView();
        btnView.addSubview(signupButton);
        btnView.addSubview(loginButton);
        view.addSubview(btnView);
        view.addSubview(statusLabel);
        
        
        titleLabel.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.top.equalTo(view.snp.top).offset(70);
            maker.centerX.equalTo(view.snp.centerX);
        }
        emailField.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.top.equalTo(titleLabel.snp.bottom).offset(25);
            maker.width.equalTo(view.width);
            maker.height.equalTo(30);
        }
        passwordField.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.top.equalTo(emailField.snp.bottom).offset(25);
            maker.width.equalTo(view.width);
            maker.height.equalTo(30);
        }
        statusLabel.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.top.equalTo(passwordField.snp.bottom);
            maker.width.equalTo(view.width);
            maker.height.equalTo(30);
            maker.centerX.equalTo(view.snp.centerX);
        }
        btnView.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.top.equalTo(statusLabel.snp.bottom).offset(25);
            maker.width.equalTo(view.width);
            maker.height.equalTo(100);
        }
        signupButton.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.right.equalTo(btnView.snp.centerX).offset(10);
            maker.top.equalTo(btnView.snp.top);
            maker.width.equalTo(70);
            maker.height.equalTo(45);
        }
        loginButton.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.left.equalTo(btnView.snp.centerX).offset(10);
            maker.top.equalTo(btnView.snp.top);
            maker.width.equalTo(70);
            maker.height.equalTo(45);
        }
        
        
        signupButton.addTarget(self, action: #selector(signUp), for: .touchUpInside);
        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside);
        
        
        /* Automatic login. */
        self.checkAutoLogin();
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        self.loadUsedIDs();

        navigationController?.navigationBar.isHidden = true;
        statusLabel.isHidden = true;
    }
    
    
    
    // Checks if a user is already logged in and automatically signs them in.
    func checkAutoLogin() {
        if let cUser = FIRAuth.auth()?.currentUser {
            
            fireRef.child("Users").observeSingleEvent(of: .value, with: { (snapshot: FIRDataSnapshot) in
                let dictionary = snapshot.value as? [String: AnyObject] ?? [:];
                
                for user in dictionary {
                    let em = user.value["email"] as? String ?? "";
                    
                    if em == cUser.email! {
                        
                        let pass = user.value["password"] as? String ?? "";
                        
                        self.emailField.text = em;
                        self.passwordField.text = pass;
                        break;
                    }
                }
                
                self.login();
            })
            
        }
    }
    
    
    /* Goes to the sign up page. */
    @objc func signUp() {
        let signupPage = SignUpPage();
        show(signupPage, sender: self);
    }
    
    
    
    /* Logs the user in and sends them to the home feed page. */
    @objc func login() {
        loginButton.animateButtonClick();
        
        // Sign in.
        if((self.emailField.text?.length())! > 0 && (self.passwordField.text?.length())! > 0) {
            FIRAuth.auth()?.signIn(withEmail: emailField.text!, password: passwordField.text!, completion: { (usr: FIRUser?, error: Error?) in
                if error != nil {

                    self.debug(message: "Wrong Password!");
                    self.statusLabel.textColor = UIColor.red;
                    self.statusLabel.isHidden = false;
                    self.statusLabel.text = "Incorrect password.";
                    
                } else {
                    
                    // Search in the database for the user.
                    self.fireRef.child("Users").observeSingleEvent(of: .value, with: { (snapshot) in
                        
                        let userDictionary = snapshot.value as? [String : AnyObject] ?? [:];
                        
                        for user in userDictionary {
                            let value = user.value as? NSDictionary
                            
                            // Get a user object from the dictionary.
                            let usr = value?.toUser();
                            
                            
                            // If there is a match with the emails, login.
                            if(usr?.email == self.emailField.text!) {
                                currentUser = usr;
                                
                                self.debug(message: "Logged in!");
                                self.statusLabel.textColor = UIColor.green;
                                self.statusLabel.isHidden = false;
                                self.statusLabel.text = "Logging In!";
                                
                                break;
                            } else {
                                
                                self.statusLabel.textColor = UIColor.red;
                                self.statusLabel.isHidden = false;
                                self.statusLabel.text = "Could not find that user.";
                                
                                
                            } // End of email check.
                            
                        } // End of for loop.
                        
                        self.loadUsersPhotos(user: currentUser, continous: true, completion: {
                            self.debug(message: "Loading all of the user's posts...");
                            feedPage.loadPhotos();
                            feedPage.copyOverAndReload();
                            self.loadActivity();
                            self.goToApp();
                        });
                        
                        self.debug(message: "Signed In!");
                    });

                    
                }
            });
            
        } else {
            self.debug(message: "Invalid Credentials!");
            self.statusLabel.textColor = UIColor.red;
            self.statusLabel.isHidden = false;
            self.statusLabel.text = "Invalid Credentials.";
        }
    }
    
    
    
    
    /* Tells the program to take the user to the actually application. */
    private func goToApp() {
        if navigationController?.topViewController !== feedPage {
            navigationController?.pushViewController(feedPage, animated: false);
        }
    }
    
    
    
    // Close the keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event);
        emailField.endEditing(true);
        passwordField.endEditing(true);
    }
    
    
    
    /* Loads all of the current user's photos from the firebase database. This method is public, and
     therefore should be used in any other class that needs to refresh the user's posts.
     PRECONDITION: current user is already initialized to the user that just logged in. */
    public func loadUsersPhotos(user: User, continous: Bool, completion: (() -> Void)?) {
        
        // Start from the beginning.
        user.posts.removeAll();
        
        
        // Load all of the photo objects from the database.
        if continous == false {
            fireRef.child("Photos").child(user.uid).queryOrderedByPriority().observeSingleEvent(of: .value) { (snapshot: FIRDataSnapshot) in
            
                // First, make sure there is a value for the posts. If so, then load all of them.
                let postDictionary = snapshot.value as? [String : AnyObject] ?? [:];
                    
                    
                // Get each post from the database (in the form of json data).
                for post in postDictionary {
                    
                    // Get each individual post as a dictionary of elements with the form [key : value].
                    let value = post.value as? NSDictionary;
                    
                    // Get a post object.
                    let aPost = value?.toPost(user: user);
                    
                    
                    // Get a reference to the firebase media storage.
                    let imgRef = FIRStorage.storage().reference().child("\(user.uid)/\(aPost!.id!).jpg");
                    imgRef.data(withMaxSize: 50 * 1024 * 1024, completion: { (data: Data?, error: Error?) in
                        
                        if error == nil {
                            
                            // Set the image of the post.
                            let image = UIImage(data: data!);
                            aPost?.photo.image = image;
                            
                            
                            // If this post (determined by the id variable) is not already in the array, add it.
                            if(!user.posts.containsID(id: aPost!.id!)) {
                                
                                // Make sure it is not the profile picture. Otherwise just set that for the user here.
                                if(aPost?.isProfilePicture == false) {
                                
                                    user.posts.append(aPost!);
                                    self.debug(message: "Added: \(aPost!.toString())");
                                
                                } else {
                                    
                                    user.profilepic = image;
                                    user.profilePicName = aPost?.id!;
                                    
                                }
                                
                            } else {
                                self.debug(message: "Post \(aPost!.id!) was already in the array, so it was not added again.");
                            }
                            
                        } else {
                            self.debug(message: "There was an error: \(error.debugDescription)");
                        }
                        
                    }); // End of access to media storage.
                    
                } // End of for loop for each post.
            
            };
        } else {
            fireRef.child("Photos").child(user.uid).queryOrderedByPriority().observe(.value) { (snapshot: FIRDataSnapshot) in
                
                // First, make sure there is a value for the posts. If so, then load all of them.
                let postDictionary = snapshot.value as? [String : AnyObject] ?? [:];
                
                
                // Get each post from the database (in the form of json data).
                for post in postDictionary {
                    
                    // Get each individual post as a dictionary of elements with the form [key : value].
                    let value = post.value as? NSDictionary;
                    
                    // Get a post object.
                    let aPost = value?.toPost(user: user);
                    
                    
                    // Get a reference to the firebase media storage.
                    let imgRef = FIRStorage.storage().reference().child("\(user.uid)/\(aPost!.id!).jpg");
                    imgRef.data(withMaxSize: 50 * 1024 * 1024, completion: { (data: Data?, error: Error?) in
                        
                        if error == nil {
                            
                            // Set the image of the post.
                            let image = UIImage(data: data!);
                            aPost?.photo.image = image;
                            
                            
                            // If this post (determined by the id variable) is not already in the array, add it.
                            if(!user.posts.containsID(id: aPost!.id!)) {
                                
                                // Make sure it is not the profile picture. Otherwise just set that for the user here.
                                if(aPost?.isProfilePicture == false) {
                                    
                                    user.posts.append(aPost!);
                                    self.debug(message: "Added: \(aPost!.toString())");
                                    
                                } else {
                                    
                                    user.profilepic = image;
                                    user.profilePicName = aPost?.id!;
                                    
                                }
                                
                            } else {
                                self.debug(message: "Post \(aPost!.id!) was already in the array, so it was not added again.");
                            }
                            
                        } else {
                            self.debug(message: "There was an error: \(error.debugDescription)");
                        }
                        
                    }); // End of access to media storage.
                    
                } // End of for loop for each post.
                
            };
        }
        
        
        if let comp = completion {
            comp();
        }
        
    } // End of the loadUsersPhotos() method.
    

    
    
    public func loadUsedIDs() {
        
        fireRef.child("UsedIDs").observeSingleEvent(of: .value) { (snapshot: FIRDataSnapshot) in
            let array = snapshot.value as? [String] ?? [];
            usedIds.append(contentsOf: array);
        }
        
    } // End of loading ids method.
    
    
    
    public func loadActivity() {
        notificationActivityLog.removeAll();
        
//        UserDefaults.standard.removeObject(forKey: "\(currentUser.uid)_activity_log");
        
        // Load up all of the current user's activity.
        if let defVal = UserDefaults.standard.array(forKey: "\(currentUser.uid)_activity_log") {
            notificationActivityLog = defVal as! [NSDictionary];
        }
        
        
    }
    
    
    public func reloadCurrentUser() {
        // Search in the database for the user.
        self.fireRef.child("Users").child(currentUser.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary ?? [:];
                
            let usr = value.toUser();
            currentUser = usr;
        });
    }
    
    
    public func loadFirebaseUser(completion: (()->Void)?) {
        // Search in the database for the user.
        self.fireRef.child("Users").observe(.value, with: { (snapshot) in
            
            let userDictionary = snapshot.value as? [String : AnyObject] ?? [:];
            
            for user in userDictionary {
                let value = user.value as? NSDictionary
                
                let usr = value?.toUser();
                
                
                // If there is a match with the emails, login.
                if(usr?.email == self.emailField.text!) {
                    currentUser = usr;
                    
                    self.debug(message: "Logged in!");
                    self.statusLabel.textColor = UIColor.green;
                    self.statusLabel.isHidden = false;
                    self.statusLabel.text = "Logging In!";
                    
                    break;
                } else {
                    
                    self.statusLabel.textColor = UIColor.red;
                    self.statusLabel.isHidden = false;
                    self.statusLabel.text = "Could not find that user.";
                    
                    
                } // End of email check.
                
            } // End of for loop.
            
           
            if let comp = completion {
                comp();
            }
        });
        
    } // End of method.
    
}
