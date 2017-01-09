//
//  Activity.swift
//  Pix
//
//  Created by Adeola Uthman on 1/8/17.
//  Copyright © 2017 Adeola Uthman. All rights reserved.
//

import Foundation
import UIKit
import IGListKit


public class Activity: NSObject, IGListDiffable {
    
    /********************************
     *
     *          VARIABLES
     *
     ********************************/
    
    
    /* The words that show what the activity is. */
    var text: String?;
    
    
    /* Whether or not the accept or decline buttons should show on the activity. Only used for follower requests. */
    var interactionRequired: Bool!;
    
    
    /* Whether or not the user has already interacted with this activity. */
    var interactedWith: Bool!;
    
    
    /* The user who sent the notification for this activity. */
    var user: User?;
    
    
    
    
    
    /********************************
     *
     *          METHODS
     *
     ********************************/
    
    init(text: String, interactionRequired: Bool) {
        self.text = text;
        self.interactionRequired = interactionRequired;
        
        if self.interactionRequired == false {
            interactedWith = true;
        } else {
            interactedWith = false;
        }
    }
    
    
    
    
    public func toDictionary() -> NSDictionary {
        return ["text": self.text!,
                "interaction_required": self.interactionRequired,
                "interacted_with": self.interactedWith,
                "user": self.user?.toDictionary() ?? [:]];
    }
    
    
    
    
    
    
    /********************************
     *
     *          IGLISTKIT
     *
     ********************************/
    
    
    public func diffIdentifier() -> NSObjectProtocol {
        return self;
    }
    
    
    public func isEqual(toDiffableObject object: IGListDiffable?) -> Bool {
        if let obj = object as! Activity? {
            if text == obj.text {
                return true;
            }
        }
        return false;
    }
    
    
}
