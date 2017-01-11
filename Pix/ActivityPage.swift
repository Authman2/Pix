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
import IGListKit


class ActivityPage: UIViewController, IGListAdapterDataSource {
    
    /********************************
     *
     *          METHODS
     *
     ********************************/
    
    /* The IG adapter. */
    lazy var adapter: IGListAdapter = {
        return IGListAdapter(updater: IGListAdapterUpdater(), viewController: self, workingRangeSize: 1);
    }();
    
    
    /* The collection view. */
    let collectionView: IGListCollectionView = {
        let layout = UICollectionViewFlowLayout();
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0);
        let view = IGListCollectionView(frame: CGRect.zero, collectionViewLayout: layout);
        view.alwaysBounceVertical = true;
        
        return view;
    }();
    
    
    /* An array of activities to display. */
    var activities: [Activity] = [Activity]();
    
    
    

    
    /********************************
     *
     *          METHODS
     *
     ********************************/
    
    override func viewDidLoad() {
        super.viewDidLoad();
        navigationItem.title = "Activity";
        
        self.setupCollectionView();
        view.addSubview(collectionView);
        
        self.reloadActivites();
        
        // Pull To Refresh
        var options = PullToRefreshOption();
        options.backgroundColor = UIColor.lightGray.lighter(amount: 20);
        collectionView.addPullRefresh(options: options) { (Void) in
            self.reloadActivites();
            self.adapter.performUpdates(animated: true, completion: nil);
            
            self.collectionView.stopPullRefreshEver();
        }
        
        
        // Clear activity button
        let clearBtn = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(clearActivity));
        clearBtn.tintColor = .white;
        navigationItem.rightBarButtonItem = clearBtn;
        
    } // End of viewdidload.
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews();
        collectionView.frame = view.bounds;
    } // End of viewDidLayoutSubviews().
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        self.adapter.performUpdates(animated: true, completion: nil);
    } // End of viewdidappear.
    
    
    
    @objc func clearActivity() {
        activities.removeAll();
        notificationActivityLog.removeAll();
        UserDefaults.standard.setValue(notificationActivityLog, forKey: "\(currentUser.uid)_activity_log");
        self.adapter.performUpdates(animated: true, completion: nil);
    }
    
    

    
    func setupCollectionView() {
        collectionView.register(ActivityCell.self, forCellWithReuseIdentifier: "Cell");
        collectionView.register(ActivityRequestCell.self, forCellWithReuseIdentifier: "Cell");
        collectionView.backgroundColor = .white;
        
        adapter.collectionView = collectionView;
        adapter.dataSource = self;
    }
    
    
    /* Reloads the activites to make sure any new ones are properly added. */
    func reloadActivites() {
        activities.removeAll();
        
        for itm in notificationActivityLog {
            let item = itm.toActivity();
            self.activities.append(item);
        }
    }
    
    
    
    /********************************
     *
     *       COLLECTION VIEW
     *
     ********************************/
    
    func objects(for listAdapter: IGListAdapter) -> [IGListDiffable] {
        return activities;
    }
    
    func listAdapter(_ listAdapter: IGListAdapter, sectionControllerFor object: Any) -> IGListSectionController {
        return ActivitySectionController();
    }
    
    func emptyView(for listAdapter: IGListAdapter) -> UIView? {
        return EmptyActivityView();
    }
    
}
