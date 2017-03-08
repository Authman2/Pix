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
    
    
    var commentString: String?;
    var cell: CommentsCell?;
    
    
        
    func numberOfItems() -> Int {
        return 1;
    }
    
    func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: (collectionContext?.containerSize.width)!, height: 50);
    }
    
    func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext!.dequeueReusableCell(of: CommentsCell.self, for: self, at: index) as! CommentsCell;
        self.cell = cell;
        
        cell.setup(string: self.commentString);
        
        return cell
    }
    
    func didUpdate(to object: Any) {
        self.commentString = object as? String;
    }
    
    func didSelectItem(at index: Int) {}

}
