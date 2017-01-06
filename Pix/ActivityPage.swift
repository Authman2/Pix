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
        
        let titleForRow = notificationActivityLog[notificationActivityLog.count - indexPath.row - 1];
        cell.titleLabel.text = titleForRow;
        
        cell.setup();
        
        return cell;
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if notificationActivityLog[notificationActivityLog.count - indexPath.row - 1].contains("wants to follow you") {
            return 65;
        } else {
            return 50;
        }
    }
}
