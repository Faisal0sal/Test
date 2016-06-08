//
//  ViewController.swift
//  Test
//
//  Created by F M S ALSALAMAH on 21/05/2016.
//  Copyright © 2016 F M S ALSALAMAH. All rights reserved.
//
import UIKit
import Firebase

class Login: UIViewController, UITextFieldDelegate {
    
    // -- Fields
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    // -- Buttons
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    
    // -- Error bar
    @IBOutlet weak var errorLabel: UILabel!
    
    // -- Loading Indicator
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    // -- Login
    @IBAction func Login(sender: AnyObject) {
        let email = emailField.text
        let password = passwordField.text
        loginBtn.hidden = true
        loadingIndicator.startAnimating()
        
        UIView.animateWithDuration(0.5, animations: {
            self.emailField.alpha = 0
            self.passwordField.alpha = 0
        })
        
        // -- Firebase : Sign in with Email
        FIRAuth.auth()?.signInWithEmail(email!, password: password!, completion: { (user, error) in
            if let error = error {
                print(error.localizedDescription)
                UIView.animateWithDuration(1, animations: {
                    self.loginBtn.hidden = false
                    self.loadingIndicator.stopAnimating()
                    
                    self.errorLabel.hidden = false
                    
                    self.emailField.alpha = 1
                    self.passwordField.alpha = 1
                })
                return
            }
            self.loggedIn(user!)
        })
    }
    
    
    // -- Register
    @IBAction func Register(sender: AnyObject) {
        let email = emailField.text
        let password = passwordField.text
        
        // -- Firebase : Register
        FIRAuth.auth()?.createUserWithEmail(email!, password: password!, completion: { (user, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
        })
    }
    
    
    override func viewDidLoad() {
        // -- Check if the user is logged in
        if let user = FIRAuth.auth()?.currentUser {
            self.loggedIn(user)
        }
        
        // -- Add bottom borders to buttons
        emailField.addBorder(.Bottom, color: UIColor(red: CGFloat(207/255.0), green: CGFloat(207/255.0), blue: CGFloat(207/255.0), alpha: CGFloat(1.0)), width: 2.0)
        passwordField.addBorder(.Bottom, color: UIColor(red: CGFloat(207/255.0), green: CGFloat(207/255.0), blue: CGFloat(207/255.0), alpha: CGFloat(1.0)), width: 2.0)
    }
    
    func loggedIn(user: FIRUser) {
        AppState.sharedInstance.uid = user.uid
        AppState.sharedInstance.displayName = user.displayName ?? user.email
        AppState.sharedInstance.photoUrl = user.photoURL
        AppState.sharedInstance.signedIn = true
        NSNotificationCenter.defaultCenter().postNotificationName(Constants.NotificationKeys.SignedIn, object: nil, userInfo: nil)
        performSegueWithIdentifier(Constants.Segues.LogInTo, sender: nil)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        animateViewMoving(true, moveValue: 200)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        animateViewMoving(false, moveValue: 200)
    }
}