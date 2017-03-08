//
//  BlockedUserSectionController.swift
//  Pix
//
//  Created by Adeola Uthman on 1/11/17.
//  Copyright © 2017 Adeola Uthman. All rights reserved.
//

import Foundation
import UIKit
import IGListKit
import Presentr


public class BlockedUserSectionController: IGListSectionController, IGListSectionType {
    
    // The post object to display.
    var username: String?;
    var vc: UIViewController?;
    
    
    
    public init(vc: UIViewController) {
        self.vc = vc;
    }
    
    
    
    public func numberOfItems() -> Int {
        return 1;
    }
    
    public func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: (collectionContext?.containerSize.width)!, height: 30);
    }
    
    public func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext!.dequeueReusableCell(of: BlockedUserCell.self, for: self, at: index) as! BlockedUserCell;
        
        cell.blockedLabel.text = username!;
        
        return cell
    }
    
    public func didUpdate(to object: Any) {
        self.username = object as? String;
    }
    
    public func didSelectItem(at index: Int) {
        let presenter: Presentr = {
            let pres = Presentr(presentationType: .bottomHalf);
            pres.dismissOnSwipe = true;
            pres.dismissAnimated = true;
            return pres;
        }();
        
        let detailView = UnblockUserPage();
        detailView.username = username;
        if let cUser = Networking.currentUser {
            detailView.uid = cUser.blockedUsers[index];
        }
        detailView.blockedPage = vc as! BlockedUsersPage?;
        
        
        vc?.customPresentViewController(presenter, viewController: detailView, animated: true, completion: nil);
    }
    
    
    
}
