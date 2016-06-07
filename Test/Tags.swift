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
    
    @IBOutlet weak var tagField: UITextField!
    
    @IBOutlet weak var startChatting: UIButton!
    @IBAction func startChatting(sender: UIButton) {
        
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
    
    let trendingTags : [String] = ["Game of thrones","Peaky blinders","Peaky blinders","Peaky blinders","Peaky blinders","Peaky blinders","Peaky blinders","Peaky blinders"]
    
    override func viewDidLoad() {
        
    }
    
    override func viewDidAppear(animated: Bool) {
        // -- Hide Back Button
        self.navigationItem.setHidesBackButton(true, animated: true)
        // -- Dissmiss keyboard
        dismissKeyBoardOnEndEditing()
        // -- Add bottom borders to buttons
        tagField.addBorder(.Bottom, color: UIColor(red: CGFloat(207/255.0), green: CGFloat(207/255.0), blue: CGFloat(207/255.0), alpha: CGFloat(1.0)), width: 2.0)
        // -- Add border to button
        self.startChatting.layer.borderColor = UIColor.grayColor().CGColor
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return "Current Trending hashtags"
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trendingTags.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        
        cell.textLabel?.text = trendingTags[indexPath.row]
        
        return cell
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        if (textField.text?.characters.count == 1 && string == "") {
            textField.text = "#"
            return false
        }
        
        if textField.text?.characters.count <= 1 {
            textField.text = "#"
        }
        
        if string.containsString(" ") {
            let replacedString = string.stringByReplacingOccurrencesOfString(" ", withString: "_", options: NSStringCompareOptions.LiteralSearch, range: nil)
            
            textField.text?.appendContentsOf(replacedString)
            return false
        }
        
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        view.endEditing(true)
        self.view.endEditing(true)
    }
}