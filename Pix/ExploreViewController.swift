//
//  ExploreViewController.swift
//  Pix
//
//  Created by Adeola Uthman on 12/5/16.
//  Copyright © 2016 Adeola Uthman. All rights reserved.
//

import UIKit

class ExploreViewController: UITableViewController {

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell");

        
        // Create a search bar
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 100));
        view.addSubview(searchBar);
    }

    
    
    
    


    
    //////////// Table View //////////////
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5;
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell;
        
        
        return cell;
    }
    
    
}
