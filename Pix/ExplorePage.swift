//
//  ExplorePage.swift
//  Pix
//
//  Created by Adeola Uthman on 12/25/16.
//  Copyright © 2016 Adeola Uthman. All rights reserved.
//

import UIKit
import Neon
import Firebase

class ExplorePage: UITableViewController, UISearchResultsUpdating {

    
    /********************************
     *
     *          VARIABLES
     *
     ********************************/
    
    /* The search controller. */
    let searchController = UISearchController(searchResultsController: nil);
    
    
    /* The users that will be found from firebase. */
    var listOfUsers_fb: NSMutableArray! = NSMutableArray();
    
    
    /* User objects that represent each user found in the search. */
    var listOfUsers: [User] = [User]();
    
    
    /* The reference to the firebase database. */
    let fireRef: FIRDatabaseReference = FIRDatabase.database().reference();
    
    
    
    
    
    
    
    
    
    
    /********************************
     *
     *          METHODS
     *
     ********************************/

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Explore";
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.register(ExploreCell.self, forCellReuseIdentifier: "Cell");
        
        
        searchController.searchResultsUpdater = self;
        searchController.dimsBackgroundDuringPresentation = false;
        definesPresentationContext = true;
        tableView.tableHeaderView = searchController.searchBar;
    
    } // End of viewDidLoad().
    
    
    
    /* Searches through firebase and collects a list of users. 
     POSTCONDITION: The arrays for the users in the form of firebase data as well as User objects will be filled (assuming that users were found). */
    func findUsers(lookup: String) {
        
        /* First, clear all of the searches. */
        listOfUsers_fb.removeAllObjects();
        listOfUsers.removeAll();
        
        
        /* Then, make sure the search bar is not empty. */
        if((searchController.searchBar.text?.length())! > 0) {
            
            fireRef.child("Users").observeSingleEvent(of: .value) { (snapshot: FIRDataSnapshot) in
              
                // Get the snapshot
                let userDictionary = snapshot.value as? [String : AnyObject] ?? [:];
                
                
                // Look through each user.
                for user in userDictionary {
                    
                    let value = user.value as? NSDictionary ?? [:];
                    
                    let usr = value.toUser();
                    let fullName = "\(usr.firstName) \(usr.lastName)";
                    
                    
                    // Compare
                    if(lookup.length() <= usr.username.length() || lookup.length() <= fullName.length()) {
                        if(usr.username.substring(i: 0, j: lookup.length()) == lookup || fullName.substring(i: 0, j: lookup.length()) == lookup) {
                            self.debug(message: "Found: \(usr.username)");
                            
                            // Add to the lists.
                            self.listOfUsers_fb.add(user);
                            self.listOfUsers.append(usr);
                            
                            /* Reload the table view. */
                            self.tableView.reloadData();
                        }
                    } else {
                        if(usr.username.substring(i: 0, j: usr.username.length()) == lookup || fullName.substring(i: 0, j: fullName.length()) == lookup) {
                            self.debug(message: "Found: \(usr.username)");
                                                        
                            // Add to the lists.
                            self.listOfUsers_fb.add(user);
                            self.listOfUsers.append(usr);
                            
                            /* Reload the table view. */
                            self.tableView.reloadData();
                        }
                    }
                }
            };
            
        } // End of checking if the search bar is not empty.
        else {
            listOfUsers_fb.removeAllObjects();
            listOfUsers.removeAll();
            tableView.reloadData();
        }
        
        
        
        
    } // End of find user method.
    
    
    
    
    
    
    
    
    /********************************
     *
     *          TABLE VIEW
     *
     ********************************/

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfUsers.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> ExploreCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ExploreCell;
        
        cell.setup(u_fb: listOfUsers_fb[indexPath.row], u: listOfUsers[indexPath.row]);
        
        return cell;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if listOfUsers.count > 0 {
            
            // Tell the profile page which user to use.
            otherProfilePage.useUser = listOfUsers[indexPath.row];
            
            if(Networking.currentUser!.following.containsUsername(username: listOfUsers[indexPath.row].uid)) {
                otherProfilePage.followButton.setTitle("Unfollow", for: .normal);
            } else {
                otherProfilePage.followButton.setTitle("Follow", for: .normal);
            }
            
            
            // Load all of that user's photos.
            
            /* CHECK IF PRIVATE ACCOUNT. */
            if otherProfilePage.useUser.isPrivate == false || (otherProfilePage.useUser.isPrivate == true && Networking.currentUser!.following.containsUsername(username: otherProfilePage.useUser.uid)) {
                
                util.loadUsersPhotos(user: otherProfilePage.useUser, continous: false, completion: {
                    otherProfilePage.adapter.reloadData(completion: { (b: Bool) in
                        otherProfilePage.reloadLabels();
                    });
                });
                otherProfilePage.privateLabel.isHidden = true;
                otherProfilePage.collectionView.isHidden = false;
                
            } else {
                
                otherProfilePage.privateLabel.isHidden = false;
                otherProfilePage.collectionView.isHidden = true;
                
            }
            
            // Go to the next page.
            navigationController?.pushViewController(otherProfilePage, animated: true);
            otherProfilePage.navigationItem.title = "\(listOfUsers[indexPath.row].username)";
        }
    }
    
    /* Update the table view based on the search. */
    public func updateSearchResults(for searchController: UISearchController) {
        /* When the text changes, start looking up the users. */
        findUsers(lookup: searchController.searchBar.text!);
    }
    
}
