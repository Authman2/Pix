//
//  ProfileSectionController.swift
//  Pix
//
//  Created by Adeola Uthman on 1/8/17.
//  Copyright © 2017 Adeola Uthman. All rights reserved.
//

import UIKit
import IGListKit
import Presentr

class ProfileSectionController: IGListSectionController, IGListSectionType {
    
    
    // The post object to display.
    var post: Post?;
    
    // A reference to the view controller that is presenting this view.
    var vc: UIViewController?;
    
    
    
    
    
    init(vc: UIViewController) {
        self.vc = vc;
    }
    
    
    
    func numberOfItems() -> Int {
        return 1;
    }
    
    func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: (collectionContext?.containerSize.width)!/4, height: 90);
    }
    
    func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext!.dequeueReusableCell(of: ProfilePageCell.self, for: self, at: index) as! ProfilePageCell;
        
        cell.imageView.image = post?.photo;
        cell.setup();
        
        
        return cell
    }
    
    func didUpdate(to object: Any) {
        self.post = object as? Post;
    }
    
    func didSelectItem(at index: Int) {
        let presenter: Presentr = {
            let pres = Presentr(presentationType: .popup);
            pres.dismissOnSwipe = true;
            pres.dismissAnimated = true;
            return pres;
        }();
        
        let detailView = PostDetailPage();
        detailView.setup(post: self.post!);
        
        
        vc?.customPresentViewController(presenter, viewController: detailView, animated: true, completion: nil);
    }
    
    
}
