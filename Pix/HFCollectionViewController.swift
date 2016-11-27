//
//  HFCollectionViewController.swift
//  Pix
//
//  Created by Adeola Uthman on 11/15/16.
//  Copyright © 2016 Adeola Uthman. All rights reserved.
//
//
//  This is the collection view that displays the post data on the home feed.
//

import UIKit
import Firebase
import AUNavigationMenuController
import DZNEmptyDataSet


class HFCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    
    // The reusable cell identifier
    private let reuseIdentifier = "cell";
    
    // An array of posts (this one is only used for testing purposes)
    private var postData: [Post] = [];
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up some basic window properties
        setupWindow();
        
        
        // Register cell classes
        collectionView!.register(PostCell.self, forCellWithReuseIdentifier: reuseIdentifier);
    
        
        // Setup empty data set stuff
        collectionView?.emptyDataSetSource = self;
        collectionView?.emptyDataSetDelegate = self;
        collectionView?.contentMode = .scaleAspectFit;
        
        
        // Load data from the database
    }

    
    
    
    
    
    
    // MARK: - Setup
    
    
    private func setupWindow() {
        collectionView?.backgroundColor = UIColor(red: 239/255, green: 255/255, blue:245/255, alpha: 1);
        navigationItem.title = "Pix";
        collectionView?.alwaysBounceVertical = true;
        collectionView?.showsHorizontalScrollIndicator = false;
        collectionView?.showsVerticalScrollIndicator = false;
    }
    
    
    
    
    
    
    
    
    
    
    // MARK: - Navigation

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    

    
    // Sections
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }


    // Number of items
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postData.count;
    }

    
    // Cell for index path
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> PostCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PostCell;
        
        
        // Get the post data, then setup the layout and variables accordingly.
        cell.post = postData[indexPath.item];
        cell.setupLayout();
        cell.setupVariables();
        
        
        return cell
    }
    
    
    // Size for cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size: CGSize! = CGSize(width: view.frame.width - 20, height: 300);
        
        return size;
    }
    
    
    // Empty set
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let s = NSAttributedString(string: "No photos to display");
        return s;
    }
}
