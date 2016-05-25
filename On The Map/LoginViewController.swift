//
//  LoginViewController.swift
//  On The Map
//
//  Created by Leoncio Perez on 5/24/16.
//  Copyright © 2016 Leoncio Perez. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    //@IBOutlet weak var facebookLoginButton: FBSDKLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //FacebookClient.logout()
    }
    
    @IBAction func loginButtonClicked(sender: AnyObject) {
        guard (!emailTextField.text!.isEmpty && !passwordTextField.text!.isEmpty) else {
            let alert = UIAlertController(title: "Error", message: "Please enter your Email and/or password", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        OnTheMapModel.sharedInstance().login(emailTextField.text!, password: passwordTextField.text!) { (success, errorString) -> Void in
            guard success else {
                dispatch_async(dispatch_get_main_queue(), {
                    let alert = UIAlertController(title: "Error", message: errorString, preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                })
                return
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                let tabBarController = self.storyboard!.instantiateViewControllerWithIdentifier("TabBarController") as! UITabBarController
                self.presentViewController(tabBarController, animated: true, completion: nil)
            })
            
        }
    }
}
