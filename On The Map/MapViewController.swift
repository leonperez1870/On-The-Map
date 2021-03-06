//
//  MapViewController.swift
//  On The Map
//
//  Created by Leoncio Perez on 5/24/16.
//  Copyright © 2016 Leoncio Perez. All rights reserved.
//

import MapKit
import UIKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        removeAllAnnotations()
        addAllAnnotations()
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier("pin") as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            pinView!.canShowCallout = true
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        } else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.sharedApplication()
            if let toOpen = view.annotation?.subtitle! {
                app.openURL(NSURL(string: toOpen)!)
            }
        }
    }
    
    func removeAllAnnotations() {
        let annotationsToRemove = mapView.annotations.filter { $0 !== mapView.userLocation }
        mapView.removeAnnotations(annotationsToRemove)
    }
    
    func addAllAnnotations() {
        var annotations = [MKPointAnnotation]()
        for studentInfo in OnTheMapModel.sharedInstance().studentInfos {
            let annotation = MKPointAnnotation()
            
            annotation.coordinate = CLLocationCoordinate2D(latitude: studentInfo.latitude, longitude: studentInfo.longitude)
            annotation.title = studentInfo.fullName()
            annotation.subtitle = studentInfo.linkUrl
            
            annotations.append(annotation)
        }
        mapView.addAnnotations(annotations)
    }
    
    func loadMapDataAndDisplay() {
        OnTheMapModel.sharedInstance().loadStudentInfos { (success, errorString) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                if success {
                    self.removeAllAnnotations()
                    self.addAllAnnotations()
                } else {
                    let alert = UIAlertController(title: "Error", message: errorString, preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            })
        }
    }
    
    @IBAction func logoutButtonPushed(sender: AnyObject) {
        OnTheMapModel.sharedInstance().logout()
        let loginController = self.storyboard!.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
        self.presentViewController(loginController, animated: true, completion: nil)
    }
    
    @IBAction func refreshButtonPushed(sender: AnyObject) {
        loadMapDataAndDisplay()
    }
}
