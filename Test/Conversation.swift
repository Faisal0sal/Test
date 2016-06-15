//
//  Conversation.swift
//  Test
//
//  Created by F M S ALSALAMAH on 24/05/2016.
//  Copyright © 2016 F M S ALSALAMAH. All rights reserved.
//

import UIKit
import Firebase

class Conversation: UIViewController, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var ChatTableView: UITableView!
    @IBOutlet weak var MessageTextViewField: UITextView!
    @IBOutlet weak var MessageTextViewView: UIView!
    @IBOutlet weak var MessageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var MessageViewFieldHeightConstraint: NSLayoutConstraint!
    
    @IBAction func Back(sender: AnyObject) {
        performSegueWithIdentifier("ToTags", sender: self)
    }
    
    @IBAction func Send(sender: AnyObject) {
        
        if let user = FIRAuth.auth()?.currentUser {
            self.ref.child("messages").childByAutoId().setValue(["message":MessageTextViewField.text,"sender":user.uid])
            MessageTextViewField.text = ""
        }
    }

    var messagesRef: FIRDatabaseReference!
    lazy var ref: FIRDatabaseReference = FIRDatabase.database().reference()

    private var previousRect = CGRectZero
    var msgs: Array<FIRDataSnapshot> = []

    // Keyboard details
    struct keyBoard {
        var KeyBoardHeight = CGFloat()
        var Duration = NSTimeInterval()
        var Curve = UInt()
    }
    var keyboard = keyBoard()

    override func viewDidLoad() {
        super.viewDidLoad()
        messagesRef = ref.child("messages")
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(Conversation.keyboardShown(_:)), name: UIKeyboardWillChangeFrameNotification, object: nil)
        
        self.MessageTextViewField.delegate = self
        // UITextViewExtension ---
        dismissKeyBoardOnEndEditing()
        // Setting up AUTOMATICDIMENSION
        ChatTableView.estimatedRowHeight = 68.0
        ChatTableView.rowHeight = UITableViewAutomaticDimension
        print(AppState.sharedInstance.uid)
    }

    override func viewWillAppear(animated: Bool) {
        // -- Hide Back Button
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        messagesRef.queryEqualToValue(AppState.sharedInstance.uid).observeEventType(.ChildAdded, withBlock: { (snapshot) -> Void in
            print(snapshot)
            self.msgs.append(snapshot)
            self.ChatTableView.insertRowsAtIndexPaths([NSIndexPath(forRow: self.msgs.count-1, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Automatic)
        })
        
        messagesRef.observeEventType(.ChildRemoved, withBlock: { (snapshot) -> Void in
            let index = self.indexOfMessage(snapshot)
            self.msgs.removeAtIndex(index)
            self.ChatTableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: index, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Automatic)
        })
    }

    func indexOfMessage(snapshot: FIRDataSnapshot) -> Int {
        var index = 0
        for  message in self.msgs {
            if (snapshot.key == message.key) {
                return index
            }
            index += 1
        }
        return -1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return msgs.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("messageCell", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel?.text = self.msgs[indexPath.row].value!["message"] as? String
        return cell
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
            print(self.messagesRef.child(self.msgs[indexPath.row].key))
            self.messagesRef.child(self.msgs[indexPath.row].key).removeValue()
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }

    func textViewDidBeginEditing(textView: UITextView) {
        // -- Coming UITextViewExtension
        addPlaceHolderToTextView(textView, begin: true)
    }

    func textViewDidEndEditing(textView: UITextView) {
        // -- Coming UITextViewExtension
        addPlaceHolderToTextView(textView, begin: false)
        
        self.loadViewIfNeeded()
        UIView.animateWithDuration(keyboard.Duration, delay: 0.0, options: UIViewAnimationOptions(rawValue: keyboard.Curve), animations: {_ in
            self.MessageViewHeightConstraint.constant = 60
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    
    // -- Keyboard to be shown animated and change the height accordingly with the keyboard
    func keyboardShown(notification: NSNotification) {
        let info  = notification.userInfo!
        let value: AnyObject = info[UIKeyboardFrameEndUserInfoKey]!
        let rawFrame = value.CGRectValue
        keyboard.KeyBoardHeight = view.convertRect(rawFrame, fromView: nil).height
        keyboard.Duration = NSTimeInterval(info[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber)
        keyboard.Curve = UInt(info[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber)
        
        self.loadViewIfNeeded()
        UIView.animateWithDuration(keyboard.Duration, delay: 0.0, options: UIViewAnimationOptions(rawValue: keyboard.Curve), animations: { _ in
            self.MessageViewHeightConstraint.constant = self.keyboard.KeyBoardHeight + 55
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
}