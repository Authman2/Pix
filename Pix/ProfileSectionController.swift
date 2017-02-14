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
import Hero

class ProfileSectionController: IGListSectionController, IGListSectionType {
    
    
    // The post object to display.
    var post: Post?;
    var currentCell: ProfilePageCell?;
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
        currentCell = cell;
        
        cell.post = post;
        cell.imageView.image = post?.photo;
        cell.setup();
        
        return cell
    }
    
    func didUpdate(to object: Any) {
        self.post = object as? Post;
    }
    
    func didSelectItem(at index: Int) {
        if let _ = currentCell {
            let detail = PostDetailPage();
            detail.post = self.post!;
            
            self.vc?.navigationItem.title = "";
            UIView.animate(withDuration: 0.4, delay: 0, options: [], animations: {
                self.vc?.navigationController?.navigationBar.alpha = 0;
                self.vc?.navigationItem.titleView?.alpha = 0;
            }, completion: { (finished: Bool) in
                self.vc?.navigationController?.navigationBar.isHidden = true;
                self.vc?.navigationItem.titleView?.isHidden = true;
            })
            
            Hero.shared.setDefaultAnimationForNextTransition(animations[0]);
            Hero.shared.setContainerColorForNextTransition(detail.view.backgroundColor);
            
            vc?.hero_replaceViewController(with: detail);
            
//            detail.transitioningDelegate = vc;
//            detail.modalPresentationStyle = .custom;
            
//            detail.imageView.heroID = "imageView";
//            detail.uploaderLabel.heroID = "uploaderLabel";
//            detail.likesLabel.heroID = "likesLabel";
//            detail.captionLabel.heroID = "captionLabel";
            
            //vc?.present(detail, animated: true, completion: nil);
        }
    }
    
}
