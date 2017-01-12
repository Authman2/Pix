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
    
    
    /* An id to keep track of each activity. */
    var id: String?;
    
    
    
    
    
    /********************************
     *
     *          METHODS
     *
     ********************************/
    
    init(text: String, interactionRequired: Bool) {
        super.init();
        self.text = text;
        self.interactionRequired = interactionRequired;
        self.interactedWith = false;
        self.id = randomName();
    }
    
    
    
    
    public func toDictionary() -> NSDictionary {
        return ["text": self.text!,
                "id": self.id!,
                "interaction_required": self.interactionRequired,
                "interacted_with": self.interactedWith,
                "user": self.user?.toDictionary() ?? [:]];
    }
    
    
    /* A random id for each activity. */
    public func randomName() -> String {
        var id = "";
        let arr: [String] = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","1","2","3","4","5","6","7","8","9","0"];
        
        while id.length() < 20 {
            let random = arc4random_uniform(UInt32(arr.count));
            id += arr[Int(random)];
        }
        
        return id;
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
            if id == obj.id {
                return true;
            }
        }
        return false;
    }
    
    
}
