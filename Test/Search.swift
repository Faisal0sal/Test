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
                                
                hashtagsRef.child(tag).child(user.uid).setValue("")
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        pickRandomPeopleFromHasgtag()
    }
    
    func pickRandomPeopleFromHasgtag() {
        
        hashtagsRef.queryOrderedByKey().queryStartingAtValue(tag).observeSingleEventOfType(.ChildAdded, withBlock: { (snapshot) in
            
            let hashtags = snapshot.value as? NSDictionary
            if let users : NSArray = hashtags?.allKeys {
                if let randomNumber : Int = Int(arc4random_uniform(UInt32(users.count))) {
                    if let uid : String? = users[randomNumber] as? String {
                        if (FIRAuth.auth()?.currentUser?.uid) == uid {
                            self.pickRandomPeopleFromHasgtag()
                            
                        }else{
                            AppState.sharedInstance.uid = uid
                            self.performSegueWithIdentifier(Constants.Segues.ToChat, sender: self)
                        }
                    }
                }
            }
        })
    }
    
    override func viewWillDisappear(animated: Bool) {
        if let user = FIRAuth.auth()?.currentUser {
            self.hashtagsRef.child(tag!).child(user.uid).removeValue()
        }
    }
}