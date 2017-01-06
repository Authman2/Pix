//
//  ActivityPage.swift
//  Pix
//
//  Created by Adeola Uthman on 1/3/17.
//  Copyright © 2017 Adeola Uthman. All rights reserved.
//

import UIKit
import PullToRefreshSwift
import DynamicColor


class ActivityPage: UITableViewController {

    
    /********************************
     *
     *          VARIABLES
     *
     ********************************/
    
    override func viewDidLoad() {
        super.viewDidLoad();
        navigationItem.title = "Activity";
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.register(ActivityCell.self, forCellReuseIdentifier: "Cell");
        
        
        // Pull To Refresh
        var options = PullToRefreshOption();
        options.backgroundColor = UIColor.lightGray.lighter(amount: 20);
        tableView.addPullRefresh(options: options) { (Void) in
            self.tableView.reloadData();
            self.tableView.stopPullRefreshEver();
        }
        
        
        // Auto sizing cells.
        tableView.estimatedRowHeight = 140;
        tableView.rowHeight = UITableViewAutomaticDimension;
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        tableView.reloadData();
        
        // Auto sizing cells.
        tableView.estimatedRowHeight = 140;
        tableView.rowHeight = UITableViewAutomaticDimension;
    }
    
    
    
    
    
    
    
    
    /********************************
     *
     *          METHODS
     *
     ********************************/
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationActivityLog.count;
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ActivityCell;
        cell.profileView.image = UIImage(data: profilePicturesActivityLog[profilePicturesActivityLog.count - indexPath.row - 1]);
        cell.titleLabel.text = notificationActivityLog[notificationActivityLog.count - indexPath.row - 1];
        
        let userForRow = usersOnActivity[usersOnActivity.count - indexPath.row - 1].toUser();
        userForRow.profilepic = UIImage(data: profilePicturesActivityLog[profilePicturesActivityLog.count - indexPath.row - 1]);
        cell.user = userForRow;
        
        
        if notificationActivityLog[notificationActivityLog.count - indexPath.row - 1].contains("wants to follow you") {
            cell.acceptButton.isHidden = false;
            cell.declineButton.isHidden = false;
        } else {
            cell.acceptButton.isHidden = true;
            cell.declineButton.isHidden = true;
        }
        
        // If the user has already been added to followers.
        if currentUser.followers.containsUsername(username: userForRow.uid) {
            
            cell.acceptButton.isHidden = true;
            cell.declineButton.isHidden = true;
        }
        
        
        cell.setup();
        
        return cell;
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if notificationActivityLog[notificationActivityLog.count - indexPath.row - 1].contains("wants to follow you") {
            return 55;
        } else {
            return 50;
        }
    }
}
