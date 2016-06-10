//
//  Chats.swift
//  Test
//
//  Created by F M S ALSALAMAH on 24/05/2016.
//  Copyright © 2016 F M S ALSALAMAH. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class Tags: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var loadingHashtags: UIActivityIndicatorView!
    
    @IBOutlet weak var trendingTable: UITableView!
    @IBOutlet weak var tagField: UITextField!
    
    @IBOutlet weak var startChatting: UIButton!
    @IBAction func startChatting(sender: UIButton) {
        
        if tagField.text?.isEmpty != true {
            // -- Move to search page
            self.performSegueWithIdentifier(Constants.Segues.ToSearch, sender: self)
            AppState.sharedInstance.tag = tagField.text
            print("Filled")
        }else{
            tagField.becomeFirstResponder()
        }
    }
    
    @IBAction func logOut(sender: UIBarButtonItem) {
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
            AppState.sharedInstance.signedIn = false
            performSegueWithIdentifier(Constants.Segues.ToLogIn, sender: nil)
        } catch let logOutError as NSError {
            print ("Error logout: \(logOutError)")
        }
    }
    
    var trendingHashtags = Array<(hashtag: String, count: UInt)>()
    
    var hashtagsRef: FIRDatabaseReference!
    lazy var ref: FIRDatabaseReference = FIRDatabase.database().reference()
    
    override func viewDidLoad() {
        
        hashtagsRef = ref.child(Constants.Hashtags.hashtags)
    }
    
    override func viewDidAppear(animated: Bool) {
        // -- Hide Back Button
        self.navigationItem.setHidesBackButton(true, animated: true)
        // -- Dissmiss keyboard on touch outside the textfield
        dismissKeyBoardOnEndEditing()
        // -- Add bottom borders to buttons
        tagField.addBorder(.Bottom, color: UIColor(red: CGFloat(207/255.0), green: CGFloat(207/255.0), blue: CGFloat(207/255.0), alpha: CGFloat(1.0)), width: 2.0)

        self.trendingHashtags.removeAll()
        // -- Get trending hashtags
        
        hashtagsRef.observeEventType(.ChildAdded, withBlock: { (snapshot) in
            
            let enumerator = snapshot.children
            while let snap = enumerator.nextObject() as? FIRDataSnapshot {
                self.trendingHashtags += [(snapshot.key, snap.childrenCount)]
            }
            
            self.trendingTable.reloadData()
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        hashtagsRef.observeEventType(.ChildRemoved, withBlock: { (snapshot) -> Void in
            let index = self.indexOfMessage(snapshot)
            self.trendingHashtags.removeAtIndex(index)
            self.trendingTable.deleteRowsAtIndexPaths([NSIndexPath(forRow: index, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Automatic)
        })
    }
    
    func indexOfMessage(snapshot: FIRDataSnapshot) -> Int {
        var index = 0
        for message in self.trendingHashtags {
            if (snapshot.key == message.hashtag) {
                return index
            }
            print(snapshot.key)
            index += 1
        }
        return -1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return trendingHashtags.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        
        cell.textLabel?.text = trendingHashtags[indexPath.row].hashtag
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.performSegueWithIdentifier(Constants.Segues.ToSearch, sender: self)
        AppState.sharedInstance.tag = trendingHashtags[indexPath.row].hashtag
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        // -- replace spaces with "_" for hashtag use
        if string.containsString(" ") {
            let replacedString = string.stringByReplacingOccurrencesOfString(" ", withString: "_", options: NSStringCompareOptions.LiteralSearch, range: nil)
            
            textField.text?.appendContentsOf(replacedString)
            return false
        }
        
        return true
    }
}