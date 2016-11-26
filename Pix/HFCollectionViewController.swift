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


class HFCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
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
    

    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postData.count;
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> PostCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PostCell;
        
        
        // Get the post data, then setup the layout and variables accordingly.
        cell.post = postData[indexPath.item];
        cell.setupLayout();
        cell.setupVariables();
        
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size: CGSize! = CGSize(width: view.frame.width - 20, height: 300);
        
        return size;
    }
    

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
