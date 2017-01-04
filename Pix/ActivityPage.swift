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
        options.backgroundColor = UIColor.lightGray.lighter(amount: 40);
        tableView.addPullRefresh(options: options) { (Void) in
            self.tableView.reloadData();
            self.tableView.stopPullRefreshEver();
        }
        
        
        // Auto sizing cells.
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.estimatedRowHeight = 140;
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        tableView.reloadData();
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
        cell.setup();
        
        return cell;
    }
    
    
}
