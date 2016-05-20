//
//  StudentInformation.swift
//  On The Map
//
//  Created by Leoncio Perez on 5/10/16.
//  Copyright © 2016 Leoncio Perez. All rights reserved.
//

import Foundation
import MapKit

struct StudentInformation {
    var firstName = ""
    var lastName = ""
    var latitude : CLLocationDegrees = CLLocationDegrees()
    var longitude : CLLocationDegrees = CLLocationDegrees()
    var mediaURL = ""
    var studentId = ""
    
    //Student Dictionary
    init(dictionary: [String : AnyObject]) {
        firstName = dictionary[UdacityClient.JSONResponseKeys.FirstName] as! String
        lastName = dictionary[UdacityClient.JSONResponseKeys.LastName] as! String
        latitude = dictionary[UdacityClient.JSONResponseKeys.Latitude] as! CLLocationDegrees
        longitude = dictionary[UdacityClient.JSONResponseKeys.Longitude] as! CLLocationDegrees
        mediaURL = dictionary[UdacityClient.JSONResponseKeys.MediaUrl] as! String
    }
    
    static func convertFromDictionaries(arry: [[String : AnyObject]]) -> [StudentInformation] {
        var resultArray = [StudentInformation]()
        
        for dictionary in resultArray {
            resultArray.append(StudentInformation(dictionary: dictionary))
        }
        
        return resultArray
    }
}

