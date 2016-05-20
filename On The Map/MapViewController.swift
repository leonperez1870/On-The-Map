//
//  MapViewController.swift
//  On The Map
//
//  Created by Leoncio Perez on 5/10/16.
//  Copyright © 2016 Leoncio Perez. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    @IBOutlet weak var map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var pinButton : UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "pin"), landscapeImagePhone: nil, style: UIBarButtonItemStyle.Plain, target: self, action: "addPinAction")
        var refreshButton : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: "reloadAction")
        self.navigationItem.rightBarButtonItems = [refreshButton, pinButton]
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.Done, target: self, action: "logout")
    }
    
    override func viewWillAppear(animated: Bool) {
        self.reloadUsersData()
    }
    
    func addPinAction() {
        var postController:UIViewController = self.storyboard!.instantiateViewControllerWithIdentifier("postView") as! UIViewController
        //self.presentViewController(postController, animated: true, completion: nil)
        self.navigationController?.pushViewController(postController, animated: true)
    }
    
    func reloadAction() {
        self.reloadUsersData()
    }
    
    func reloadUsersData() {
        var student = [StudentInformation]()
        UdacityClient.sharedInstance().getStudentLocations { users, error in
            if let usersData =  users {
                dispatch_async(dispatch_get_main_queue(), {
                    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    appDelegate.usersData = usersData
                    UdacityClient.sharedInstance().createAnnotations(usersData, mapView: self.map)
                })
            } else {
                if error != nil {
                    UdacityClient.sharedInstance().showAlert(error!, viewController: self)
                }
            }
        }
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if annotation is MKPointAnnotation {
            let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "myPin")
            pinView.pinColor = .Red
            pinView.canShowCallout = true
            
            // pin button
            let pinButton = UIButton.buttonWithType(UIButtonType.InfoLight) as! UIButton
            pinButton.frame.size.width = 44
            pinButton.frame.size.height = 44
            
            pinView.rightCalloutAccessoryView = pinButton
            
            return pinView
        }
        return nil
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        // open url
        UdacityClient.sharedInstance().openURL(view.annotation.subtitle!)
    }
    
    func logout() {
        UdacityClient.sharedInstance().logout(self)
    }
    
}