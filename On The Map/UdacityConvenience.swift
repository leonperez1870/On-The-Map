//
//  UdacityConvenience.swift
//  On The Map
//
//  Created by Leoncio Perez on 5/18/16.
//  Copyright © 2016 Leoncio Perez. All rights reserved.
//

import Foundation
import UIKit
import MapKit

extension UdacityClient {
    
    func userLogin(email: String, password: String, completionHandler: (result: String?, error: NSError?) -> Void) {
        
        var method = Methods.CreateSession
        
        let parameters : [String:String] = [
            UdacityClient.JSONBodyKeys.Username: email,
            UdacityClient.JSONBodyKeys.Password: password
        ]
        
        let jsonBody : [String:AnyObject] = [
            UdacityClient.JSONBodyKeys.Udacity: parameters
        ]
        
        let task = taskForPOSTMethod(UdacityClient.RequestToServer.udacity, method: Methods.CreateSession, parameters: parameters, jsonBody: jsonBody, subdata: 5) { (result, error) -> Void in
            if error != nil {
                completionHandler(result: nil, error: error)
            } else {
                if let errorMsg = result.valueForKey(UdacityClient.JSONResponseKeys.Error) as? String {
                    completionHandler(result: nil, error: NSError(domain: "udacity fucked up", code: 0, userInfo: [NSLocalizedDescriptionKey: errorMsg]))
                } else {
                    let session = result["account"] as! NSDictionary
                    let key = session["key"] as! String
                    completionHandler(result: key, error: nil)
                }
            }
        }
    }
    
    func getStudentLocations(completionHandler: (result: [StudentInformation]?, error: NSError?) -> Void) {
        let task = taskForGETMethod(UdacityClient.RequestToServer.parse, method: Methods.limit, parameters: ["limit":200]) { (result, error) -> Void in
            if error != nil {
                completionHandler(result: nil, error: error)
            } else {
                if let locations = result as? [NSObject: NSObject] {
                    if let usersResult = locations["results"] as? [[String : AnyObject]] {
                        var studentsData = StudentInformation.convertFromDictionaries(usersResult)
                        completionHandler(result: studentsData, error: nil)
                    }
                }
            }
        }
    }
    
    func getUserPublicData(userId: String, completionHandler: (result: UserInformation?, error: NSError?) -> Void) {
        var method = Methods.Users + userId
        
        let task = taskForGETMethod(RequestToServer.udacity, method: Methods.Users + userId, parameters: ["":""]) { (result, error) -> Void in
            if error != nil {
                completionHandler(result: nil, error: error)
            } else {
                if let data = result["user"] as? NSDictionary {
                    var studentsInfo = UserInformation(dictionary: data)
                    completionHandler(result: studentsInfo, error: nil)
                }
            }
        }
    }
    
    func createAnnotations(users: [StudentInformation], mapView: MKMapView) {
        for user in users {
            var annotation = MKPointAnnotation()
            
            annotation.coordinate = CLLocationCoordinate2DMake(user.latitude, user.longitude)
            annotation.title = "\(user.firstName) \(user.lastName)"
            annotation.subtitle = user.mediaURL
            
            mapView.addAnnotation(annotation)
        }
    }
    
    func logoutRequest(completionHandler: (result: AnyObject?, error: NSError?)->Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: Constants.UdacityBaseURL + Methods.CreateSession)!)
        request.HTTPMethod = "DELETE"
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies! as [NSHTTPCookie] {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-Token")
        }
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                completionHandler(result: nil, error: error)
            }
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5))
            completionHandler(result: newData, error: nil)
        }
        task.resume()
    }
    
    func logout(viewController: AnyObject) {
        UdacityClient.sharedInstance().logoutRequest { (result, error) -> Void in
            if error != nil {
                UdacityClient.sharedInstance().showAlert(error!, viewController: viewController)
            }
            else {
                dispatch_async(dispatch_get_main_queue(), {
                    let loginView : LoginViewController = viewController.storyboard?!.instantiateViewControllerWithIdentifier("LoginView") as! LoginViewController
                    viewController.presentViewController(loginView, animated: true, completion: nil)
                })
            }
        }
    }
}