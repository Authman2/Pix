//
//  ActivitySectionController.swift
//  Pix
//
//  Created by Adeola Uthman on 1/8/17.
//  Copyright © 2017 Adeola Uthman. All rights reserved.
//

import UIKit
import IGListKit

class ActivitySectionController: IGListSectionController, IGListSectionType {

    
    /* The activity object. */
    var activityObject: Activity?;
    
    
    
    
    
    func numberOfItems() -> Int {
        return 1;
    }
    
    
    func sizeForItem(at index: Int) -> CGSize {
        if activityObject?.interactionRequired == true {
            return CGSize(width: (collectionContext?.containerSize.width)!, height: 60);
        } else {
            return CGSize(width: (collectionContext?.containerSize.width)!, height: 50);
        }
    }
    
    
    func cellForItem(at index: Int) -> UICollectionViewCell {
        let cellClass: AnyClass = activityObject?.interactionRequired == true ? ActivityRequestCell.self : ActivityCell.self;
        let cell = collectionContext!.dequeueReusableCell(of: cellClass, for: self, at: index);

        if let cell = cell as? ActivityRequestCell {
            
            cell.activity = self.activityObject!;
            cell.titleLabel.text = "\(activityObject!.text!)";
            
            if self.activityObject?.interactedWith == true {
                cell.acceptButton.isHidden = true;
                cell.declineButton.isHidden = true;
            }
            
        } else if let cell = cell as? ActivityCell {
            
            cell.titleLabel.text = "\(activityObject!.text!)";
            
        }
        
        return cell;
    }
    
    
    func didUpdate(to object: Any) {
        self.activityObject = object as? Activity;
    }
    
    
    func didSelectItem(at index: Int) {
        
    }
    
}
