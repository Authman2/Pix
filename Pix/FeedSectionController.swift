//
//  FeedSectionController.swift
//  Pix
//
//  Created by Adeola Uthman on 1/7/17.
//  Copyright © 2017 Adeola Uthman. All rights reserved.
//

import UIKit
import IGListKit

class FeedSectionController: IGListSectionController, IGListSectionType {

    
    // The post object to display.
    var post: Post?;
    
    
    
    
    func numberOfItems() -> Int {
        return 1;
    }
    
    func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: (collectionContext?.containerSize.width)! - 20, height: 300);
    }
    
    func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext!.dequeueReusableCell(of: FeedCell.self, for: self, at: index) as! FeedCell;
        
        cell.post = post;
        cell.imageView.image = cell.post.photo.image!;
        cell.captionLabel.text = "\(cell.post.caption.text!)";
        cell.likesLabel.text = "Likes: \(cell.post.likes)";
        cell.uploaderLabel.text = "\(cell.post.uploader.firstName) \(cell.post.uploader.lastName)";
        
        return cell
    }
    
    func didUpdate(to object: Any) {
        self.post = object as? Post;
    }
    
    func didSelectItem(at index: Int) {}
    
}
