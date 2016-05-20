//
//  LoginViewController.swift
//  On The Map
//
//  Created by Leoncio Perez on 5/10/16.
//  Copyright © 2016 Leoncio Perez. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var tapRecognizer: UITapGestureRecognizer? = nil
    var keyboardAdjusted = false
    var lastKeyboardOffset : CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tapRecognizer?.numberOfTapsRequired = 1
    }
    
    override func viewWillAppear(animated: Bool) {
        self.addKeyboardDismissRecognizer()
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.removeKeyboardDismissRecognizer()
        self.unsubscribeToKeyboardNotifications()
    }
    
    @IBAction func loginAction(sender: UIButton) {
        self.showActivityIndicator()
        
        self.view.endEditing(true)
        
        UdacityClient.sharedInstance().userLogin(emailField.text, password: passwordField.text) { (result, error) -> Void in
            
            if error != nil {
                dispatch_async(dispatch_get_main_queue(), {
                    UdacityClient.sharedInstance().showAlert(error!, viewController: self)
                    self.hideActivityIndicator()
                })
            }
            else {
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.studentKey = result!
                dispatch_async(dispatch_get_main_queue(), {
                    self.hideActivityIndicator()
                    println("OK - key = \(appDelegate.studentKey)")
                    self.goToNextView()
                })
            }
        }
    }
    
    @IBAction func loginFacebookAction(sender: UIButton) {
        self.goToNextView()
    }
    
    @IBAction func signupAction(sender: UIButton) {
        
        let signUpURL = "https://www.udacity.com/account/auth#!/signup"
        UIApplication.sharedApplication().openURL(NSURL(string: signUpURL)!)
        
    }

    func goToNextView() {
        var tabBarController:UITabBarController = self.storyboard!.instantiateViewControllerWithIdentifier("tabBarController") as! UITabBarController
        self.presentViewController(tabBarController, animated: true, completion: nil)
    }
    
    func showActivityIndicator() {
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        loginButton.hidden = true
    }
    
    func hideActivityIndicator() {
        activityIndicator.hidden = true
        activityIndicator.stopAnimating()
        loginButton.hidden = false
    }
    
    func addKeyboardDismissRecognizer() {
        self.view.addGestureRecognizer(tapRecognizer!)
    }
    
    func removeKeyboardDismissRecognizer() {
        self.view.removeGestureRecognizer(tapRecognizer!)
    }
    
    func handleSingleTap(recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if keyboardAdjusted == false {
            lastKeyboardOffset = getKeyboardHeight(notification) / 2
            self.view.superview?.frame.origin.y -= lastKeyboardOffset
            keyboardAdjusted = true
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if keyboardAdjusted == true {
            self.view.superview?.frame.origin.y += lastKeyboardOffset
            keyboardAdjusted = false
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
}