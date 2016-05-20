//
//  UdacityClient.swift
//  On The Map
//
//  Created by Leoncio Perez on 5/18/16.
//  Copyright © 2016 Leoncio Perez. All rights reserved.
//

import Foundation
import UIKit

class UdacityClient : NSObject {
    
    var session: NSURLSession
    
    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }
    
    func taskForGETMethod(server: String, method: String, parameters: [String : AnyObject], completionHandler: (result: AnyObject, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        var mutableParameters = parameters
        
        var baseUrl : String = ""
        if (server == RequestToServer.udacity) {
            baseUrl = Constants.UdacityBaseURL
        } else if (server == RequestToServer.parse) {
            baseUrl = Constants.ParseBaseURL
        }
        
        let urlString = baseUrl + method + UdacityClient.escapedParameters(mutableParameters)
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        
        if (server == RequestToServer.parse) {
            request.addValue(Constants.parseAppId, forHTTPHeaderField: "X-Parse-Application-Id")
            request.addValue(Constants.parseApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        let task = session.dataTaskWithRequest(request) { data, response, downloadError in
            if downloadError != nil {
                completionHandler(result: nil, error: downloadError)
            } else {
                var newData: NSData?
                newData = nil
                if (server == RequestToServer.udacity) {
                    newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
                }
                if newData != nil {
                    UdacityClient.parseJSONWithCompletionHandler(newData!, completionHandler: completionHandler)
                }
                else {
                    UdacityClient.parseJSONWithCompltionHandler(data, completionHandler: completionHandler)
                }
            }
        }
        
        task.resume()
        return task
    }
    
    func taskForPOSTMethod(server: String, method: String, parameters: [String : AnyObject], jsonBody: [String:AnyObject], subdata: Int, completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        var mutableParameters = parameters
        
        var baseUrl : String = ""
        if (server == RequestToServer.udacity) {
            baseUrl = Constants.UdacityBaseURL
        } else if (server == RequestToServer.parse) {
            baseUrl = Constants.ParseBaseURL
        }
        
        let urlString = baseUrl + method + UdacityClient.escapedParameters(mutableParameters)
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        var jsonifyError: NSError? = nil
        request.HTTPMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(jsonBody, options: nil, error: &jsonifyError)
        
        if (server == RequestToServer.parse) {
            request.addValue(Constants.parseAppId, forHTTPHeaderField: "X-Parse-Application-Id")
            request.addValue(Constants.parseApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        } else {
            request.addValue("application/json", forHTTPHeaderField: "Accept")
        }
        
        let task = session.dataTaskWithRequest(request) { data, response, downloadError in
            if downloadError != nil {
                completionHandler(result: nil, error: downloadError)
            } else {
                var newData: NSData?
                newData = nil
                if subdata > 0 {
                    newData = data.subdataWithRange(NSMakeRange(subdata, data.length - subdata))
                }
                if newData != nil {
                    UdacityClient.parseJSONWithCompletionHandler(newData!, completionHandler: completionHandler)
                }
                else {
                    UdacityClient.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
                }
            }
        }
        
        task.resume()
        return task
    }
    
    class func subtituteKeyInMethod(method: String, key: String, value: String) -> String? {
        if method.rangeOfString("{\(key)}") != nil {
            return method.stringByReplacingOccurrencesOfString("{\(key)}", withString: value)
        } else {
            return nil
        }
    }
    
    class func parseJSONWithCompletionHandler(data: NSData, completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        
        var parsingError: NSError? = nil
        
        let parsedResult: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &parsingError)
        
        if let error = parsingError {
            completionHandler(result: nil, error: error)
        } else {
            completionHandler(result: parsedResult, error: nil)
        }
    }
    
    class func escapedParameters(parameters: [String : AnyObject]) -> String {
        var urlVars = [String]()
        
        for (key,value) in parameters {
            if(!key.isEmpty) {
                let stringValue = "\(value)"
                let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
                urlVars += [key + "=" + "\(escapedValue)"]
            }
        }
        return (!urlVars.isEmpty ? "?" : "") + join("&", urlVars)
    }
    
    func showAlert(message: NSError, viewController: AnyObject) {
        var errMessage = message.localizedDescription
        
        var alert = UIAlertController(title: nil, message: errMessage, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { action in
            alert.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        viewController.presentViewController(alert, animated: true, completion: nil)
    }
    
    func openURL(urlString: String) {
        let url = NSURL(string: urlString)
        UIApplication.sharedApplication().openURL(url!)
    }
    
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
}