//
//  CommentsPage.swift
//  Pix
//
//  Created by Adeola Uthman on 2/16/17.
//  Copyright © 2017 Adeola Uthman. All rights reserved.
//

import Foundation
import UIKit
import IGListKit
import SnapKit
import ChameleonFramework
import Presentr


class CommentsPage: UIViewController, IGListAdapterDataSource {
    
    /********************************
     *
     *          VARIABLES
     *
     ********************************/
    
    /* The post to display comments for. */
    var post: Post!;
    
    /* The IG adapter. */
    lazy var adapter: IGListAdapter = {
        return IGListAdapter(updater: IGListAdapterUpdater(), viewController: self, workingRangeSize: 1);
    }();
    
    
    /* The collection view. */
    let collectionView: IGListCollectionView = {
        let layout = UICollectionViewFlowLayout();
        layout.minimumLineSpacing = 20;
        layout.minimumInteritemSpacing = 20;
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0);
        
        let view = IGListCollectionView(frame: CGRect.zero, collectionViewLayout: layout);
        view.alwaysBounceVertical = true;
        
        return view;
    }();
    
    
    /* A text field for adding a comment. */
    let addCommentField: UITextField = {
        let p = UITextField();
        p.translatesAutoresizingMaskIntoConstraints = false;
        p.placeholder = "Add a comment";
        p.backgroundColor = UIColor.white;
        p.textColor = .black;
        p.textAlignment = .center;
        p.isSecureTextEntry = true;
        p.autocorrectionType = .no;
        p.autocapitalizationType = .none;
        
        return p;
    }();
    
    
    
    
    
    
    
    
    
    /********************************
     *
     *          METHODS
     *
     ********************************/
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.setupCollectionView();
        
        
        /* Add to the view and layout. */
        view.addSubview(addCommentField);
        view.addSubview(collectionView);
        
        addCommentField.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.left.equalTo(view.snp.left);
            maker.top.equalTo(view.snp.top);
            maker.right.equalTo(view.snp.right);
            maker.height.equalTo(40);
        }
        collectionView.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.left.equalTo(view.snp.left);
            maker.top.equalTo(addCommentField.snp.bottom);
            maker.right.equalTo(view.snp.right);
            maker.bottom.equalTo(view.snp.bottom);
        }
        
        
        /* Adding a comment. */
        addCommentField.addTarget(self, action: #selector(openAddCommentBox), for: .editingDidBegin);
    }
    
    func setupCollectionView() {
        collectionView.register(CommentsCell.self, forCellWithReuseIdentifier: "Cell");
        collectionView.backgroundColor = .flatGray;
        
        adapter.collectionView = collectionView;
        adapter.dataSource = self;
    }
    
    
    func openAddCommentBox() {
        let pres: Presentr = {
            let pres = Presentr(presentationType: .popup);
            pres.dismissOnSwipe = true;
            pres.dismissAnimated = true;
            pres.backgroundOpacity = 0.7;
            return pres;
        }();
        let addVC = AddCommentPage();
        addVC.post = self.post;
        
        customPresentViewController(pres, viewController: addVC, animated: true, completion: nil);
    }
    
    
    
    
    
    /********************************
     *
     *       COLLECTION VIEW
     *
     ********************************/
    
    func objects(for listAdapter: IGListAdapter) -> [IGListDiffable] {
        return self.post.comments as [IGListDiffable];
    }
    
    func listAdapter(_ listAdapter: IGListAdapter, sectionControllerFor object: Any) -> IGListSectionController {
        return CommentsSectionController();
    }
    
    func emptyView(for listAdapter: IGListAdapter) -> UIView? {
        return EmptyCommentsView();
    }
}
