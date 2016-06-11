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
    var added: FIRDatabaseReference!
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
                
                added = hashtagsRef.child(tag).childByAutoId()
                added.setValue(["uid":user.uid])
                added.onDisconnectRemoveValue()
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        // -- Pick random people 
        pickRandomPeopleFromHasgtag()
    }
    
    func pickRandomPeopleFromHasgtag() {
        
        hashtagsRef.child(tag!).observeEventType(.ChildAdded, withBlock: { (snapshot) in
            
            let enumerator = snapshot.children
            while let snap = enumerator.nextObject() as? FIRDataSnapshot {
                print(snap.value)
            }
        })
    }
    
    override func viewWillDisappear(animated: Bool) {
        // - Using the reference for added hashtag, it will be deleted once the search page is off
        added.removeValue()
    }
}