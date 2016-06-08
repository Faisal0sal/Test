//
//  Search.swift
//  Test
//
//  Created by F M S ALSALAMAH on 08/06/2016.
//  Copyright © 2016 F M S ALSALAMAH. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class Search: UIViewController {
    
    var tag : String?
    var uid : String?
    
    var hashtagsRef: FIRDatabaseReference!
    lazy var ref: FIRDatabaseReference = FIRDatabase.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // -- Set variables AppState
        tag = AppState.sharedInstance.tag
        
        // -- set Navigation title as the tag
        navigationItem.title = tag
        
        // -- Set hashtag ref
        hashtagsRef = ref.child(Constants.Hashtags.hashtags)
        
        // -- Add hashtag to database
        if let tag = AppState.sharedInstance.tag {
            
            if let user = FIRAuth.auth()?.currentUser {
                hashtagsRef.child(tag).setValue([Constants.Hashtags.uid: user.uid])
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
}