//
//  FeedSectionController.swift
//  Pix
//
//  Created by Adeola Uthman on 1/7/17.
//  Copyright © 2017 Adeola Uthman. All rights reserved.
//

import UIKit
import IGListKit
import Hero

class FeedSectionController: IGListSectionController, IGListSectionType {

    
    // The post object to display.
    var post: Post?;
    
    // A reference to the view controller.
    var vc: UIViewController?;
    
    
    
    
    init(vc: UIViewController) {
        self.vc = vc;
    }
    
    
    
    
    
    func numberOfItems() -> Int {
        return 1;
    }
    
    func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: (collectionContext?.containerSize.width)! - 20, height: 380);
    }
    
    func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext!.dequeueReusableCell(of: FeedCell.self, for: self, at: index) as! FeedCell;
        
        cell.post = post;
        cell.vc = self.vc;
        cell.imageView.image = cell.post.photo;
        cell.captionLabel.text = "\(cell.post.caption!)";
        cell.likesLabel.text = "Likes: \(cell.post.likes)";
        cell.uploaderLabel.text = "\(cell.post.uploader.firstName) \(cell.post.uploader.lastName)";
        
        return cell
    }
    
    func didUpdate(to object: Any) {
        self.post = object as? Post;
    }
    
    func didSelectItem(at index: Int) {
        let detail = PostDetailPage();
        detail.post = self.post!;
        detail.isHeroEnabled = true;
        
        self.vc?.navigationItem.title = "";
        if(navContr.open == true) { navContr.togglePulldownMenu(); }
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
    }
    
}
