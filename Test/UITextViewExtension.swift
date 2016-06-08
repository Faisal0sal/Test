//
//  TextViewExtensions.swift
//  Test
//
//  Created by F M S ALSALAMAH on 21/05/2016.
//  Copyright © 2016 F M S ALSALAMAH. All rights reserved.
//
import UIKit

extension UIViewController {
    
    internal func addPlaceHolderToTextView(textView: UITextView, begin : Bool) {
        
        if begin {
            if textView.text == "Type a message" {
                textView.text = ""
                textView.textColor = UIColor.blackColor()
            }
        }else{
            if textView.text == "" {
                textView.text = "Type a message"
                textView.textColor = UIColor.lightGrayColor()
            }
        }
    }
    
    func dismissKeyBoardOnEndEditing() {
        
        // Get the view
        let View = self.view.viewWithTag(1000)
        // MARK: use old selector
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissMaskView))
        View!.addGestureRecognizer(tap)
        tap.cancelsTouchesInView = false
    }
    
    func dismissMaskView(){
        view.endEditing(true)
    }
    
    func animateViewMoving (up:Bool, moveValue :CGFloat){
        let movementDuration:NSTimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.view.frame = CGRectOffset(self.view.frame, 0,  movement)
        UIView.commitAnimations()
    }
}