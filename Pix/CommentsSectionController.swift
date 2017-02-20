//
//  CommentsSectionController.swift
//  Pix
//
//  Created by Adeola Uthman on 2/16/17.
//  Copyright © 2017 Adeola Uthman. All rights reserved.
//

import Foundation
import IGListKit


class CommentsSectionController: IGListSectionController, IGListSectionType {
    
    
    var post: Post?;
    
    
    func numberOfItems() -> Int {
        return 1;
    }
    
    func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: (collectionContext?.containerSize.width)!, height: 50);
    }
    
    func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext!.dequeueReusableCell(of: FeedCell.self, for: self, at: index) as! CommentsCell;
        
        cell.setup(string: post!.comments[index]);
        
        return cell
    }
    
    func didUpdate(to object: Any) {
        self.post = object as? Post;
    }
    
    func didSelectItem(at index: Int) {}

}
